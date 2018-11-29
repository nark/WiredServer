#!/bin/sh

PATH="/opt/local/bin:/usr/local/bin:$PATH"

# handle debug configuration (disabled)
if echo $CONFIGURATION | grep -q Debug; then
	CFLAGS="$CFLAGS -O0"
else
	CFLAGS="$CFLAGS -O2"
fi

# wired user & group
WIRED_USER=$(id -un)
WIRED_GROUP=$(id -gn)

# produce error...
BUILD=$("$SRCROOT/../wired/config.guess")

# remove previous compiled files
if [ -d "$TARGET_TEMP_DIR" ]; then
    rm -rf "$TARGET_TEMP_DIR"
fi

# compiler default settings
HOST="x86_64-apple-darwin$(uname -r)"
ARCH_CC="/usr/bin/clang -arch x86_64"
ARCH_CFLAGS="$CFLAGS "
ARCH_CPPFLAGS="$CPPFLAGS -arch x86_64"

# architecture specific settings
SDKROOT="$DEVELOPER_SDK_DIR/MacOSX.sdk"
MACOSX_DEPLOYMENT_TARGET=10.10

# OSX compiler setting
ARCH_CPPFLAGS="$ARCH_CPPFLAGS -isysroot $SDKROOT -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET -lsqlite3 -L$SDKROOT/usr/lib -lcrypto -lssl -L/usr/local/opt/openssl/lib -I/usr/local/opt/openssl/include"

# configure wired stand-alone, without libwired
cd "$SRCROOT/../wired"
C="$ARCH_CC" CFLAGS="$ARCH_CFLAGS" CPPFLAGS="$ARCH_CPPFLAGS -I$TARGET_TEMP_DIR/make" ./configure --host="$HOST" --build="$BUILD" --enable-warnings --srcdir="$SRCROOT/../wired" --with-objdir="$OBJECT_FILE_DIR" --with-rundir="$TARGET_TEMP_DIR/run/wired" --prefix="$BUILT_PRODUCTS_DIR/" --with-fake-prefix="/Library" --with-wireddir="Wired" --with-user="$WIRED_USER" --with-group="$WIRED_GROUP" --without-libwired || exit 1

mkdir -p "$TARGET_TEMP_DIR/make/libwired" "$TARGET_TEMP_DIR/run" "$BUILT_PRODUCTS_DIR"
mv config.h Makefile "$TARGET_TEMP_DIR/make/"

# configure libwired
cd "$SRCROOT/../wired/libwired"
CC="$ARCH_CC" CFLAGS="$ARCH_CFLAGS" CPPFLAGS="$ARCH_CPPFLAGS -I$TARGET_TEMP_DIR/make/libwired" ./configure --host="$HOST" --build="$BUILD" --enable-warnings --enable-pthreads --enable-libxml2 --enable-p7 --enable-sqlite3 --srcdir="$SRCROOT/../wired/libwired" --with-rundir="$TARGET_TEMP_DIR/run/wired/libwired" || exit 1

mv config.h Makefile "$TARGET_TEMP_DIR/make/libwired"


# then make for architecture
cd "$TARGET_TEMP_DIR/make"
make -f "$TARGET_TEMP_DIR/make/Makefile" || exit 1

# prepare subdirectories and support file for Wired root directory
mkdir -p "$BUILT_PRODUCTS_DIR/Wired"
mkdir -p "$TARGET_TEMP_DIR/run/wired/files/Drop Box/.wired" "$TARGET_TEMP_DIR/run/wired/files/Uploads/.wired"
for i in "banner.png" "files/Drop Box/.wired/permissions" "files/Drop Box/.wired/type" "files/Uploads/.wired/type" "wired.xml"; 
do
	cp "$SRCROOT/../wired/run/$i" "$TARGET_TEMP_DIR/run/wired"
done

# use make install (properly configured before) to install (using make) the Wired directory into the Xcode product folder
make -f "$TARGET_TEMP_DIR/make/Makefile" install-wired || exit 1

#find "$BUILT_PRODUCTS_DIR" -name .git -print0 | xargs -0 sudo rm -rf
