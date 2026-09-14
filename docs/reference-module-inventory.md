# MIUI_HyperOS国内拨号.zip — 完整清单与 Android 15 移植结论

- Source ZIP: `MIUI_HyperOS国内拨号.zip`
- Source ZIP size: 55,686,188 bytes
- File count: 33
- Target: `mondrian` / HyperOS OS3 EEA / Android 15 (API 35)

## 结论

这个模块**不是只有两个 APK**。完整基线包含 7 个 APK、11 个 native `.so`、权限白名单、3 个 product overlay，以及一套动态安装器/运行时工具。

首个 Android 15 安全版本不直接加入 MMS APK，也不执行原模块的 `pm install` / `pm uninstall-system-updates`。InCallUI、MIUI Contacts、对应 native 库和经过核对的 overlay/privapp 配置进入首个可启动构建；MMS 保留为第二阶段可选组件。

## 1. 完整文件清单

| 路径 | 大小 | SHA-256 |
|---|---:|---|
| `META-INF/com/google/android/magisk/customize.sh` | 3,268 | `665f36a3da7c1c0706a1e6aea235546d3d529512a8069f10879ee28d17b4c13f` |
| `META-INF/com/google/android/magisk/module.prop` | 172 | `ecb7f42654cab781e9dda33fbf5c09256eb1e93d43dcbc2dd7c25782b1d11152` |
| `META-INF/com/google/android/update-binary` | 6,537 | `2958cc7507ca173748f1482a4a6ea3305fde53bafa9b7629233c5741729f1160` |
| `META-INF/com/google/android/updater-script` | 444 | `73ad25d73a337d80f8cf127211604dbf1a8160f5d542709c95d941f1f05e1775` |
| `META-INF/zbin/bash` | 1,520,248 | `d3b948993528d65f26b2c43d9bb011e144291f22498ba5045e959b6349710c2c` |
| `META-INF/zbin/bin` | 4,543,216 | `a801c449a2d812cb06d5975fa156c299f9fecfb48759c978a9f4028b5ad088de` |
| `META-INF/zbin/busybox` | 1,715,180 | `ccdb7753cb2f065ba1ba9a83673073950fdac7a5744741d0f221b65d9fa754d3` |
| `META-INF/zbin/configs/file_types.config` | 938 | `d5db5a08c6fcd14c328520bb1aefcbc4d49714607bfb3b8c5bbd91a1e11fc1f9` |
| `META-INF/zbin/configs/units.config` | 871 | `21f7223f37ea4b70463f15b6b0cb18f177487073276ae79d07451e0b4754f6b3` |
| `META-INF/zbin/core` | 236,218 | `45a552410161dc8af5c8cb74850169020e659e208175ff2528b0f289a58d0ec6` |
| `META-INF/zbin/setup` | 1,717 | `2f90cb5ad68c8329b9db98f11713d089bb1ebc49e9b0decce774552569cc14f3` |
| `META-INF/zbin/version.txt` | 68 | `307848852524c7d4c2230eb8ed03a4721a096ec63fd20200cbdef9bb417f7cf1` |
| `customize.sh` | 1,070 | `e0b5afe116a6256a97c6670f7d9db9ae7f2c782e22a98e373027683eca3da577` |
| `files/InCallUIT/InCallUI.apk` | 8,492,378 | `9db994cbe919973b2edba4f0279d3a70485a079601a981579188edc9d1dd4a23` |
| `files/InCallUIT/lib/arm64/libmiuiblursdk.so` | 952,704 | `2b22f9a295f7ebd9c428ec27b2fe33a34d565077a7f3c2f477fba683094d4642` |
| `files/InCallUIT/lib/arm64/libmp3_encoder.so` | 231,488 | `a6b3848ba6983be4e2d540c75be91d0a659d9b42c5da8d6d1bc5f48f9d348866` |
| `files/InCallUIU/InCallUI.apk` | 6,186,364 | `ed48af7d7ee7cfde280e1a2c936befa7c2e57fc0bafc88d812421432e2d80c84` |
| `files/InCallUIU/lib/arm64/libmievent.so` | 4,440 | `77d73cc304a704c2a4d4e17ff8e7a0659c2385ec78663eb5380c70ac37c9e1d` |
| `files/InCallUIU/lib/arm64/libmp3_encoder.so` | 231,488 | `a6b3848ba6983be4e2d540c75be91d0a659d9b42c5da8d6d1bc5f48f9d348866` |
| `files/MmsT/MMS.apk` | 37,021,420 | `5d142477c4dbaa89f21196c267956b3a63af025111f5d8543ac45339261c676d` |
| `files/MmsT/lib/arm64/libRcsStack.so` | 5,202,528 | `26137cb7176598f49414a1cbf4c9a795469cb9316779599175a222903e070369` |
| `files/MmsT/lib/arm64/libmiuiblursdk.so` | 952,704 | `12e409ff6b95b73f798df1f4821beef3706f91e31e62eed68f9991e804429836` |
| `files/MmsT/lib/arm64/libmiuidiffpatcher.so` | 78,672 | `05e65fc24e44ddfca602cb4b40ab02b835b0ca9c8743d99f43aac69680b562f7` |
| `files/MmsT/lib/arm64/libpl_droidsonroids_gif.so` | 43,016 | `8be2d43c5deda6aafa3162e55a4f60f28af9efacf28281c5ff4ad3408445e3d9` |
| `files/MmsT/lib/arm64/libxcrash.so` | 88,360 | `914909f669e45773aed1b31a6757121e38a01acb47f8860753b5fde41dfd09dd` |
| `files/MmsT/lib/arm64/libxcrash_dumper.so` | 129,344 | `e56d85c5051012aadb27fa9b910c4657df58f2cbdb819dc464b759b2f3c74b53` |
| `module.prop` | 172 | `ecb7f42654cab781e9dda33fbf5c09256eb1e93d43dcbc2dd7c25782b1d11152` |
| `system/etc/permissions/privapp_whitelist_kashi.dialer.ext.xml` | 2,868 | `2a7e03b1862e467a778763b40d8df346727fc054e5fb7c79d5e38388c921dd67` |
| `system/priv-app/MIUIContactsT/MIUIContacts.apk` | 22,917,965 | `16d6ae6b9cdc646f0f14d2ffa8a6d255850d0bc5840e958e5ff707aaebabf36d` |
| `system/priv-app/MIUIContactsT/lib/arm64/libmiuiblursdk.so` | 952,704 | `12e409ff6b95b73f798df1f4821beef3706f91e31e62eed68f9991e804429836` |
| `system/product/overlay/Dialer_overlay1_mods_center.apk` | 16,730 | `fb556d5be9cdf369203ddc5e26f973aa4ef2954667af823045e73cc35cd53060` |
| `system/product/overlay/Dialer_overlay2_mods_center.apk` | 16,728 | `fde522e7055d8bfaef1fde1eb8f7b7e5480ed8d7a3e74104f522a0ddd15f7714` |
| `system/product/overlay/GmsConfigOverlayComms.apk` | 12,632 | `595226087dd671f943f401d3162011a196d82f49e2eeb7b8f7cdf8f816058582` |

