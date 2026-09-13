# Reference module structure

The uploaded reference ZIP was inspected but is not installed on the target device.

## Reference components

- Android 13 InCallUI (`files/InCallUIT/InCallUI.apk`)
- Android 14 InCallUI (`files/InCallUIU/InCallUI.apk`)
- MIUI Contacts (`system/priv-app/MIUIContactsT/MIUIContacts.apk`)
- Dialer resource overlays
- `privapp-permissions` extension

## Android 15 decision

The reference installer explicitly selects only Android 13 and Android 14 InCallUI paths. On Android 15 this leaves the InCallUI path unset, so its installer must not be reused.

The reference also performs package-manager installation and removes system updates for Google Dialer/Contacts. Neither behavior is used by this port.

## Port policy

1. Keep EEA `com.android.phone` / TeleService intact.
2. Use systemless KernelSU/meta-overlayfs placement.
3. Add only the privileged permissions required by the ported packages.
4. Introduce overlays incrementally and only when their resource targets are confirmed.
5. Do not run `pm install` from the module installer.
6. Do not remove Google Dialer/Contacts updates as part of the initial port.
