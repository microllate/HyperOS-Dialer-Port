# HyperOS-Dialer-Port

Android 15 / HyperOS OS3 EEA systemless dialer port for Xiaomi `mondrian`.

## Target

- Device: `mondrian`
- ROM: HyperOS OS3 EEA / `OS3.0.2.0.VMNEUXM`
- Android API: 35
- Architecture: arm64-v8a
- Region: EEA
- Installation: KernelSU / meta-overlayfs systemless module

## Payload

- `com.android.incallui`: HyperOS InCallUI payload from the supplied domestic module's Android 14 `InCallUIU` branch.
- `com.android.contacts`: MIUI Contacts payload from the supplied module.
- Three supplied dialer overlays are preserved exactly.
- EEA `com.android.phone` / TeleService is **not replaced**.
- MMS/RCS payload is **not included**.

The Android 15 adaptation is primarily the installation/mount model: the old installer performed `pm install` and `pm uninstall-system-updates`; this port does neither. The APKs are mounted systemlessly so the stock EEA phone stack remains intact.

## Layout

```text
product/priv-app/InCallUIPhoneHyperOS/
product/overlay/
system/priv-app/MIUIContactsT/
system/etc/permissions/
META-INF/com/google/android/
META-INF/zbin/
```

## Safety

Do not replace the EEA TeleService with the OS2 China `com.android.phone` APK. The EEA TeleService contains region/device-specific telephony components that are not present in the China build.

MMS is intentionally disabled to keep the first Android 15 EEA test scope limited to the dialer/call UI and contacts stack.

The GitHub Actions workflow performs package, SDK, device-profile, hash, installer, ZIP-integrity and payload-scope checks before producing the test artifact.

See `docs/android15-reference-scope.md`, `docs/overlay-analysis.md`, and `docs/tele-service-eea-vs-china.md` for the analysis records.
