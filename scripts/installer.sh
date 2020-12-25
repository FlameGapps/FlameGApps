#!/sbin/sh
#
###########################################
#
# Copyright (C) 2020 FlameGApps Project
#
# This file is part of the FlameGApps Project created by ayandebnath
#
# The FlameGApps scripts are free software, you can redistribute and/or modify them.
#
# These scripts are distributed in the hope that they will be useful, but WITHOUT ANY WARRANTY.
#
###########################################
# File Name    : installer.sh
###########################################
##
# List of the basic edition gapps files
gapps_list_basic="
CalendarSync
DigitalWellbeing
GoogleLocationHistory
MarkupGoogle
SetupWizard
SoundPickerGoogle"

# List of the full edition gapps files
gapps_list_full="
CalendarSync
DeviceHealthServices
DigitalWellbeing
GoogleClock
GoogleCalendar
GoogleCalculator
GoogleContacts
GoogleDialer
GoogleMessages
GoogleKeyboard
GooglePhotos
GoogleLocationHistory
MarkupGoogle
SetupWizard
SoundPickerGoogle
WallpaperPickerGoogle"

# Pre-installed unnecessary app list
rm_list_basic="
app/ExtShared
app/FaceLock
app/GoogleExtShared
app/GoogleContactSyncAdapter
priv-app/ExtServices
priv-app/AndroidPlatformServices
priv-app/GoogleServicesFramework
priv-app/GmsCoreSetupPrebuilt
priv-app/GmsCore
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/Phonesky
priv-app/SetupWizard
priv-app/Wellbeing
priv-app/WellbeingGooglePrebuilt
priv-app/WellbeingPrebuilt"

rm_list_full="
app/AudioFX
app/ExtShared
app/Etar
app/FaceLock
app/Clock
app/DeskClock
app/DashClock
app/PrebuiltDeskClock
app/Calculator
app/Calculator2
app/ExactCalculator
app/RevengeOSCalculator
app/Calendar
app/CalendarPrebuilt
app/SimpleCalendar
app/Eleven
app/message
app/messages
app/Messages
app/MarkupGoogle
app/MarkupPrebuilt
app/MarkupGooglePrebuilt
app/PrebuiltBugle
app/Hangouts
app/SoundPicker
app/SoundPickerPrebuilt
app/PrebuiltSoundPicker
app/Contacts
app/ChromePublic
app/Photos
app/PhotosPrebuilt
app/Gallery2
app/SimpleGallery
app/GalleryGo
app/GalleryGoPrebuilt
app/CalculatorGooglePrebuilt
app/CalendarGooglePrebuilt
app/Messaging
app/Messenger
app/messaging
app/RevengeMessages
app/QKSMS
app/Email
app/Email2
app/Gmail
app/GmailPrebuilt
app/Maps
app/MapsPrebuilt
app/Music
app/MusicPrebuilt
app/Music2
app/RetroMusicPlayer
app/RetroMusicPlayerPrebuilt
app/LatinIMEGoogle
app/LatinIMEGooglePrebuilt
app/Browser
app/BrowserPrebuilt
app/Browser2
app/Jelly
app/Via
app/ViaPrebuilt
app/ViaBrowser
app/ViaBrowserPrebuilt
app/LatinIME
app/LatinIMEPrebuilt
priv-app/AudioFX
priv-app/ExtServices
priv-app/Browser
priv-app/BrowserPrebuilt
priv-app/Browser2
priv-app/Jelly
priv-app/Via
priv-app/ViaPrebuilt
priv-app/ViaBrowser
priv-app/ViaBrowserPrebuilt
priv-app/LatinIME
priv-app/GoogleServicesFramework
priv-app/GmsCore
priv-app/GmsCorePrebuilt
priv-app/PrebuiltGmsCore
priv-app/PrebuiltGmsCorePi
priv-app/PrebuiltGmsCoreQt
priv-app/SetupWizard
priv-app/SetupWizardPrebuilt
priv-app/PixelSetupWizard
priv-app/Wellbeing
priv-app/CarrierSetup
priv-app/ConfigUpdater
priv-app/GmsCoreSetupPrebuilt
priv-app/Gallery
priv-app/GalleryPrebuilt
priv-app/Gallery2
priv-app/Gallery3d
priv-app/GalleryGo
priv-app/GalleryGoPrebuilt
priv-app/PrebuiltGalleryGo
priv-app/SimpleGallery
priv-app/Photos
priv-app/Contact
priv-app/Contacts
priv-app/GoogleContacts
priv-app/GoogleDialer
priv-app/Music
priv-app/MusicPrebuilt
priv-app/Music2
priv-app/RetroMusicPlayer
priv-app/RetroMusicPlayerPrebuilt
priv-app/crDroidMusic
priv-app/SnapGallery
priv-app/SnapdragonGallery
priv-app/Clock
priv-app/Calendar
priv-app/Calculator
priv-app/Hangouts
priv-app/Messaging
priv-app/Gmail
priv-app/GmailPrebuilt
priv-app/Email
priv-app/Email2
priv-app/Eleven
priv-app/Maps
priv-app/MapsPrebuilt
priv-app/GoogleMaps
priv-app/GoogleMapsPrebuilt
priv-app/MarkupGoogle
priv-app/MarkupGooglePrebuilt
priv-app/PrebuiltDeskClock
priv-app/SoundPicker
priv-app/SoundPickerPrebuilt
priv-app/PrebuiltSoundPicker
priv-app/Turbo
priv-app/TurboPrebuilt
priv-app/Wallpapers
priv-app/WallpaperPrebuilt
priv-app/WallpapersPrebuilt
priv-app/WallpapersGooglePrebuilt
priv-app/WallpaperGooglePrebuilt
priv-app/DeviceHealthService
priv-app/AndroidPlafoPlatformServices
priv-app/LatinIMEGooglePrebuilt"

