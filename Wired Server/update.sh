#!/bin/sh

#  update.sh
#  Wired Server
#
#  Created by Rafaël Warnault on 11/01/12.
#  Copyright (c) 2012 Read-Write. All rights reserved.

SOURCE="$1"
LIBRARY="$2"

echo $SOURCE
echo $LIBRARY

install -m 755 "$SOURCE/Wired/wired.xml" "$LIBRARY/Wired" || exit 1
install -m 755 "$SOURCE/Wired/wiredctl" "$LIBRARY/Wired" || exit 1
install -m 755 "$SOURCE/Wired/wired" "$LIBRARY/Wired" || exit 1

exit 0