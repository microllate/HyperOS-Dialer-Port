#!/system/bin/sh
set -eu
MODDIR=${1:-/data/adb/modules/hyperos_dialer_port}
fail(){ echo "[FAIL] $*"; exit 1; }
ok(){ echo "[ OK ] $*"; }
[ -d "$MODDIR" ] || fail "module directory missing: $MODDIR"
[ -f "$MODDIR/module.prop" ] || fail "module.prop missing"
[ -f "$MODDIR/customize.sh" ] || fail "customize.sh missing"
[ -d "$MODDIR/product" ] || fail "product overlay missing"
[ -d "$MODDIR/system" ] || fail "system overlay missing"
ok "module skeleton"
if [ -e "$MODDIR/product/priv-app/InCallUIPhoneHyperOS/InCallUIPhoneHyperOS.apk" ]; then
  ok "China InCallUI payload present"
else
  echo "[WARN] China InCallUI APK payload not bundled yet"
fi
if [ -e "$MODDIR/product/priv-app/MIUIContactsT/MIUIContactsT.apk" ]; then
  ok "MIUI Contacts payload present"
else
  echo "[WARN] MIUI Contacts APK payload not bundled yet"
fi
if [ -e /system/product/priv-app/InCallUIPhoneHyperOS/InCallUIPhoneHyperOS.apk ]; then
  ok "runtime InCallUI path visible"
else
  echo "[INFO] runtime InCallUI path not visible on this host"
fi
if [ "$(getprop ro.product.device 2>/dev/null || true)" = "mondrian" ]; then ok "device=mondrian"; fi
if [ "$(getprop ro.build.version.sdk 2>/dev/null || true)" = "35" ]; then ok "Android API 35"; fi
