#!/bin/bash

# Script to apply license bypass modifications for development
# This script applies the license bypass changes to enable all Enterprise features
#
# Usage:
#   ./bypass.sh           # Interactive mode
#   ./bypass.sh --auto    # Non-interactive mode for CI/CD

set -e

# ============================================
# Configuration
# ============================================

AUTO_MODE=false
if [[ "$1" == "--auto" || "$CI" == "true" || -n "$GITHUB_ACTIONS" ]]; then
    AUTO_MODE=true
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Track errors
ERRORS=()
WARNINGS=()

# File paths
LICENSE_FILE="packages/cli/src/license.ts"
LICENSE_STATE_FILE="packages/@n8n/backend-common/src/license-state.ts"
DOCKER_FILE="docker/images/n8n/Dockerfile"

# ============================================
# Helper Functions
# ============================================

# Cross-platform sed wrapper (macOS vs Linux compatibility)
cross_sed() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "$@"
    else
        sed -i "$@"
    fi
}

# Safe sed with error tracking
safe_sed() {
    local pattern="$1"
    local file="$2"
    local description="${3:-$pattern}"
    
    if ! cross_sed "$pattern" "$file" 2>/dev/null; then
        WARNINGS+=("Sed pattern may not have matched: $description in $file")
    fi
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Rollback function
rollback() {
    log_warning "Rolling back changes..."
    [[ -f "${LICENSE_FILE}.backup" ]] && mv "${LICENSE_FILE}.backup" "$LICENSE_FILE"
    [[ -f "${LICENSE_STATE_FILE}.backup" ]] && mv "${LICENSE_STATE_FILE}.backup" "$LICENSE_STATE_FILE"
    log_info "Rollback completed"
}

# ============================================
# Main Script
# ============================================

echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       n8n License Bypass Script - Enterprise Edition       ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo

# Check if we're in a git repository
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    log_error "Not in a git repository"
    exit 1
fi

# Display current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "detached")
log_info "Current branch: ${CURRENT_BRANCH}"

# Validate required files exist
if [[ ! -f "$LICENSE_FILE" ]]; then
    log_error "License file not found: $LICENSE_FILE"
    exit 1
fi

if [[ ! -f "$LICENSE_STATE_FILE" ]]; then
    log_error "License state file not found: $LICENSE_STATE_FILE"
    exit 1
fi

# Check if already applied
if grep -q "return true;" "$LICENSE_FILE" && grep -q "Enterprise Edition" "$LICENSE_FILE"; then
    log_success "License bypass already applied! Development mode is ready."
    exit 0
fi

log_info "Applying license bypass for development..."

# Create backups
log_info "Creating backups..."
cp "$LICENSE_FILE" "${LICENSE_FILE}.backup"
cp "$LICENSE_STATE_FILE" "${LICENSE_STATE_FILE}.backup"

# Set trap for rollback on error
trap rollback ERR

# ============================================
# Apply changes to license.ts
# ============================================

log_info "Modifying $LICENSE_FILE..."

# Replace license renewal warning
safe_sed 's/const LICENSE_RENEWAL_DISABLED_WARNING =.*/const LICENSE_RENEWAL_DISABLED_WARNING = '\''Enterprise Edition'\'';/' "$LICENSE_FILE" "LICENSE_RENEWAL_DISABLED_WARNING"

# Replace isLicensed method with smart logic:
# - Return false for 'feat:showNonProdBanner' (to HIDE the non-prod banner)
# - Return false for 'feat:apiDisabled' (to ENABLE API access)
# - Return true for all other features
safe_sed "s/isLicensed(feature: BooleanLicenseFeature) {/isLicensed(feature: BooleanLicenseFeature) { if (feature === 'feat:showNonProdBanner' || feature === 'feat:apiDisabled') return false;/g" "$LICENSE_FILE" "isLicensed smart logic"

# Replace all license feature checks to return true
safe_sed 's/return this\.isLicensed(LICENSE_FEATURES\.[^)]*);/return true;/g' "$LICENSE_FILE" "LICENSE_FEATURES checks"

# Handle isAPIDisabled specially (should return false to enable API)
safe_sed '/isAPIDisabled() {/,/}/ {
    s/return this\.isLicensed(LICENSE_FEATURES\.API_DISABLED);/return false;/
    s/return true;/return false;/
}' "$LICENSE_FILE" "isAPIDisabled"

# Replace quota methods with unlimited values
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.USERS_LIMIT) ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_FILE" "USERS_LIMIT"
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.TRIGGER_LIMIT) ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_FILE" "TRIGGER_LIMIT"
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.VARIABLES_LIMIT) ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_FILE" "VARIABLES_LIMIT"
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.AI_CREDITS) ?? 0;/return 0;/' "$LICENSE_FILE" "AI_CREDITS"
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.WORKFLOW_HISTORY_PRUNE_LIMIT) ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_FILE" "WORKFLOW_HISTORY_PRUNE_LIMIT"
safe_sed 's/return this\.getValue(LICENSE_QUOTAS\.TEAM_PROJECT_LIMIT) ?? 0;/return 999;/' "$LICENSE_FILE" "TEAM_PROJECT_LIMIT"

