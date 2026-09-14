# HyperOS-Dialer-Port

Android 15 / HyperOS OS3 EEA systemless port work for Xiaomi `mondrian`.

## Current target

- Device: `mondrian`
- ROM: HyperOS OS3 EEA / `OS3.0.2.0.VMNEUXM`
- Android API: 35
- Architecture: arm64-v8a
- China payload: HyperOS InCallUI + MIUI Contacts
- TeleService: **OS2 China `com.android.phone` is included**
- MMS: deferred
- Installation model: KernelSU/meta-overlayfs systemless overlay

## Port structure

The port follows the supplied domestic dialer module's component model while adapting its installer behavior for Android 15:

```text
product/priv-app/InCallUIPhoneHyperOS/
product/priv-app/MIUIContactsT/
system/priv-app/TeleService/
product/etc/permissions/
META-INF/zbin/
```

Exact native libraries are extracted from the OS2 APK payloads during CI. The original MMS/RCS stack is intentionally not included.

## Safety policy

The module does not execute the reference module's `pm install` or `pm uninstall-system-updates` operations and does not remove Google Dialer/Contacts updates. Payloads are mounted systemlessly.

The generated ZIP is structurally validated by GitHub Actions before any device test.

See `docs/android15-port-analysis.md` for the compatibility findings.
