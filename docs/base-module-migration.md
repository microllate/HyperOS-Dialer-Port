# Base module migration

## Source module

This port is based on the supplied `MIUI_HyperOS国内拨号.zip` module. Its domestic dialer component model is retained; the Android 13/14-only installer behavior is adapted for Android 15.

## Runtime payload

- China HyperOS InCallUI
- MIUI Contacts
- China OS2 `com.android.phone` / TeleService
- Native libraries extracted from the exact OS2 APKs
- Minimal privileged-permission allowlist under `product/etc/permissions`
- `META-INF/zbin` Android 15/mondrian validation framework

## What is changed for this phone

Target device: Xiaomi `mondrian`.

Target ROM: HyperOS OS3 EEA, build `OS3.0.2.0.VMNEUXM`.

Target Android: 15 / API 35 / arm64-v8a.

The original module contains Android 13/14 InCallUI branches. Those are not used. The OS2 China APKs stored in `main` are authoritative.

The original `pm install` and `pm uninstall-system-updates` behavior is not copied. The payload is mounted systemlessly by KernelSU/meta-overlayfs.

## TeleService policy

China `com.android.phone` from the OS2 payload is included and replaces the EEA TeleService path in the module. This is required because the China InCallUI has direct MIUI TeleService dependencies such as `MiuiPhoneApp`, `MiuiPhoneUtils`, `MiuiImsPhoneUtils`, `MiuiEsimManager` and `ACCESS_RELAY_SERVICE`.

## MMS policy

The reference MMS/RCS component remains excluded. It is an optional component and is not required for the core dialer/Contacts/TeleService port.

## Overlay policy

The three reference Dialer overlays remain a tracked dependency, but they are not inserted blindly. Only overlays proven to target the OS3 resource/package set will be included.

## Safety gate

Do not install the module until the GitHub Actions ZIP passes all structural, package and payload checks. The previous boot failure makes staged validation mandatory.
