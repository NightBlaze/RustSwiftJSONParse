#!/bin/sh

PROTOS_DIR=../../rustengine/src/protos
OUT_IOS_PROTOS_DIR=../../ios/RustSwiftJSONParse/Protos

echo "Cleaning..."
rm -drf $OUT_IOS_PROTOS_DIR
mkdir -p $OUT_IOS_PROTOS_DIR

echo $(find $PROTOS_DIR -iname "*.proto")

echo "Building swift files..."
protoc --proto_path=$PROTOS_DIR --swift_opt=FileNaming=DropPath --swift_out=$OUT_IOS_PROTOS_DIR  $(find $PROTOS_DIR -iname "*.proto")

echo "Done!"