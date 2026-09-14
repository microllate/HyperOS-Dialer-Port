#!/system/bin/sh

SKIPMOUNT=true
PROPFILE=true
POSTFSDATA=false
LATESTARTSERVICE=false

ui_print "*******************************"
ui_print " HyperOS Dialer Port v0.4.0"
ui_print " Android 15 / HyperOS OS3"
ui_print "*******************************"

ui_print "- China InCallUI + MIUI Contacts"
ui_print "- OS2 China TeleService / com.android.phone"
ui_print "- MMS is deferred"
ui_print "- No pm install / pm uninstall-system-updates"
ui_print "- Payload is mounted by KernelSU/meta-overlayfs"

if [ "$(getprop ro.product.device)" != "mondrian" ]; then
    ui_print "! Warning: device is not mondrian"
fi

if [ "$(getprop ro.build.version.release)" -lt 15 ]; then
    ui_print "! Warning: Android < 15 is not the target"
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644
