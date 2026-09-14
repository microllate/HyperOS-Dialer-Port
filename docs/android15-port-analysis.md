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

## Reference module: full scope

The supplied `MIUI_HyperOS国内拨号.zip` contains more than two applications. Its full baseline has 7 APKs, 11 native libraries, 3 product overlays, a privileged-permission whitelist, and a dynamic installer/runtime toolchain.

The relevant application set is:

- Android 13 InCallUI: `com.android.incallui` — reference only
- Android 14 InCallUI: `com.android.incallui` — reference only
- MIUI Contacts: `com.android.contacts` — source for the port
- MIUI MMS: `com.android.mms` — optional SMS/RCS component, deferred from first build
- 3 product overlays — must be checked against Android 15 resource targets

The reference installer has no Android 15 InCallUI branch. It also uses `pm install` and removes Google Dialer/Contacts system updates. Neither behavior is suitable for the target EEA systemless port.

## Authoritative user payloads

### InCallUI

- Package: `com.android.incallui`
- Version: `4.0.1.143`
- Version code: `3722`
- minSdk: 31
- targetSdk: 34
- ABI: arm64-v8a
- APK SHA-256: `9b18172465e80a7bb387e1bfdd6de0ca8debf93427cf7b15bb87030095e0f120`
- Signing certificate SHA-256: `e4431422e25ae61fa3655e9f908a9b40da2acd67fab99b737027c21fd22b7d40`

The reference Android 13/14 InCallUI APKs are not substituted for this user-supplied OS2 APK.

### MIUI Contacts

- Package: `com.android.contacts`
- Version: `16.8.05.21`
- Version code: `80521`
- Source size: about 23 MB

The user-supplied OS2 Contacts APK is authoritative.

### China TeleService

- Package: `com.android.phone`
- Version: `15`
- Version code: `35`
- targetSdk: 35
- ABI: arm64-v8a

This APK is reference material only. The EEA `com.android.phone` remains installed and is not replaced by this module.

## Compatibility findings

China InCallUI has strong MIUI telephony integration and references classes under `com.android.phone`, including `MiuiPhoneApp`, `MiuiPhoneUtils`, `MiuiPhoneReceiver`, `MiuiImsPhoneUtils`, and `MiuiEsimManager`. It also references `com.android.phone.permission.ACCESS_RELAY_SERVICE` and updates call state through TeleService-facing code.

InCallUI additionally references `com.android.contacts`, `com.android.mms`, `com.android.server.telecom`, MIUI analytics/blur/antispam components and Xiaomi services. MIUI Contacts references `com.android.phone`, `com.android.server.telecom.BIND_INCALL`, and `com.android.mms.providers.SmsProvider`.

Therefore the port cannot be treated as two isolated APKs. At the same time, replacing EEA TeleService is too risky for the first Android 15 build. The safe boundary is to preserve EEA TeleService and validate the UI/Contacts side against it.

## Native libraries

The reference module carries native libraries alongside InCallUI, MMS and Contacts. They are part of the dependency surface and cannot be discarded blindly.

For the first build:

- keep native libraries that are required by the exact user-supplied APKs;
- do not copy Android 13/14 reference libraries merely because the original module contains them;
- Contacts `libmiuiblursdk.so` is retained with the Contacts payload after ABI/dependency verification;
- MMS native libraries remain deferred with MMS.

## Overlays

The reference module contains:

- `Dialer_overlay1_mods_center.apk`
- `Dialer_overlay2_mods_center.apk`
- `GmsConfigOverlayComms.apk`

These are real runtime components, not documentation files. They must be inspected for target package names and resource IDs before being placed under the Android 15 overlay tree. Blindly copying them is prohibited because Android 15 resource/package changes can make an overlay ineffective or unsafe.

## Privileged permissions

The original whitelist covers `com.android.contacts`, `com.android.mms`, and `com.android.incallui`. The port will not blindly copy the whole whitelist. The Android 15 target ROM must receive only the permissions actually declared/required by the payload and accepted for the target privileged-app location.

## MMS decision

`com.android.mms` and its native libraries are a substantial part of the original module, but MMS was an optional installer branch. The target EEA system already has Google's messaging stack. Therefore MMS is deliberately deferred from the first boot-tested build to avoid introducing an additional system messaging provider/RCS stack before dialer compatibility is proven.

## Deployment model

The target environment uses KernelSU with meta-overlayfs v1.3.1. A previous manual runtime test confirmed that a payload exposed under `/product/priv-app/InCallUIPhoneHyperOS` can appear through the meta-overlayfs mount.

The final module must therefore be systemless and must not depend on `pm install`, `pm uninstall-system-updates`, or replacing/removing Google Dialer/Contacts packages.

## Validation order

1. Verify exact payload package/version/signature/ABI.
2. Map InCallUI and Contacts dependencies against EEA TeleService/Telecom.
3. Verify required native libraries from the exact payload APKs.
4. Inspect all three reference overlays and retain only Android 15-compatible targets/resources.
5. Minimize the privileged-permission allowlist.
6. Build a real KernelSU ZIP in CI.
7. Re-open the generated ZIP and verify paths, permissions and payload hashes.
8. Run static checks before any device installation.
9. Only then perform a KernelSU safe-mode test with a tested removal path.
