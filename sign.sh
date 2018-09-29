#!/bin/sh
# Set path to your Android keystore and your keystore alias here, or put them in your environment
[ -z "$ANDROID_KEYSTORE_FILE" ] && ANDROID_KEYSTORE_FILE=~/.android/debug.keystore
[ -z "$ANDROID_KEYSTORE_ALIAS" ] && ANDROID_KEYSTORE_ALIAS=androiddebugkey

APPNAME=`grep AppName AndroidAppSettings.cfg | sed 's/.*=//' | tr -d '"' | tr " '/" '---'`
APPVER=`grep AppVersionName AndroidAppSettings.cfg | sed 's/.*=//' | tr -d '"' | tr " '/" '---'`

cd project/app/build/outputs/apk/

# Remove old certificate
rm -f Signed.apk
cp -f app-release.apk Signed.apk
#zip -d Signed.apk "META-INF/*"
# Sign with the new certificate
rm -f ../../../../../$APPNAME-$APPVER.apk
zipalign 4 Signed.apk ../../../../../$APPNAME-$APPVER.apk
rm -f Signed.apk
echo Using keystore $ANDROID_KEYSTORE_FILE and alias $ANDROID_KEYSTORE_ALIAS
stty -echo
apksigner sign --ks $ANDROID_KEYSTORE_FILE --ks-key-alias $ANDROID_KEYSTORE_ALIAS ../../../../../$APPNAME-$APPVER.apk || exit 1
stty echo
echo
