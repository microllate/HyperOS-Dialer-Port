# Dialer Overlay Analysis

The three overlays from the supplied domestic dialer module were inspected directly.

## Overlay 1

`Dialer_overlay1_mods_center.apk`

- Package: `dialer.overlay1`
- Target package: `com.android.server.telecom`
- Resource references include `com.android.contacts.activities.TwelveKeyDialer`, `com.android.incallui`, and `com.android.contacts`.
- Resources include `dialer_default_class`, `ui_default_package`, and `ui_default_package_dialer`.

## Overlay 2

`Dialer_overlay2_mods_center.apk`

- Package: `dialer.overlay2`
- Target package: `com.android.phone`
- Resource references include `config_call_recording`, `dialer_default_class`, and `platform_number_verification_package`.

## GMS communications overlay

`GmsConfigOverlayComms.apk`

- Package: `com.google.android.overlay.gmsconfig.comms`
- It is a GMS communications configuration overlay.
- Its resource table references `com.android.contacts`, `com.android.mms`, `config_defaultDialer`, `config_defaultSms`, and `config_systemContacts`.

## OS3 decision

Overlay 2 has a direct target on the China TeleService package that is now included in this port, so it is the highest-priority candidate.

Overlay 1 targets Android Telecom and is also relevant to the call stack.

The GMS overlay is the highest-risk candidate because its configuration can change default dialer/SMS/contact package selection on an EEA ROM.

The three binaries are kept out of the current ZIP until the target OS3 resource/package table is checked. No placeholder overlays are generated.

## Next integration gate

For `OS3.0.2.0.VMNEUXM`, compare each overlay's target package and referenced resource IDs against the corresponding OS3 framework/Telecom/TeleService resource tables. Include an overlay only when its resource IDs resolve and its configuration does not redirect the EEA defaults unexpectedly.