stock_camera="
app/Snap
app/Camera2
app/SimpleCamera
priv-app/Snap
priv-app/Camera2
priv-app/SimpleCamera"

ui_print() {
  echo "ui_print $1
    ui_print" >> $OUTFD
}

set_progress() { echo "set_progress $1" >> $OUTFD; }

is_mounted() { mount | grep -q " $1 "; }

setup_mountpoint() {
  test -L $1 && mv -f $1 ${1}_link
  if [ ! -d $1 ]; then
    rm -f $1
    mkdir $1
  fi
}

recovery_actions() {
  OLD_LD_LIB=$LD_LIBRARY_PATH
  OLD_LD_PRE=$LD_PRELOAD
  OLD_LD_CFG=$LD_CONFIG_FILE
  unset LD_LIBRARY_PATH
  unset LD_PRELOAD
  unset LD_CONFIG_FILE
}

recovery_cleanup() {
  [ -z $OLD_LD_LIB ] || export LD_LIBRARY_PATH=$OLD_LD_LIB
  [ -z $OLD_LD_PRE ] || export LD_PRELOAD=$OLD_LD_PRE
  [ -z $OLD_LD_CFG ] || export LD_CONFIG_FILE=$OLD_LD_CFG
}

clean_up() {
  rm -rf /tmp/flamegapps
  rm -rf /tmp/config.prop
  rm -rf /tmp/flame.prop
  rm -rf /tmp/addon.d.sh
  rm -rf /tmp/tar_gapps
  rm -rf /tmp/unzip_dir
}

path_info() {
  ls / > "$log_dir/rootpathinfo.txt"
  ls -R $SYSTEM > "$log_dir/systempathinfo.txt"
  ls -R $SYSTEM/product > "$log_dir/productpathinfo.txt" 2>/dev/null
  ls -R $SYSTEM/system_ext > "$log_dir/system_extpathinfo.txt" 2>/dev/null
}

space_before() {
  df -h > $log_dir/space_before.txt
}

space_after() {
  df -h > $log_dir/space_after.txt
}

take_logs() {
  ui_print " "
  ui_print "- Copying logs to /sdcard & $zip_dir"
  cp -f $TMP/recovery.log $log_dir/recovery.log
  cd $log_dir
  tar -cz -f "$TMP/flamegapps_debug_logs.tar.gz" *
  cp -f $TMP/flamegapps_debug_logs.tar.gz $zip_dir/flamegapps_debug_logs.tar.gz
  cp -f $TMP/flamegapps_debug_logs.tar.gz /sdcard/flamegapps_debug_logs.tar.gz
  cd /
  rm -rf $TMP/flamegapps_debug_logs.tar.gz
}

get_file_prop() {
  grep -m1 "^$2=" "$1" | cut -d= -f2
}

get_prop() {
  # check known .prop files using get_file_prop
  for f in $PROPFILES; do
    if [ -e "$f" ]; then
      prop="$(get_file_prop "$f" "$1")"
      if [ -n "$prop" ]; then
        break # if an entry has been found, break out of the loop
      fi
    fi
  done
  # if prop is still empty; try to use recovery's built-in getprop method; otherwise output current result
  if [ -z "$prop" ]; then
    getprop "$1" | cut -c1-
  else
    printf "$prop"
  fi
}

abort() {
  sleep 1
  ui_print "- Aborting..."
  sleep 3
  path_info
  unmount_all
  take_logs
  clean_up
  recovery_cleanup
  exit 1;
}

exit_all() {
  sleep 0.5
  path_info
  space_after
  unmount_all
  sleep 0.5
  set_progress 0.90
  take_logs
  clean_up
  recovery_cleanup
  sleep 0.5
  ui_print " "
  ui_print "- Installation Successful..!"
  ui_print " "
  set_progress 1.00
  exit 0;
}

