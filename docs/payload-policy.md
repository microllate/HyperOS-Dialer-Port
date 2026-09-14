# Android 15 payload policy

This port is based on the supplied `MIUI_HyperOS国内拨号.zip` module and keeps its domestic dialer component model while replacing the Android 13/14-only installer logic.

## Authoritative source payload

The user-supplied APKs stored at the repository root on `main` are the source for this port:

1. China HyperOS InCallUI: package `com.android.incallui`, version `4.0.1.143` / versionCode `3722`, arm64-v8a. SHA-256: `9b18172465e80a7bb387e1bfdd6de0ca8debf93427cf7b15bb87030095e0f120`.
2. China MIUI Contacts: package `com.android.contacts`, version `16.8.05.21` / versionCode `80521`.
3. China OS2 TeleService: package `com.android.phone`, version `15` / versionCode `35`, targetSdk 35, arm64-v8a.

## Runtime target

- Device: `mondrian`
- ROM: HyperOS OS3 EEA `OS3.0.2.0.VMNEUXM`
- Android 15/API 35
- ABI arm64-v8a
- China `com.android.phone` / TeleService replaces the EEA TeleService in the module
- Google Dialer and Contacts are not uninstalled by the module
- KernelSU/meta-overlayfs is the deployment path

## Native libraries

The build extracts `lib/arm64-v8a/*.so` from the exact OS2 InCallUI, Contacts and TeleService APKs. This avoids blindly copying Android 13/14 reference libraries.

## MMS

`com.android.mms` and its six native libraries remain disabled. They are not required to establish the core China dialer/Contacts/TeleService stack and would add an independent SMS/RCS provider conflict surface.

## Overlays

The reference module contains three Dialer overlays. They are not fabricated or replaced with placeholders. They will only enter the runtime payload after their target package/resource IDs are verified against the target OS3 resource table.

## Installer / zbin

The port retains the reference module's `META-INF/zbin` concept but uses an Android 15/mondrian-specific text implementation. It performs environment validation only; package-manager installation and Google Dialer/Contacts removal are intentionally absent.
