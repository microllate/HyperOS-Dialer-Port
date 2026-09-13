# Android 15 Port Analysis

## Device baseline

- Device: `mondrian`
- HyperOS: `OS3.0`
- EEA build: `OS3.0.2.0.VMNEUXM`
- EEA dialer: `com.google.android.dialer`
- EEA contacts: `com.google.android.contacts`
- EEA telephony service: `com.android.phone`

## China components

### InCallUI

- Package: `com.android.incallui`
- Version: `4.0.1.143`
- Version code: `3722`
- minSdk: 31
- targetSdk: 34
- ABI: arm64-v8a
- APK SHA-256: `9b18172465e80a7bb387e1bfdd6de0ca8debf93427cf7b15bb87030095e0f120`

### MIUI Contacts

- Package: `com.android.contacts`
- Version: `16.8.05.21`
- Version code: `80521`
- APK size in source ROM: about 23 MB

### China TeleService

- Package: `com.android.phone`
- Version: `15`
- Version code: `35`
- targetSdk: 35
- ABI: arm64-v8a

## Compatibility conclusion

China InCallUI has strong MIUI telephony integration and references classes under `com.android.phone`, including `MiuiPhoneApp`, `MiuiPhoneUtils`, `MiuiPhoneReceiver`, `MiuiImsPhoneUtils`, and `MiuiEsimManager`. It also declares `com.android.phone.permission.ACCESS_RELAY_SERVICE`.

The recommended v0.3 strategy therefore **does not replace EEA TeleService**. The port introduces the UI-side packages and only the privileged permissions that are required by the InCallUI package. TeleService remains the EEA implementation.

## Third-party reference module

The supplied reference ZIP contains Android 13 and Android 14 InCallUI variants, MIUI Contacts, overlays, native libraries, and a privileged-permission whitelist. Its installer explicitly branches only for Android 13 and 14. On Android 15 the InCallUI path is not initialized, so its installation logic is not reusable as-is.

The reference installer also calls `pm install` and `pm uninstall-system-updates` for Google Dialer/Contacts. That is intentionally avoided here.

## KernelSU/meta-overlayfs

The target environment uses KernelSU with meta-overlayfs v1.3.1. A manual runtime test previously confirmed that a module payload under `/product/priv-app/InCallUIPhoneHyperOS` can be exposed through the meta-overlayfs mount.

The earlier boot failure occurred during module deployment/integration, not because the basic `/product` overlay path was impossible. v0.3 therefore keeps the payload and installer minimal and separates compatibility validation from device flashing.

## Validation order

1. Verify APK package/signature and Android 15 framework dependencies.
2. Verify privileged permissions against the target ROM.
3. Verify required overlay resources.
4. Build the module without device installation.
5. Inspect the final ZIP structure.
6. Only then perform a KernelSU safe-mode test.
7. Keep a recovery/removal path available before first boot.
