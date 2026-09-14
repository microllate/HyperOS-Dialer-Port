# Android 15 payload policy

This port is based on the supplied `MIUI_HyperOS国内拨号.zip` module, but its Android 13/14 payload branches are not used directly. The original module is adapted for the target phone instead of being rebuilt from scratch.

## Authoritative source payload

The user-supplied APKs stored at the repository root on `main` are the source for this port:

1. China HyperOS InCallUI: package `com.android.incallui`, version `4.0.1.143` / versionCode `3722`, arm64-v8a. SHA-256: `9b18172465e80a7bb387e1bfdd6de0ca8debf93427cf7b15bb87030095e0f120`.
2. China MIUI Contacts: package `com.android.contacts`, version `16.8.05.21` / versionCode `80521`.
3. `TeleService.apk` is reference material only and is **not** a payload of this EEA module.

## Runtime constraints

- Target is HyperOS OS3 EEA, build `OS3.0.2.0.VMNEUXM`.
- Device is `mondrian` and ABI is `arm64-v8a`.
- Android 15/API 35.
- EEA `com.android.phone` / TeleService stays in place.
- Google Dialer and Contacts are not uninstalled by the module.
- APKs are mounted systemlessly; the installer must not depend on `pm install`.
- KernelSU/meta-overlayfs is the intended deployment path.

## Compatibility decision

The China InCallUI has direct MIUI TeleService references and expects MIUI-specific phone services. Therefore the port keeps EEA TeleService unchanged and limits the first usable build to the UI/Contacts side. This is the lowest-risk adaptation of the supplied module for this phone.

The original module's Android 13/14 installer cannot be copied unchanged because it has no Android 15 payload branch and performs package-management operations against Google Dialer/Contacts. Those operations are removed from this port.

## Build policy

The two China payload APKs are copied from the repository `main` branch into the module staging tree during CI. The generated ZIP contains only the China InCallUI and Contacts payloads plus the required module metadata, overlay resources, and privileged-permission allowlist. EEA TeleService is never copied into the generated module.
