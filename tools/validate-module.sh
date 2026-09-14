#!/system/bin/sh
set -eu
MODDIR=${1:-/data/adb/modules/hyperos_dialer_port}
fail(){ echo "[FAIL] $*"; exit 1; }
ok(){ echo "[ OK ] $*"; }
[ -d "$MODDIR" ] || fail "module directory missing: $MODDIR"
[ -f "$MODDIR/module.prop" ] || fail "module.prop missing"
[ -f "$MODDIR/customize.sh" ] || fail "customize.sh missing"
[ -d "$MODDIR/product" ] || fail "product overlay missing"
ok "module skeleton"
for p in \
  "$MODDIR/product/priv-app/InCallUIPhoneHyperOS/InCallUIPhoneHyperOS.apk" \
  "$MODDIR/product/priv-app/MIUIContactsT/MIUIContactsT.apk" \
  "$MODDIR/system/priv-app/TeleService/TeleService.apk"; do
  [ -e "$p" ] || fail "missing payload: $p"
done
ok "China InCallUI payload"
ok "MIUI Contacts payload"
ok "OS2 China TeleService payload"
[ -e "$MODDIR/product/etc/permissions/privapp-permissions-hyperos-dialer.xml" ] || fail "privapp permissions missing"
ok "privapp permissions"
if [ -e /product/priv-app/InCallUIPhoneHyperOS/InCallUIPhoneHyperOS.apk ]; then
  ok "runtime InCallUI path visible"
else
  echo "[INFO] runtime InCallUI path not visible on this host"
fi
if [ "$(getprop ro.product.device 2>/dev/null || true)" = "mondrian" ]; then ok "device=mondrian"; fi
if [ "$(getprop ro.build.version.sdk 2>/dev/null || true)" = "35" ]; then ok "Android API 35"; fi
