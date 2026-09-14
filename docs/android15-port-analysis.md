# Android 15 Port Analysis

## Device baseline

- Device: `mondrian`
- HyperOS: `OS3.0`
- EEA build: `OS3.0.2.0.VMNEUXM`
- Android: 15 / API 35
- ABI: arm64-v8a
- EEA dialer: `com.google.android.dialer`
- EEA contacts: `com.google.android.contacts`
- EEA telephony service: `com.android.phone`

## Reference module scope

The supplied `MIUI_HyperOS国内拨号.zip` contains 7 APKs, 11 native libraries, 3 product overlays, a privileged-permission whitelist and a dynamic installer/runtime toolchain.

The port keeps the core domestic stack but excludes the optional MMS/RCS stack for the first runtime build.

## Authoritative OS2 payloads

### InCallUI

- Package: `com.android.incallui`
- Version: `4.0.1.143`
- Version code: `3722`
- minSdk: 31
- targetSdk: 34
- ABI: arm64-v8a
- APK SHA-256: `9b18172465e80a7bb387e1bfdd6de0ca8debf93427cf7b15bb87030095e0f120`
- Signing certificate SHA-256: `e4431422e25ae61fa3655e9f908a9b40da2acd67fab99b737027c21fd22b7d40`

### MIUI Contacts

- Package: `com.android.contacts`
- Version: `16.8.05.21`
- Version code: `80521`
- ABI: arm64-v8a

### China TeleService

- Package: `com.android.phone`
- Version: `15`
- Version code: `35`
- targetSdk: 35
- ABI: arm64-v8a

The OS2 China TeleService is now part of the module payload under `system/priv-app/TeleService`.

## Compatibility findings

China InCallUI has strong MIUI telephony integration and references classes under `com.android.phone`, including `MiuiPhoneApp`, `MiuiPhoneUtils`, `MiuiPhoneReceiver`, `MiuiImsPhoneUtils`, `MiuiEsimManager` and `QCMiuiEsimManager`. It also references `com.android.phone.permission.ACCESS_RELAY_SERVICE` and TeleService-facing call-state updates.

MIUI Contacts references `com.android.phone`, `com.android.server.telecom.BIND_INCALL` and `com.android.mms.providers.SmsProvider`.

These findings make China TeleService part of the intended core port rather than an EEA-compatible optional replacement.

## Native libraries

The CI build extracts native libraries directly from the exact OS2 InCallUI, Contacts and TeleService APKs. Android 13/14 reference libraries are not copied merely because they exist in the original module.

MMS native libraries remain excluded together with MMS.

## Overlays

The reference module contains:

- `Dialer_overlay1_mods_center.apk`
- `Dialer_overlay2_mods_center.apk`
- `GmsConfigOverlayComms.apk`

These are tracked as required compatibility candidates. They are not blindly inserted until target package/resource IDs are confirmed against OS3. No fake overlay binaries are generated.

## Privileged permissions

The port uses a minimized allowlist for `com.android.incallui` and `com.android.contacts` under `product/etc/permissions`. TeleService remains a system priv-app and is validated independently.

## MMS decision

`com.android.mms` and its six native libraries remain disabled. The original installer treated MMS as an optional component; omitting it keeps the first runtime scope focused on dialer, contacts and telephony.

## Installer / zbin

The original module's zbin architecture is retained as a concept. The port ships an Android 15/mondrian-specific `setup`, `core` and version marker. These validate the environment and deliberately do not run `pm install` or remove Google Dialer/Contacts updates.

## Deployment model

The target environment uses KernelSU with meta-overlayfs v1.3.1. A previous manual runtime test confirmed that a payload exposed under `/product/priv-app/InCallUIPhoneHyperOS` can appear through the meta-overlayfs mount.

The generated module is systemless. It does not uninstall Google packages and does not use the reference module's direct package installation behavior.

## Validation order

1. Verify exact payload package/version/signature/ABI.
2. Verify China InCallUI/Contacts dependencies against OS2 China TeleService.
3. Verify native libraries from the exact payload APKs.
4. Verify privileged permissions.
5. Inspect the three reference overlays against OS3 resources.
6. Build the real KernelSU ZIP in CI.
7. Re-open the ZIP and verify paths and hashes.
8. Perform static checks.
9. Only then perform a KernelSU safe-mode device test with a tested removal path.