mount_apex() {
  # For reference, check: https://github.com/osm0sis/AnyKernel3/blob/master/META-INF/com/google/android/update-binary
  if [ -d $SYSTEM/apex ]; then
    local apex dest loop minorx num
    setup_mountpoint /apex
    test -e /dev/block/loop1 && minorx=$(ls -l /dev/block/loop1 | awk '{ print $6 }') || minorx=1
    num=0
    for apex in $SYSTEM/apex/*; do
      dest=/apex/$(basename $apex .apex)
      test "$dest" = /apex/com.android.runtime.release && dest=/apex/com.android.runtime
      mkdir -p $dest
      case $apex in
        *.apex)
          unzip -qo $apex apex_payload.img -d /apex
          mv -f /apex/apex_payload.img $dest.img
          mount -t ext4 -o ro,noatime $dest.img $dest 2>/dev/null
          if [ $? != 0 ]; then
            while [ $num -lt 64 ]; do
              loop=/dev/block/loop$num
              (mknod $loop b 7 $((num * minorx))
              losetup $loop $dest.img) 2>/dev/null
              num=$((num + 1))
              losetup $loop | grep -q $dest.img && break
            done
            mount -t ext4 -o ro,loop,noatime $loop $dest
            if [ $? != 0 ]; then
              losetup -d $loop 2>/dev/null
            fi
          fi
        ;;
        *) mount -o bind $apex $dest;;
      esac
    done
    export ANDROID_RUNTIME_ROOT=/apex/com.android.runtime
    export ANDROID_TZDATA_ROOT=/apex/com.android.tzdata
    export BOOTCLASSPATH=/apex/com.android.runtime/javalib/core-oj.jar:/apex/com.android.runtime/javalib/core-libart.jar:/apex/com.android.runtime/javalib/okhttp.jar:/apex/com.android.runtime/javalib/bouncycastle.jar:/apex/com.android.runtime/javalib/apache-xml.jar:/system/framework/framework.jar:/system/framework/ext.jar:/system/framework/telephony-common.jar:/system/framework/voip-common.jar:/system/framework/ims-common.jar:/system/framework/android.test.base.jar:/apex/com.android.conscrypt/javalib/conscrypt.jar:/apex/com.android.media/javalib/updatable-media.jar
  fi
}

unmount_apex() {
  if [ -d $SYSTEM/apex ]; then
    local dest loop
    for dest in $(find /apex -type d -mindepth 1 -maxdepth 1); do
      if [ -f $dest.img ]; then
        loop=$(mount | grep $dest | cut -d" " -f1)
      fi
      (umount -l $dest
      losetup -d $loop) 2>/dev/null
    done
    rm -rf /apex 2>/dev/null
    unset ANDROID_RUNTIME_ROOT ANDROID_TZDATA_ROOT BOOTCLASSPATH
  fi
}

mount_all() {
  set_progress 0.10
  ui_print "- Mounting partitions"
  sleep 1
  dynamic_partitions=`getprop ro.boot.dynamic_partitions`
  SLOT=`getprop ro.boot.slot_suffix`
  [ ! -z "$SLOT" ] && ui_print "- Current boot slot: $SLOT"

  if [ -n "$(cat /etc/fstab | grep /system_root)" ]; then
    MOUNT_POINT=/system_root
  else
    MOUNT_POINT=/system
  fi

  for p in "/cache" "/data" "$MOUNT_POINT" "/product" "/system_ext" "/vendor"; do
    if [ -d "$p" ] && grep -q "$p" "/etc/fstab" && ! is_mounted "$p"; then
      mount "$p"
    fi
  done

  if [ "$dynamic_partitions" = "true" ]; then
    ui_print "- Dynamic partition detected"
    for m in "/system" "/system_root" "/product" "/system_ext" "/vendor"; do
      (umount "$m"
      umount -l "$m") 2>/dev/null
    done
    mount -o ro -t auto /dev/block/mapper/system$SLOT /system_root
    mount -o ro -t auto /dev/block/mapper/vendor$SLOT /vendor 2>/dev/null
    mount -o ro -t auto /dev/block/mapper/product$SLOT /product 2>/dev/null
    mount -o ro -t auto /dev/block/mapper/system_ext$SLOT /system_ext 2>/dev/null
  else
    mount -o ro -t auto /dev/block/bootdevice/by-name/system$SLOT $MOUNT_POINT 2>/dev/null
  fi

  if [ "$dynamic_partitions" = "true" ]; then
    for block in system vendor product system_ext; do
      for slot in "" _a _b; do
        blockdev --setrw /dev/block/mapper/$block$slot 2>/dev/null
      done
    done
    mount -o rw,remount -t auto /dev/block/mapper/system$SLOT /system_root
    mount -o rw,remount -t auto /dev/block/mapper/vendor$SLOT /vendor 2>/dev/null
    mount -o rw,remount -t auto /dev/block/mapper/product$SLOT /product 2>/dev/null
    mount -o rw,remount -t auto /dev/block/mapper/system_ext$SLOT /system_ext 2>/dev/null
  else
    mount -o rw,remount -t auto $MOUNT_POINT
    mount -o rw,remount -t auto /vendor 2>/dev/null
    mount -o rw,remount -t auto /product 2>/dev/null
    mount -o rw,remount -t auto /system_ext 2>/dev/null
  fi

  sleep 0.3
  
  if is_mounted /system_root; then
    ui_print "- Device is system-as-root"
    if [ -f /system_root/build.prop ]; then
      mount -o bind /system_root /system
      SYSTEM=/system_root
      ui_print "- System is $SYSTEM"
    else
      mount -o bind /system_root/system /system
      SYSTEM=/system_root/system
      ui_print "- System is $SYSTEM"
    fi
  elif is_mounted /system; then
    if [ -f /system/build.prop ]; then
      SYSTEM=/system
      ui_print "- System is $SYSTEM"
    elif [ -f /system/system/build.prop ]; then
      ui_print "- Device is system-as-root"
      mkdir -p /system_root
      mount --move /system /system_root
      mount -o bind /system_root/system /system
      SYSTEM=/system_root/system
      ui_print "- System is /system/system"
    fi
  else
    ui_print "- Failed to mount/detect system"
    abort
  fi
  mount_apex
}

unmount_all() {
  unmount_apex
  ui_print " "
  ui_print "- Unmounting partitions"
  for m in "/system" "/system_root" "/product" "/system_ext" "/vendor"; do
    if [ -e $m ]; then
      (umount $m
      umount -l $m) 2>/dev/null
    fi
  done
}

mount -o bind /dev/urandom /dev/random
unmount_all
mount_all

recovery_actions

PROPFILES="$SYSTEM/build.prop $TMP/flame.prop"
CORE_DIR="$TMP/tar_core"
GAPPS_DIR="$TMP/tar_gapps"
UNZIP_FOLDER="$TMP/unzip_dir"
EX_SYSTEM="$UNZIP_FOLDER/system"
zip_dir="$(dirname "$ZIPFILE")"
log_dir="$TMP/flamegapps/logs"
flame_log="$log_dir/installation_log.txt"
build_info="$log_dir/build_info.prop"
mkdir -p $UNZIP_FOLDER
mkdir -p $log_dir
space_before

# Get ROM, device & package information
flame_android=`get_prop ro.flame.android`
flame_sdk=`get_prop ro.flame.sdk`
flame_arch=`get_prop ro.flame.arch`
flame_edition=`get_prop ro.flame.edition`
rom_version=`get_prop ro.build.version.release`
rom_sdk=`get_prop ro.build.version.sdk`
device_architecture=`get_prop ro.product.cpu.abilist`
device_code=`get_prop ro.product.device`

if [ -z "$device_architecture" ]; then
  device_architecture=`get_prop ro.product.cpu.abi`
fi

case "$device_architecture" in
  *x86_64*) arch="x86_64"
    ;;
  *x86*) arch="x86"
    ;;
  *arm64*) arch="arm64"
    ;;
  *armeabi*) arch="arm"
    ;;
  *) arch="unknown"
    ;;
esac

echo ------------------------------------------------------------------- >> $flame_log
(echo "  --------------- FlameGApps Installation Logs ---------------"
echo "- Mount Point: $MOUNT_POINT"
echo "- Current slot: $SLOT"
echo "- Dynamic partition: $dynamic_partitions"
echo "- Flame version: $flame_android"
echo "- Flame SDK: $flame_sdk"
echo "- Flame ARCH: $flame_arch"
echo "- ROM version: $rom_version"
echo "- ROM SDK: $rom_sdk"
echo "- Device ARCH: $device_architecture ($arch)"
echo "- Device code: $device_code") >> $flame_log
cat $SYSTEM/build.prop > $build_info
cat $TMP/flame.prop >> $build_info

set_progress 0.20
sleep 1
ui_print " "
ui_print "- Android: $rom_version, SDK: $rom_sdk, ARCH: $arch"
sleep 1

if [ ! "$rom_sdk" = "$flame_sdk" ]; then
  ui_print " "
  ui_print "****************** WARNING *******************"
  ui_print " "
  ui_print "! Wrong android version detected"
  sleep 0.5
  ui_print "This package is for android: $flame_android only"
  sleep 0.5
  ui_print "Your ROM is Android: $rom_version"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  ui_print " "
  abort
fi

if [ ! "$arch" = "$flame_arch" ]; then
  ui_print " "
  ui_print "****************** WARNING *******************"
  ui_print " "
  ui_print "! Wrong device architecture detected"
  sleep 0.5
  ui_print "This package is for device: $flame_arch only"
  sleep 0.5
  ui_print "Your device is: $arch"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  ui_print " "
  abort
fi

# Remove pre-installed unnecessary system apps
ui_print " "
if [ "$flame_edition" = "basic" ]; then
  ui_print "- Removing unnecessary system apps"
  ui_print " "
  set_progress 0.30
  sleep 0.5
  echo -e "\n- Removing basic list files" >> $flame_log
  for f in $rm_list_basic; do
    rm -rf $SYSTEM/$f
    if [ $rom_sdk -gt 28 ]; then
      rm -rf $SYSTEM/product/$f
    fi
    if [ $rom_sdk -gt 29 ]; then
      rm -rf $SYSTEM/system_ext/$f
    fi
  done
elif [ "$flame_edition" = "full" ]; then
  ui_print "- Removing unnecessary system apps"
  ui_print " "
  set_progress 0.30
  sleep 0.5
  echo -e "\n- Removing full list files" >> $flame_log
  for f in $rm_list_full; do
    rm -rf $SYSTEM/$f
    if [ $rom_sdk -gt 28 ]; then
      rm -rf $SYSTEM/product/$f
    fi
    if [ $rom_sdk -gt 29 ]; then
      rm -rf $SYSTEM/system_ext/$f
    fi
  done
else
  ui_print "****************** WARNING *******************"
  ui_print " "
  sleep 0.5
  echo "- Failed to detect edition type" >> $flame_log
  ui_print "! Failed to detect FlameGApps edition type"
  sleep 0.5
  ui_print " "
  ui_print "******* FlameGApps Installation Failed *******"
  abort
fi

install_core() {
  set_progress 0.50
  ui_print "- Installing Core GApps"
  ui_print " "
  unzip -o "$ZIPFILE" 'tar_core/*' -d $TMP
  tar -xf "$CORE_DIR/Core.tar.xz" -C $UNZIP_FOLDER
  file_list="$(find "$EX_SYSTEM/" -mindepth 1 -type f | cut -d/ -f5-)"
  dir_list="$(find "$EX_SYSTEM/" -mindepth 1 -type d | cut -d/ -f5-)"
  for file in $file_list; do
    install -D "$EX_SYSTEM/${file}" "$SYSTEM/${file}"
    chcon -h u:object_r:system_file:s0 "$SYSTEM/${file}"
    chmod 0644 "$SYSTEM/${file}"
  done
  for dir in $dir_list; do
    chcon -h u:object_r:system_file:s0 "$SYSTEM/${dir}"
    chmod 0755 "$SYSTEM/${dir}"
  done
  rm -rf $CORE_DIR
  rm -rf $UNZIP_FOLDER/*
}

install_gapps() {
  set_progress 0.70
  for g in $gapps_list; do
    ui_print "- Installing $g"
    unzip -o "$ZIPFILE" "tar_gapps/$g.tar.xz" -d $TMP
    tar -xf "$GAPPS_DIR/$g.tar.xz" -C $UNZIP_FOLDER
    rm -rf $GAPPS_DIR/$g.tar.xz
    file_list="$(find "$EX_SYSTEM/" -mindepth 1 -type f | cut -d/ -f5-)"
    dir_list="$(find "$EX_SYSTEM/" -mindepth 1 -type d | cut -d/ -f5-)"
    for file in $file_list; do
      install -D "$EX_SYSTEM/${file}" "$SYSTEM/${file}"
      chcon -h u:object_r:system_file:s0 "$SYSTEM/${file}"
      chmod 0644 "$SYSTEM/${file}"
    done
    for dir in $dir_list; do
      chcon -h u:object_r:system_file:s0 "$SYSTEM/${dir}"
      chmod 0755 "$SYSTEM/${dir}"
    done
    rm -rf $UNZIP_FOLDER/*
  done
}

# remove_line <file> <line match string> by osm0sis @xda-developers
remove_line() {
  if grep -q "$2" $1; then
    local line=$(grep -n "$2" $1 | head -n1 | cut -d: -f1);
    sed -i "${line}d" $1;
  fi
}

basic_config() {
  set_progress 0.75
  if [ -e "$zip_dir/flamegapps-config.txt" ] || [ -e "/sdcard/flamegapps-config.txt" ]; then
     for p in $zip_dir /sdcard; do
      if [ -e $p/flamegapps-config.txt ] && [ ! -e $TMP/config.prop ]; then
        cp -f $p/flamegapps-config.txt $TMP/config.prop
        chmod 0644 "$TMP/config.prop"
      fi
    done
    ui_print " "
    ui_print "- Config detected in successfully"
    ui_print " "
    sleep 1
    rm_setupwizard=`get_file_prop $TMP/config.prop "ro.basic.remove.setupwizard"`
    rm_wellbeing=`get_file_prop $TMP/config.prop "ro.basic.remove.wellbeing"`
    rm_sounds=`get_file_prop $TMP/config.prop "ro.basic.remove.sounds"`
    rm_markup=`get_file_prop $TMP/config.prop "ro.basic.remove.markup"`
    if [ "$rm_setupwizard" = "1" ]; then
      ui_print "- Removing SetupWizard"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/GoogleRestore
      rm -rf $SYSTEM/priv-app/GoogleBackupTransport
      rm -rf $SYSTEM/priv-app/AndroidMigratePrebuilt
      rm -rf $SYSTEM/priv-app/SetupWizard
      remove_line $TMP/addon.d.sh "priv-app/GoogleRestore/GoogleRestore.apk"
      remove_line $TMP/addon.d.sh "priv-app/GoogleBackupTransport/GoogleBackupTransport.apk"
      remove_line $TMP/addon.d.sh "priv-app/SetupWizard/SetupWizard.apk"
      remove_line $TMP/addon.d.sh "priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk"
      remove_line $TMP/addon.d.sh "priv-app/Provision"
      remove_line $TMP/addon.d.sh "priv-app/LineageSetupWizard"
    fi
    if [ "$rm_sounds" = "1" ]; then
      ui_print "- Removing GoogleSoundPicker"
      sleep 0.3
      rm -rf $SYSTEM/app/SoundPickerPrebuilt
      remove_line $TMP/addon.d.sh "app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk"
    fi
    if [ "$rm_markup" = "1" ]; then
      ui_print "- Removing GoogleMarkup"
      sleep 0.3
      rm -rf $SYSTEM/app/MarkupGoogle
      rm -rf $SYSTEM/app/lib64/libsketchology_native.so
      remove_line $TMP/addon.d.sh "app/MarkupGoogle/MarkupGoogle.apk"
      remove_line $TMP/addon.d.sh "app/MarkupGoogle/lib/arm64/libsketchology_native.so"
    fi
    if [ "$rm_wellbeing" = "1" ]; then
      ui_print "- Removing DigitalWellbeing"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/WellbeingPrebuilt
      remove_line $TMP/addon.d.sh "priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk"
    fi
  fi
}

full_config() {
  set_progress 0.75
  if [ -e "$zip_dir/flamegapps-config.txt" ] || [ -e "/sdcard/flamegapps-config.txt" ]; then
    for p in $zip_dir /sdcard; do
      if [ -e $p/flamegapps-config.txt ] && [ ! -e $TMP/config.prop ]; then
        cp -f $p/flamegapps-config.txt $TMP/config.prop
        chmod 0644 $TMP/config.prop
      fi
    done
    cp -f $TMP/config.prop $log_dir/config.prop
    ui_print " "
    ui_print "- Config detected in successfully"
    ui_print " "
    sleep 1
    rm_setupwizard=`get_file_prop $TMP/config.prop "ro.full.remove.setupwizard"`
    rm_wellbeing=`get_file_prop $TMP/config.prop "ro.full.remove.wellbeing"`
    rm_photos=`get_file_prop $TMP/config.prop "ro.full.remove.photos"`
    rm_calendar=`get_file_prop $TMP/config.prop "ro.full.remove.calendar"`
    rm_calculator=`get_file_prop $TMP/config.prop "ro.full.remove.calculator"`
    rm_sounds=`get_file_prop $TMP/config.prop "ro.full.remove.sounds"`
    rm_turbo=`get_file_prop $TMP/config.prop "ro.full.remove.turbo"`
    rm_wallpapers=`get_file_prop $TMP/config.prop "ro.full.remove.wallpapers"`
    rm_gdialer=`get_file_prop $TMP/config.prop "ro.full.remove.gdialer"`
    rm_markup=`get_file_prop $TMP/config.prop "ro.full.remove.markup"`
    keep_snap=`get_file_prop $TMP/config.prop "ro.full.keep.snap"`
    if [ "$rm_setupwizard" = "1" ]; then
      ui_print "- Removing SetupWizard"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/GoogleRestore
      rm -rf $SYSTEM/priv-app/GoogleBackupTransport
      rm -rf $SYSTEM/priv-app/AndroidMigratePrebuilt
      rm -rf $SYSTEM/priv-app/SetupWizard
      remove_line $TMP/addon.d.sh "priv-app/GoogleRestore/GoogleRestore.apk"
      remove_line $TMP/addon.d.sh "priv-app/GoogleBackupTransport/GoogleBackupTransport.apk"
      remove_line $TMP/addon.d.sh "priv-app/SetupWizard/SetupWizard.apk"
      remove_line $TMP/addon.d.sh "priv-app/AndroidMigratePrebuilt/AndroidMigratePrebuilt.apk"
      remove_line $TMP/addon.d.sh "priv-app/Provision"
      remove_line $TMP/addon.d.sh "priv-app/LineageSetupWizard"
    fi
    if [ "$rm_wellbeing" = "1" ]; then
      ui_print "- Removing DigitalWellbeing"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/WellbeingPrebuilt
      remove_line $TMP/addon.d.sh "priv-app/WellbeingPrebuilt/WellbeingPrebuilt.apk"
    fi
    if [ "$rm_gdialer" = "1" ]; then
      ui_print "- Removing GoogleDialer"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/GoogleDialer
      remove_line $TMP/addon.d.sh "priv-app/GoogleDialer/GoogleDialer.apk"
      remove_line $TMP/addon.d.sh "priv-app/Dialer"
    fi
    if [ "$rm_photos" = "1" ]; then
      ui_print "- Removing GooglePhotos"
      sleep 0.3
      rm -rf $SYSTEM/app/Photos
      remove_line $TMP/addon.d.sh "app/Photos/Photos.apk"
    fi
    if [ "$rm_calendar" = "1" ]; then
      ui_print "- Removing GoogleCalendar"
      sleep 0.3
      rm -rf $SYSTEM/app/CalendarGooglePrebuilt
      remove_line $TMP/addon.d.sh "app/CalendarGooglePrebuilt/CalendarGooglePrebuilt.apk"
    fi
    if [ "$rm_calculator" = "1" ]; then
      ui_print "- Removing GoogleCalculator"
      sleep 0.3
      rm -rf $SYSTEM/app/CalculatorGooglePrebuilt
      remove_line $TMP/addon.d.sh "app/CalculatorGooglePrebuilt/CalculatorGooglePrebuilt.apk"
    fi
    if [ "$rm_sounds" = "1" ]; then
      ui_print "- Removing GoogleSoundPicker"
      sleep 0.3
      rm -rf $SYSTEM/app/SoundPickerPrebuilt
      remove_line $TMP/addon.d.sh "app/SoundPickerPrebuilt/SoundPickerPrebuilt.apk"
    fi
    if [ "$rm_markup" = "1" ]; then
      ui_print "- Removing GoogleMarkup"
      sleep 0.3
      rm -rf $SYSTEM/app/MarkupGoogle
      rm -rf $SYSTEM/app/lib64/libsketchology_native.so
      remove_line $TMP/addon.d.sh "app/MarkupGoogle/MarkupGoogle.apk"
      remove_line $TMP/addon.d.sh "app/MarkupGoogle/lib/arm64/libsketchology_native.so"
    fi
    if [ "$rm_turbo" = "1" ]; then
      ui_print "- Removing DeviceHealthServices"
      sleep 0.3
      rm -rf $SYSTEM/priv-app/Turbo
      remove_line $TMP/addon.d.sh "priv-app/Turbo/Turbo.apk"
    fi
    if [ "$rm_wallpapers" = "1" ]; then
      ui_print "- Removing GoogleWallpaperPicker"
      sleep 0.3
      rm -rf $SYSTEM/app/WallpaperPickerGooglePrebuilt
      remove_line $TMP/addon.d.sh "app/WallpaperPickerGooglePrebuilt/WallpaperPickerGooglePrebuilt.apk"
    fi
    if [ ! "$keep_snap" = "Y" ]; then
      for f in $stock_camera; do
        rm -rf $SYSTEM/$f
        if [ $rom_sdk -gt 28 ]; then
          rm -rf $SYSTEM/product/$f
        fi
        if [ $rom_sdk -gt 29 ]; then
          rm -rf $SYSTEM/system_ext/$f
        fi
      done
    else
      for f in $stock_camera; do
        remove_line $TMP/addon.d.sh "$f"
      done
    fi
  else
    for f in $stock_camera; do
      rm -rf $SYSTEM/$f
      if [ $rom_sdk -gt 28 ]; then
        rm -rf $SYSTEM/product/$f
      fi
      if [ $rom_sdk -gt 29 ]; then
        rm -rf $SYSTEM/system_ext/$f
      fi
    done
  fi
}

# Ensure gapps list
[ "$flame_edition" = "basic" ] && gapps_list="$gapps_list_basic" || gapps_list="$gapps_list_full"

# Install core gapps files
echo -e "\n- Installing core gapps files" >> $flame_log
install_core >> $flame_log

# Install gapps files
echo -e "\n- Installing gapps files" >> $flame_log
install_gapps >> $flame_log

# Run debloater
echo -e "\n- Debloating Device" >> $flame_log
[ "$flame_edition" = "basic" ] && basic_config || full_config

echo -e "\n                 Installation Finished            " >> $flame_log
echo ----------------------------------------------------------------- >> $flame_log

sleep 0.5
set_progress 0.80
ui_print " "
ui_print "- Performing other tasks"
# Create lib symlinks
if [ -e $SYSTEM/app/MarkupGoogle/MarkupGoogle.apk ]; then
  install -d "$SYSTEM/app/MarkupGoogle/lib/arm64"
  ln -sfn "/system/lib64/libsketchology_native.so" "/system/app/MarkupGoogle/lib/arm64/libsketchology_native.so"
fi

if [ -e $SYSTEM/app/LatinIMEGooglePrebuilt/LatinIMEGooglePrebuilt.apk ]; then
  install -d "$SYSTEM/app/LatinIMEGooglePrebuilt/lib64/arm64"
  ln -sfn "/system/lib64/libjni_latinimegoogle.so" "/system/app/LatinIMEGooglePrebuilt/lib64/arm64/libjni_latinimegoogle.so"
fi

# Delete provision and lineage setupwizard if Google SetupWizard is present
if [ -e $SYSTEM/priv-app/SetupWizard/SetupWizard.apk ]; then
  rm -rf $SYSTEM/priv-app/Provision
  rm -rf $SYSTEM/priv-app/provision
  rm -rf $SYSTEM/priv-app/LineageSetupWizard
  if [ $rom_sdk -gt 28 ]; then
    rm -rf $SYSTEM/product/priv-app/Provision
    rm -rf $SYSTEM/product/priv-app/provision
    rm -rf $SYSTEM/product/priv-app/LineageSetupWizard
  fi
  [ $rom_sdk -gt 29 ] && rm -rf $SYSTEM/system_ext/priv-app/Provision
fi

# Delete AOSP Dialer if Google Dialer is present
if [ -e $SYSTEM/priv-app/GoogleDialer/GoogleDialer.apk ]; then
  rm -rf $SYSTEM/priv-app/Dialer
  [ $rom_sdk -gt 28 ] && rm -rf $SYSTEM/product/priv-app/Dialer
  [ $rom_sdk -gt 29 ] && rm -rf $SYSTEM/system_ext/priv-app/Dialer
fi

# Install addon.d script
if [ -d $SYSTEM/addon.d ]; then
  rm -rf $SYSTEM/addon.d/69-flame.sh
  cp -f $TMP/addon.d.sh $SYSTEM/addon.d/69-flame.sh
  chcon -h u:object_r:system_file:s0 "$SYSTEM/addon.d/69-flame.sh"
  chmod 0755 "$SYSTEM/addon.d/69-flame.sh"
fi

# Install flame.prop
rm -rf $SYSTEM/etc/flame.prop
cp -f $TMP/flame.prop $SYSTEM/etc/flame.prop
chcon -h u:object_r:system_file:s0 "$SYSTEM/etc/flame.prop"
chmod 0644 "$SYSTEM/etc/flame.prop"

# Set Google Dialer/Phone as default phone app if it is present
if [ -e $SYSTEM/priv-app/GoogleDialer/GoogleDialer.apk ]; then
  # set Google Dialer as default; based on the work of osm0sis @ xda-developers
  setver="122"  # lowest version in MM, tagged at 6.0.0
  setsec="/data/system/users/0/settings_secure.xml"
  if [ -f "$setsec" ]; then
    if grep -q 'dialer_default_application' "$setsec"; then
      if ! grep -q 'dialer_default_application" value="com.google.android.dialer' "$setsec"; then
        curentry="$(grep -o 'dialer_default_application" value=.*$' "$setsec")"
        newentry='dialer_default_application" value="com.google.android.dialer" package="android" />\r'
        sed -i "s;${curentry};${newentry};" "$setsec"
      fi
    else
      max="0"
      for i in $(grep -o 'id=.*$' "$setsec" | cut -d '"' -f 2); do
        test "$i" -gt "$max" && max="$i"
      done
      entry='<setting id="'"$((max + 1))"'" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r'
      sed -i "/<settings version=\"/a\ \ ${entry}" "$setsec"
    fi
  else
    if [ ! -d "/data/system/users/0" ]; then
      install -d "/data/system/users/0"
      chown -R 1000:1000 "/data/system"
      chmod -R 775 "/data/system"
      chmod 700 "/data/system/users/0"
    fi
    { echo -e "<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>\r";
    echo -e '<settings version="'$setver'">\r';
    echo -e '  <setting id="1" name="dialer_default_application" value="com.google.android.dialer" package="android" />\r';
    echo -e '</settings>'; } > "$setsec"
  fi
  chown 1000:1000 "$setsec"
  chmod 600 "$setsec"
fi

exit_all;