# Replace plan name
safe_sed 's/return this\.getValue('\''planName'\'') ?? '\''Community'\'';/return this.getValue('\''planName'\'') ?? '\''Enterprise'\'';/' "$LICENSE_FILE" "planName"

log_success "Applied license bypass to $LICENSE_FILE"

# ============================================
# Apply changes to license-state.ts
# ============================================

log_info "Modifying $LICENSE_STATE_FILE..."

# For license-state.ts, we use a simpler approach:
# Replace the body of isLicensed to always return true
# The function handles both string and array types, so we replace the return false at the end
safe_sed "s/return false;$/return true;/g" "$LICENSE_STATE_FILE" "LicenseState return false to true"

# Also ensure isAPIDisabled returns false (API should be enabled)
safe_sed "s/return this\.isLicensed('feat:apiDisabled');/return false;/g" "$LICENSE_STATE_FILE" "LicenseState.isAPIDisabled"

# Replace quota methods with unlimited/high values
safe_sed 's/return this\.getValue('\''quota:users'\'') ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_STATE_FILE" "quota:users"
safe_sed 's/return this\.getValue('\''quota:activeWorkflows'\'') ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_STATE_FILE" "quota:activeWorkflows"
safe_sed 's/return this\.getValue('\''quota:maxVariables'\'') ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_STATE_FILE" "quota:maxVariables"
safe_sed 's/return this\.getValue('\''quota:aiCredits'\'') ?? 0;/return 9999;/' "$LICENSE_STATE_FILE" "quota:aiCredits"
safe_sed 's/return this\.getValue('\''quota:workflowHistoryPrune'\'') ?? UNLIMITED_LICENSE_QUOTA;/return UNLIMITED_LICENSE_QUOTA;/' "$LICENSE_STATE_FILE" "quota:workflowHistoryPrune"
safe_sed 's/return this\.getValue('\''quota:insights:maxHistoryDays'\'') ?? 7;/return 365;/' "$LICENSE_STATE_FILE" "quota:insights:maxHistoryDays"
safe_sed 's/return this\.getValue('\''quota:insights:retention:maxAgeDays'\'') ?? 180;/return 365;/' "$LICENSE_STATE_FILE" "quota:insights:retention:maxAgeDays"
safe_sed 's/return this\.getValue('\''quota:insights:retention:pruneIntervalDays'\'') ?? 24;/return 365;/' "$LICENSE_STATE_FILE" "quota:insights:retention:pruneIntervalDays"
safe_sed 's/return this\.getValue('\''quota:maxTeamProjects'\'') ?? 0;/return 99999;/' "$LICENSE_STATE_FILE" "quota:maxTeamProjects"
safe_sed 's/return this\.getValue('\''quota:evaluations:maxWorkflows'\'') ?? 0;/return 99999;/' "$LICENSE_STATE_FILE" "quota:evaluations:maxWorkflows"

log_success "Applied license bypass to $LICENSE_STATE_FILE"

# ============================================
# Update Dockerfile for stable release type
# ============================================

if [[ -f "$DOCKER_FILE" ]]; then
    log_info "Updating Dockerfile release type..."
    safe_sed 's/^ARG N8N_RELEASE_TYPE=dev$/ARG N8N_RELEASE_TYPE=stable/' "$DOCKER_FILE" "N8N_RELEASE_TYPE"
    log_success "Updated Dockerfile to use stable release type"
else
    log_warning "Dockerfile not found at $DOCKER_FILE"
fi

# Disable trap after successful completion
trap - ERR

# ============================================
# Summary
# ============================================

echo
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║               License Bypass Applied Successfully          ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"

# Display warnings if any
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    echo
    log_warning "The following patterns may not have matched (this might be OK if n8n structure changed):"
    for warning in "${WARNINGS[@]}"; do
        echo -e "  ${YELLOW}•${NC} $warning"
    done
fi

echo
log_info "Backup files created with .backup extension"
log_info "Run 'pnpm build:n8n' to rebuild with license bypass"

# Show git status
echo
log_info "Git status:"
git status --short

# Optional: Commit changes
if [[ "$AUTO_MODE" == "true" ]]; then
    log_success "Auto mode: Changes applied successfully for CI/CD"
else
    echo
    read -p "Do you want to commit these changes? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git add .
        git commit -m "Apply license bypass for Enterprise features

- All license checks now return true
- Unlimited quotas for users, workflows, variables
- AI credits set to 9999
- Plan name set to Enterprise
- N8N_RELEASE_TYPE set to stable
"
        log_success "Changes committed successfully!"
    fi
fi

echo
log_success "n8n is now ready with all Enterprise features enabled!"
