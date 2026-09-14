# Reference module structure

The supplied reference ZIP was inspected but has not been installed on the target device.

## Reference components

- Android 13 InCallUI — reference only
- Android 14 InCallUI — reference only
- MIUI Contacts
- China TeleService dependency surface for the adapted OS2 payload
- Dialer resource overlays
- `privapp-permissions` extension
- MMS/RCS as an optional component
- `META-INF/zbin` installer/runtime framework

## Android 15 port

The original installer has no valid Android 15 InCallUI branch, so its APK selection logic is not reused. The port instead uses the authoritative OS2 China InCallUI, Contacts and TeleService APKs stored on `main`.

## Current runtime payload

1. `product/priv-app/InCallUIPhoneHyperOS/`
2. `product/priv-app/MIUIContactsT/`
3. `system/priv-app/TeleService/`
4. `product/etc/permissions/privapp-permissions-hyperos-dialer.xml`
5. `META-INF/zbin/`

Native libraries are extracted from the exact OS2 APKs during CI.

## Deferred components

- MMS + six native libraries: deferred
- Three reference Dialer overlays: pending target/resource verification; no placeholder binaries are shipped

## Installer policy

The port keeps the reference zbin concept but does not execute `pm install`, `pm uninstall-system-updates`, or remove Google Dialer/Contacts updates.
