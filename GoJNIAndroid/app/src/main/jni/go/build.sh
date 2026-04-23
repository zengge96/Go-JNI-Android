#!/bin/bash
set -e

OUTPUT_DIR=$1
SONAME=$2
ARCH=$3
COMPILER=$4
TOOLCHAIN=$5
LLVM_TRIPLE=$6
SYSROOT=$7

# Use standard Go toolchain for cross-compilation
export GOROOT=/usr/local/go
export PATH=$GOROOT/bin:$PATH

# Map architecture names
case $ARCH in
    arm64)
        GOARCH=arm64
        ;;
    armeabi-v7a)
        GOARCH=arm
        ;;
    x86_64)
        GOARCH=amd64
        ;;
    x86)
        GOARCH=386
        ;;
    *)
        GOARCH=arm64
        ;;
esac

# Set up environment for cross-compilation
export CGO_ENABLED=1
export GOOS=android
export GOARCH=$GOARCH
export CC=$COMPILER

# Build flags for Android - use the NDK's clang
export CGO_CFLAGS="--target=$LLVM_TRIPLE --gcc-toolchain=$TOOLCHAIN --sysroot=$SYSROOT"
export CGO_LDFLAGS="--target=$LLVM_TRIPLE --gcc-toolchain=$TOOLCHAIN --sysroot=$SYSROOT -Wl,-soname=$SONAME"

echo "Building Go library for $GOARCH (Android $ARCH)..."
echo "Output: $OUTPUT_DIR/$SONAME"
echo "CC: $CC"
echo "GOROOT: $GOROOT"
echo "GOARCH: $GOARCH"
echo "Go version: $(go version)"

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Build Go library with CGO enabled for Android
# Note: Go compiler can produce ARM binaries even when running on x86_64
go build -o "$OUTPUT_DIR/$SONAME" -buildmode=c-shared .

echo "Done!"
ls -la "$OUTPUT_DIR/$SONAME" 2>/dev/null || echo "Build failed - file not found"
