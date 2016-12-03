#!/bin/bash -ev

cd lib

libtool -static i386/libchilkatIos.a x86_64/libchilkatIos.a armv7s/libchilkatIos.a armv7/libchilkatIos.a arm64/libchilkatIos.a armv6/libchilkatIos.a -o libchilkatIos.a

cd ..
