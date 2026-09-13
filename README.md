# HyperOS-Dialer-Port

Android 15 / HyperOS OS3 EEA systemless port work for Xiaomi `mondrian`.

## Current target

- Device: `mondrian`
- ROM: HyperOS OS3 EEA
- Android API: 35
- Architecture: arm64-v8a
- Target components: China HyperOS InCallUI + MIUI Contacts
- TeleService: **EEA version is retained**
- Installation model: KernelSU/meta-overlayfs systemless overlay

## Safety policy

This project does not use the Android 13/14 installer from the reference module. It does not blindly `pm install` the China InCallUI APK, uninstall Google Dialer/Contacts updates, or replace EEA TeleService.

APK payloads are added only after their Android 15 compatibility and required privileged permissions are verified.

## Layout

```text
module.prop
customize.sh
system.prop
system/etc/permissions/
product/priv-app/
product/overlay/
tools/
docs/
.github/workflows/
```

See `docs/android15-port-analysis.md` for the compatibility findings.
