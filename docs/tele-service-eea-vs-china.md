# TeleService: OS3 EEA vs OS2 China

## Scope

Compared the TeleService APK pulled from the user's current HyperOS OS3 EEA / Android 15 device with the OS2 China TeleService APK already staged in the project artifact.

## APK identities

| Build | SHA-256 | Size | DEX | ZIP entries |
|---|---|---:|---|---:|
| OS3 EEA device | `a696701b1b43ae65663b15a8c731538343bf0c610f1a4de46f671b3749ab17b5` | 21,787,239 | classes.dex 10,557,612; classes2.dex 635,968 | 2,561 |
| OS2 China staged payload | `0da432c70745eb928a6a05c9a3e81d451a2f3140543bcff8fcacd85bf5a3c4ec` | 9,008,465 | classes.dex 9,847,736 | 2,523 |

## Important compatibility finding

Both builds contain the same core MIUI telephony integration surface, including references to `MiuiPhoneApp`, `MiuiPhoneUtils`, `MiuiAnimUtil`, `MiuiEsimManager`, `MiuiImsPhoneUtils`, `QCMiuiEsimManager`, `MiuiPhoneReceiver`, `TelephonyConnectionService`, `RelayConnectionService`, `OfflineConnectionService`, `MiDcService`, `ACCESS_RELAY_SERVICE`, `com.android.incallui`, and `com.google.android.dialer`.

This means the EEA OS3 TeleService is not a pure AOSP/Google implementation and already shares substantial Xiaomi telephony plumbing with the China build.

## Major difference

The EEA APK is substantially newer/larger and contains features that are not present in the China payload. EEA-only payload includes a second DEX and extensive satellite/BeiDou, high-speed-train, modem/network optimization and other classes/resources. Examples include:

- `com/android/phone/beidou/*`
- `com/android/phone/SatelliteManager*`
- `com/android/phone/SatelliteDialogActivity*`
- `com/android/phone/HighSpeedTrainModeController*`
- `com/android/phone/NetworkOptimizerBase*`
- `com/android/phone/NetworkSelfRecovery*`
- `com/android/phone/ModemPowerEstimate*`
- `com/android/phone/XtsService*`

The EEA APK also has 38 unique ZIP entries beyond the China build, including satellite settings/layout resources and related assets. The China build has only one unique asset: `assets/sm_hst_bitmap_default.xml`.

The China build also contains a different set of telephony implementation classes, including `KeepAliveClient`, `MiCarrierConfigLoaderStub`, `MiPhoneAppStub`, `RilStallRecovery`, `MiuiCarrierConfigHelper`, and several network-recovery/statistics classes not present in the EEA APK's extracted class-name set.

## Decision

**Do not replace the OS3 EEA TeleService wholesale with the OS2 China APK.**

Reason: the two builds share the Xiaomi telephony contract, but the OS3 EEA implementation contains additional Android 15-era functionality and resources. Replacing it wholesale would discard EEA-specific modem/network/satellite functionality and creates a high boot/telephony regression risk.

The safer architecture is:

1. Keep the OS3 EEA TeleService as the base.
2. Continue using the China InCallUI + MIUI Contacts payload.
3. Treat China TeleService as a reference/diff source, not as the final replacement payload.
4. Only port individual China-side components/config/resources after proving that their framework/resource/API dependencies resolve on OS3 EEA.
5. Do not enable the three reference Dialer overlays yet; overlay2 targets `com.android.phone` and can alter TeleService defaults, so it must be validated against the EEA resource table before inclusion.

## Current project consequence

The existing `system/priv-app/TeleService/TeleService.apk` payload should be removed from the final runtime module once the component-level migration is prepared. Until that migration is implemented, the module should remain a validation artifact and **must not be flashed as a production module**.

## Next implementation gate

The next concrete task is to extract the EEA and China TeleService manifests/resource identifiers and build a component-level allowlist of China-only functionality that can be ported without replacing the EEA base package. This should be implemented before adding any Dialer overlay.
