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

# loop over Xcode valid architectures
for i in $ARCHS; do
	# configure for architecture (if needed, using "configured" flag file)
	if [ ! -f "$TARGET_TEMP_DIR/make/$i/Makefile" -o ! -f "$TARGET_TEMP_DIR/configured" ]; then
		
		# compiler default settings 
		HOST="$i-apple-darwin$(uname -r)"
		ARCH_CC="$PLATFORM_DEVELOPER_BIN_DIR/llvm-gcc-4.2 -arch $i"
		ARCH_CFLAGS="$CFLAGS " 
		ARCH_CPPFLAGS="$CPPFLAGS -arch $i "

		# architecture specific settings (useless, historical)
		if [ "$i" = "i386" ]; then
			SDKROOT="$DEVELOPER_SDK_DIR/MacOSX10.7.sdk"
			MACOSX_DEPLOYMENT_TARGET=10.6
			
		elif [ "$i" = "x86_64" ]; then
			SDKROOT="$DEVELOPER_SDK_DIR/MacOSX10.7.sdk"
			MACOSX_DEPLOYMENT_TARGET=10.6
		fi
		
		# OSX compiler setting
		ARCH_CPPFLAGS="$ARCH_CPPFLAGS -isysroot $SDKROOT -mmacosx-version-min=$MACOSX_DEPLOYMENT_TARGET -lsqlite3 -L$SDKROOT/usr/lib"
			
		# configure wired stand-alone, without libwired 
		cd "$SRCROOT/../wired"
		C="$ARCH_CC" CFLAGS="$ARCH_CFLAGS" CPPFLAGS="$ARCH_CPPFLAGS -I$TARGET_TEMP_DIR/make/$i" ./configure --host="$HOST" --build="$BUILD" --enable-warnings --srcdir="$SRCROOT/../wired" --with-objdir="$OBJECT_FILE_DIR/$i" --with-rundir="$TARGET_TEMP_DIR/run/$i/wired" --prefix="$BUILT_PRODUCTS_DIR/" --with-fake-prefix="/Library" --with-wireddir="Wired" --with-user="$WIRED_USER" --with-group="$WIRED_GROUP" --without-libwired || exit 1
		
		mkdir -p "$TARGET_TEMP_DIR/make/$i/libwired" "$TARGET_TEMP_DIR/run/$i" "$BUILT_PRODUCTS_DIR"
		mv config.h Makefile "$TARGET_TEMP_DIR/make/$i/"
		
		# configure libwired
		cd "$SRCROOT/../wired/libwired"
		CC="$ARCH_CC" CFLAGS="$ARCH_CFLAGS" CPPFLAGS="$ARCH_CPPFLAGS -I$TARGET_TEMP_DIR/make/$i/libwired" ./configure --host="$HOST" --build="$BUILD" --enable-warnings --enable-pthreads --enable-libxml2 --enable-p7 --enable-sqlite3 --srcdir="$SRCROOT/../wired/libwired" --with-objdir="$OBJECT_FILE_DIR/$i" --with-rundir="$TARGET_TEMP_DIR/run/$i/wired/libwired" || exit 1

		mv config.h Makefile "$TARGET_TEMP_DIR/make/$i/libwired"
		
		# notify that current arch is configured
		touch "$TARGET_TEMP_DIR/configured"
	fi
	
	# then make for architecture
	cd "$TARGET_TEMP_DIR/make/$i"
	make -f "$TARGET_TEMP_DIR/make/$i/Makefile" || exit 1
done

mkdir -p "$BUILT_PRODUCTS_DIR/Wired"

# prepare binaries mastering using lipo
for i in $ARCHS; do
	WIRED_BINARIES="$TARGET_TEMP_DIR/run/$i/wired/wired $WIRED_BINARIES" # a table of binary file path
	MASTER="$i" # last binary will be the universal master
done

# masterize using lipo and create an universal binary
cp "$TARGET_TEMP_DIR/run/$MASTER/wired/wired" "/tmp/wired.$MASTER"
lipo -create $WIRED_BINARIES -output "/tmp/wired.universal" || exit 1
cp "/tmp/wired.universal" "$TARGET_TEMP_DIR/run/$MASTER/wired/wired"

# prepare subdirectories and support file for Wired root directory
mkdir -p "$TARGET_TEMP_DIR/run/$MASTER/wired/files/Drop Box/.wired" "$TARGET_TEMP_DIR/run/$MASTER/wired/files/Uploads/.wired"
for i in "banner.png" "files/Drop Box/.wired/permissions" "files/Drop Box/.wired/type" "files/Uploads/.wired/type" "wired.xml"; 
do
	cp "$SRCROOT/../wired/run/$i" "$TARGET_TEMP_DIR/run/$MASTER/wired/$i"
done

# use make install (properly configured before) to install (using make) the Wired directory into the Xcode product folder
make -f "$TARGET_TEMP_DIR/make/$MASTER/Makefile" install-wired || exit 1

#find "$BUILT_PRODUCTS_DIR" -name .git -print0 | xargs -0 sudo rm -rf
