# n8n Enterprise Docker Build

> **🌐 [English](#english) | [فارسی](#persian)**

---

## ⚠️ Important Disclaimer / اطلاعیه مهم

<table>
<tr>
<td width="50%">

### 🇬🇧 English

**For Educational and Research Purposes Only**

- Technical solution based on [oskr.cn](https://oskr.cn)
- Commercial use or production deployment is **strictly prohibited**
- Please comply with local laws and software license agreements
- All responsibilities and risks are borne by the user

</td>
<td width="50%">

### 🇮🇷 فارسی

**فقط برای اهداف آموزشی و پژوهشی**

- راهکار فنی برگرفته از [oskr.cn](https://oskr.cn)
- استفاده تجاری یا استقرار در محیط تولیدی **اکیداً ممنوع** است
- لطفاً به قوانین محلی و توافقنامه لایسنس نرم‌افزارها پایبند باشید
- تمامی مسئولیت‌ها و ریسک‌ها بر عهده کاربر است

</td>
</tr>
</table>

---

<a name="english"></a>
# 🇬🇧 English Documentation

## Overview

This repository contains a GitHub Actions workflow that automatically builds n8n Docker images with Enterprise features enabled and pushes them to GitHub Container Registry (GHCR).

## Features

| Feature | Description |
|---------|-------------|
| 🔄 **Auto Build** | Scheduled weekly builds (Every Monday 6:00 AM UTC) |
| 🚀 **Manual Trigger** | Build on-demand via GitHub Actions UI |
| 📦 **Docker Caching** | Layer caching for faster builds |
| ✅ **Health Check** | Validates container before pushing |
| 🔍 **Version Check** | Skips build if version already exists |
| 🏷️ **Multi-tag** | Multiple tags for versioning |

## Quick Start

### Pull the Image

```bash
docker pull ghcr.io/chosomeister/n8n:enterprise
```

### Run n8n

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  ghcr.io/chosomeister/n8n:enterprise
```

### Access n8n

Open your browser and navigate to: `http://localhost:5678`

## Available Tags

| Tag | Description |
|-----|-------------|
| `enterprise` | Main enterprise build |
| `latest` | Latest successful build |
| `v2.x.x` | Specific n8n version |
| `n8n-<commit>` | Specific n8n commit hash |

## Workflow Details

### Triggers

- **Manual**: `workflow_dispatch` - Run from Actions tab
- **Scheduled**: Every Monday at 6:00 AM UTC

### Build Process

1. **Version Check** - Compares with existing GHCR images
2. **Clone n8n** - Fetches latest stable release
3. **Apply Bypass** - Enables Enterprise features
4. **Build** - Compiles n8n with turbo
5. **Docker Build** - Creates container image
6. **Health Check** - Tests container functionality
7. **Push** - Uploads to GHCR

### Smart Build Logic

| Trigger | Version Exists | Action |
|---------|----------------|--------|
| Scheduled | ✅ Yes | ⏭️ Skip |
| Scheduled | ❌ No | 🔨 Build |
| Manual | Any | 🔨 Build |

## Enterprise Features Enabled

- ✅ Custom Roles (Project Roles)
- ✅ MFA Enforcement
- ✅ LDAP / SAML / OIDC SSO
- ✅ Log Streaming
- ✅ Advanced Execution Filters
- ✅ Source Control
- ✅ External Secrets
- ✅ Debug in Editor
- ✅ Worker View
- ✅ Advanced Permissions
- ✅ API Key Scopes
- ✅ Workflow Diffs
- ✅ Unlimited Users
- ✅ Unlimited Workflows

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Build fails | Check Actions logs for details |
| Image not found | Ensure package is public or you're authenticated |
| Features not working | Pull latest image and recreate container |

---

<a name="persian"></a>
# 🇮🇷 مستندات فارسی

## معرفی

این ریپازیتوری شامل یک GitHub Actions workflow است که به صورت خودکار Docker image های n8n با قابلیت‌های Enterprise فعال می‌سازد و به GitHub Container Registry (GHCR) push می‌کند.

## قابلیت‌ها

| قابلیت | توضیحات |
|--------|---------|
| 🔄 **بیلد خودکار** | هر هفته دوشنبه ساعت ۶ صبح UTC |
| 🚀 **بیلد دستی** | از طریق GitHub Actions |
| 📦 **کش Docker** | لایه کش برای بیلد سریع‌تر |
| ✅ **Health Check** | تست container قبل از push |
| 🔍 **Version Check** | عدم بیلد تکراری |
| 🏷️ **چند برچسب** | برچسب‌های متعدد برای نسخه‌بندی |

## شروع سریع

### دریافت Image

```bash
docker pull ghcr.io/chosomeister/n8n:enterprise
```

### اجرای n8n

```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  ghcr.io/chosomeister/n8n:enterprise
```

### دسترسی به n8n

مرورگر را باز کنید و به آدرس زیر بروید: `http://localhost:5678`

## برچسب‌های موجود

| برچسب | توضیحات |
|-------|---------|
| `enterprise` | بیلد اصلی Enterprise |
| `latest` | آخرین بیلد موفق |
| `v2.x.x` | نسخه خاص n8n |
| `n8n-<commit>` | کامیت خاص n8n |

## جزئیات Workflow

### تریگرها

- **دستی**: `workflow_dispatch` - از تب Actions
- **زمان‌بندی شده**: هر دوشنبه ساعت ۶ صبح UTC

### فرآیند بیلد

1. **بررسی نسخه** - مقایسه با image های موجود در GHCR
2. **کلون n8n** - دریافت آخرین نسخه پایدار
3. **اعمال Bypass** - فعال‌سازی قابلیت‌های Enterprise
4. **بیلد** - کامپایل n8n با turbo
5. **بیلد Docker** - ساخت container image
6. **Health Check** - تست عملکرد container
7. **Push** - آپلود به GHCR

### منطق بیلد هوشمند

| تریگر | نسخه موجود؟ | عملکرد |
|-------|-------------|--------|
| زمان‌بندی | ✅ بله | ⏭️ Skip |
| زمان‌بندی | ❌ خیر | 🔨 بیلد |
| دستی | هر حالتی | 🔨 بیلد |

## قابلیت‌های Enterprise فعال شده

- ✅ نقش‌های سفارشی (Project Roles)
- ✅ اجبار MFA
- ✅ LDAP / SAML / OIDC SSO
- ✅ Log Streaming
- ✅ فیلترهای اجرای پیشرفته
- ✅ Source Control
- ✅ External Secrets
- ✅ Debug در Editor
- ✅ نمای Worker
- ✅ دسترسی‌های پیشرفته
- ✅ API Key Scopes
- ✅ Workflow Diffs
- ✅ کاربران نامحدود
- ✅ Workflow های نامحدود

## عیب‌یابی

| مشکل | راه‌حل |
|------|--------|
| بیلد fail شد | لاگ‌های Actions را بررسی کنید |
| Image پیدا نشد | مطمئن شوید package عمومی است یا وارد شده‌اید |
| قابلیت‌ها کار نمی‌کنند | آخرین image را pull و container را بازسازی کنید |

---

## License

This project is for educational purposes only. Please respect software licenses and local laws.

---

<p align="center">
  <b>Made with ❤️ for learning purposes</b>
</p>
