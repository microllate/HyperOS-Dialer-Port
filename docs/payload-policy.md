# Android 15 payload policy

The payload stage is intentionally blocked from bundling unverified APK binaries.

## Required source components

1. China HyperOS InCallUI: package `com.android.incallui`, version `4.0.1.143` / versionCode `3722`.
2. China MIUI Contacts: package `com.android.contacts`, version `16.8.05.21` / versionCode `80521`.
3. Only the Dialer overlays whose resources are required by those packages.

## Runtime constraints

- Target is HyperOS OS3 EEA on Android 15/API 35.
- Device is `mondrian` and ABI is `arm64-v8a`.
- EEA `com.android.phone` / TeleService stays in place.
- Google Dialer and Contacts are not uninstalled by the module.
- APKs are mounted systemlessly; the installer must not depend on `pm install`.

## Why binaries are not committed yet

The reference module contains Android 13 and Android 14 InCallUI variants. Its installer has no Android 15 branch and therefore cannot be reused for this target. The binary payload must first be validated against the Android 15 framework, package ownership, privileged permissions, and boot-time overlay behavior.

This repository therefore treats the payload as a separate, verified stage instead of pretending a known-good Android 13/14 APK is an Android 15 build.
