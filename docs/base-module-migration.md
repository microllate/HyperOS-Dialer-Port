# Base module migration

## Source module

This port is based on the previously supplied `MIUI_HyperOS国内拨号.zip` module. The existing module layout and payload concept are retained; this repository is not a clean-room rewrite.

## What is retained

- China HyperOS InCallUI + MIUI Contacts as the primary payload.
- `product/priv-app` placement for systemless replacement.
- `system/etc/permissions` privileged-permission allowlist.
- Module-manager installation rather than normal APK installation as the deployment model.
- MIUI Dialer/Contacts overlay resources only where required by the port.

## What is changed for this phone

Target device: Xiaomi `mondrian`.

Target ROM: HyperOS OS3 EEA, build `OS3.0.2.0.VMNEUXM`.

Target Android: 15 / API 35 / arm64-v8a.

The original module contains Android 13/14 payload branches. Those branches are not used for this port. The user-supplied OS2 China APKs are the payload source instead.

The original installer behavior that performs `pm install` or removes Google Dialer/Contacts system updates is deliberately not carried over. Those operations are unsafe for this EEA target and are unnecessary when the APKs are mounted at their system paths.

## TeleService policy

China `com.android.phone` is not included in the port. The EEA `com.android.phone` remains the active TeleService implementation.

This is intentional because China InCallUI references MIUI/TeleService interfaces, while replacing TeleService would introduce the largest cross-region compatibility risk. The port therefore changes the UI/Contacts side first and leaves the telephony backend untouched.

## Payload source

The authoritative payload files are stored at the repository root on `main`:

- `InCallUIPhoneHyperOS.apk`
- `MIUIContactsT.apk`
- `TeleService.apk` (reference only; not packaged into the module)

The build workflow can copy the first two from `main` into the module staging tree. This keeps the source APKs stored in GitHub while preventing accidental inclusion of EEA TeleService replacement code.

## Safety gate

Do not install the module on the phone until the GitHub Actions package passes the structural and payload checks. The previous boot failure makes staged validation mandatory.
