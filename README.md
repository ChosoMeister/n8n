# 📚 n8n Enterprise Architecture Study

> **🌐 [English](#english) | [فارسی](#persian)**

---

## 🎓 Educational Purpose Statement / بیانیه هدف آموزشی

<table>
<tr>
<td width="50%">

### 🇬🇧 English

> [!CAUTION]
> **STRICTLY FOR EDUCATIONAL AND ACADEMIC RESEARCH PURPOSES ONLY**

This repository is an **academic research project** created to study and understand the architecture, feature flagging mechanisms, and enterprise software design patterns used in modern workflow automation platforms.

**⚠️ This project is:**
- ✅ For learning software architecture concepts
- ✅ For studying feature flag implementation patterns
- ✅ For academic research on enterprise software design
- ✅ For personal skill development in DevOps and CI/CD

**❌ This project is NOT:**
- ❌ For commercial use of any kind
- ❌ For production deployment
- ❌ A replacement for purchasing legitimate licenses
- ❌ Endorsed or supported by n8n GmbH

**Legal Notice:**
- Users must comply with all applicable laws and regulations
- Users must respect the original [n8n License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md)
- All responsibilities and legal risks are borne solely by the user
- **We strongly encourage supporting the original developers** by purchasing legitimate licenses at [n8n.io](https://n8n.io)

</td>
<td width="50%">

### 🇮🇷 فارسی

> [!CAUTION]
> **صرفاً برای اهداف آموزشی و پژوهش دانشگاهی**

این ریپازیتوری یک **پروژه تحقیقاتی آکادمیک** است که برای مطالعه و درک معماری، مکانیزم‌های feature flagging و الگوهای طراحی نرم‌افزار سازمانی در پلتفرم‌های اتوماسیون workflow مدرن ایجاد شده است.

**⚠️ این پروژه:**
- ✅ برای یادگیری مفاهیم معماری نرم‌افزار
- ✅ برای مطالعه الگوهای پیاده‌سازی feature flag
- ✅ برای تحقیق آکادمیک در طراحی نرم‌افزار سازمانی
- ✅ برای توسعه مهارت‌های شخصی در DevOps و CI/CD

**❌ این پروژه نیست:**
- ❌ برای استفاده تجاری از هر نوع
- ❌ برای استقرار در محیط تولیدی
- ❌ جایگزینی برای خرید لایسنس قانونی
- ❌ مورد تأیید یا پشتیبانی n8n GmbH

**اطلاعیه قانونی:**
- کاربران باید از قوانین و مقررات مربوطه پیروی کنند
- کاربران باید به [لایسنس اصلی n8n](https://github.com/n8n-io/n8n/blob/master/LICENSE.md) احترام بگذارند
- تمامی مسئولیت‌ها و ریسک‌های قانونی بر عهده کاربر است
- **ما اکیداً توصیه می‌کنیم از توسعه‌دهندگان اصلی حمایت کنید** با خرید لایسنس قانونی از [n8n.io](https://n8n.io)

</td>
</tr>
</table>

---

## 💡 Why This Project Exists / چرا این پروژه وجود دارد

<table>
<tr>
<td width="50%">

This project was created as part of an academic study to understand:

1. **Software Architecture**: How modern workflow automation platforms are designed
2. **Feature Flagging**: How enterprise features are gated and managed
3. **Docker & CI/CD**: Building automated container image pipelines
4. **Open Source Contribution**: Understanding codebase structure for future contributions

**This is NOT a "crack" or bypass tool.** It is a study of publicly available open-source code to understand software engineering practices.

</td>
<td width="50%">

این پروژه به عنوان بخشی از یک مطالعه آکادمیک برای درک موارد زیر ایجاد شده است:

1. **معماری نرم‌افزار**: طراحی پلتفرم‌های اتوماسیون workflow مدرن
2. **Feature Flagging**: نحوه مدیریت و محدودسازی ویژگی‌های سازمانی
3. **Docker و CI/CD**: ساخت خطوط لوله خودکار container image
4. **مشارکت در متن‌باز**: درک ساختار کد برای مشارکت‌های آینده

**این یک ابزار "کرک" یا دور زدن نیست.** این یک مطالعه بر روی کد متن‌باز عمومی برای درک روش‌های مهندسی نرم‌افزار است.

</td>
</tr>
</table>

---

## 🙏 Attribution & Credits

This project is based on [n8n](https://github.com/n8n-io/n8n), an amazing workflow automation tool created by [n8n GmbH](https://n8n.io).

- **Original Repository**: https://github.com/n8n-io/n8n
- **Official Website**: https://n8n.io
- **Support the Developers**: [Purchase a License](https://n8n.io/pricing)

We have immense respect for the n8n team and their incredible work. If you find n8n useful, **please consider purchasing a license to support ongoing development**.

---

<a name="english"></a>
# 🇬🇧 English Documentation

## Overview

This repository contains a GitHub Actions workflow created for **educational purposes** to study how Docker images are built and how feature flags work in enterprise software. The workflow demonstrates modern CI/CD practices using GitHub Actions and Container Registry.

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

## 📜 License & Legal

### Original n8n License

n8n is licensed under the [Sustainable Use License](https://github.com/n8n-io/n8n/blob/master/LICENSE.md). This educational project **does not grant any additional rights** beyond what is provided by the original license.

### Educational Use Disclaimer

> [!WARNING]
> This repository is provided "AS IS" for **educational and research purposes only**.
> 
> - No warranties or guarantees of any kind
> - Not intended for commercial or production use
> - Users are solely responsible for compliance with applicable laws
> - This project does not circumvent any licensing; it studies publicly available code

### Support the Original Developers

If you use n8n in any capacity, please consider:
- ⭐ **Starring** the [original n8n repository](https://github.com/n8n-io/n8n)
- 💰 **Purchasing a license** at [n8n.io/pricing](https://n8n.io/pricing)  
- 🤝 **Contributing** to the open-source project

---

<p align="center">
  <b>📚 Made for Learning & Academic Research 📚</b><br>
  <sub>Please respect software licenses and support open-source developers</sub>
</p>