## 2. 组件分类

### 必须处理

- `InCallUI.apk`：Android 13/14 文件只是参考。最终使用用户提供的 OS2 `com.android.incallui` APK。
- `MIUIContacts.apk`：最终使用用户提供的 OS2 `com.android.contacts` APK。
- Contacts 的 `libmiuiblursdk.so`：与 Contacts payload 一起处理。
- 3 个 product overlay：逐个核对 target package/resource 后再进入 Android 15 模块，不能盲拷。
- privileged permission whitelist：按目标 ROM 最小化重写。

### 仅作版本参考

- `files/InCallUIT/*`：Android 13 分支，淘汰。
- `files/InCallUIU/*`：Android 14 分支，只用于依赖/行为参考，不直接作为 Android 15 payload。

### 第二阶段可选

- `files/MmsT/MMS.apk` (`com.android.mms`) 及其 6 个 native 库。原模块把它作为可选短信组件安装；首版不加入，避免与 EEA Google Messages/短信栈产生系统组件冲突。

### 不进入最终运行 payload

- `META-INF/zbin/*`
- `META-INF/com/google/android/update-binary`
- `META-INF/com/google/android/magisk/customize.sh`

这些是原动态安装框架，不适用于本项目的 KernelSU/meta-overlayfs 无侵入部署。

## 3. 原模块实际行为

原安装器：

1. Android < 13 拒绝；
2. 可选安装 `com.android.mms`；
3. Android 13 使用 `InCallUIT`，Android 14 使用 `InCallUIU`，Android 15 没有有效 InCallUI 分支；
4. `pm install` 直接安装 InCallUI；
5. 对 `com.google.android.dialer`、`com.google.android.contacts` 执行 `pm uninstall-system-updates`；
6. 修改 REPLACE 路径、清理 package cache、设置 context。

这些操作不能原样迁移到目标 EEA Android 15。

## 4. 依赖关系

InCallUI 的字符串/代码中可见：`com.android.phone`、`com.android.contacts`、`com.android.mms`、`com.android.server.telecom`、MIUI/Xiaomi 服务，以及 `com.android.phone.permission.ACCESS_RELAY_SERVICE` 等 TeleService 侧接口。

MIUI Contacts 也引用 `com.android.phone`、`com.android.server.telecom.BIND_INCALL`、`com.android.mms.providers.SmsProvider` 等。

因此原模块实际上是一个**电话 + 联系人 + 可选短信 + overlay + native library + 权限白名单**组合，而不是简单的两个 APK。

## 5. Android 15 首版构成

```text
hyperos_dialer_port/
├── product/priv-app/InCallUIPhoneHyperOS/InCallUIPhoneHyperOS.apk
├── product/priv-app/MIUIContactsT/MIUIContactsT.apk
├── product/priv-app/MIUIContactsT/lib/arm64/libmiuiblursdk.so
├── product/overlay/*.apk                 # 只放兼容的 overlay
├── system/etc/permissions/*.xml           # 最小 privapp allowlist
└── module.prop / customize.sh / config / tools
```

MMS、其 native 库和 TeleService 不进入首版。EEA `com.android.phone` 保持原实现。

## 6. 安全验证门槛

1. package/version/signature/ABI；
2. InCallUI ↔ EEA TeleService 调用点；
3. Contacts ↔ EEA TeleService/Telecom/MMS provider 调用点；
4. overlay target/resource；
5. 最小 privapp whitelist；
6. CI 真实构建 ZIP；
7. 解压 ZIP 检查路径、权限和 SHA256；
8. 全部通过后才在 mondrian 上进行 KernelSU safe-mode 测试。
