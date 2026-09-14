# Android 15 Reference Scope

The supplied `MIUI_HyperOS国内拨号.zip` is the sole functional source for this port.

It contains InCallUI, MIUI Contacts, optional MMS, and three product overlays. It does not contain or replace `TeleService.apk`.

For the Android 15 EEA target, the closest provided InCallUI is the reference module's Android 14 `files/InCallUIU/InCallUI.apk`. The port remains systemless and does not use package-manager installation or remove Google Dialer/Contacts updates.

Target: mondrian / HyperOS OS3.0.2.0.VMNEUXM EEA / Android 15 API 35 / arm64-v8a.

Default runtime scope: InCallUI + MIUI Contacts + the three reference overlays. MMS remains optional and is not enabled by default.

Explicitly excluded: China TeleService replacement and any component not present in the supplied reference module.
