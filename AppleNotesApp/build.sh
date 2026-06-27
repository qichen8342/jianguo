#!/bin/bash
set -e

APP_NAME="苹果笔记"
BUNDLE_NAME="${APP_NAME}.app"
EXECUTABLE="AppleNotesApp"

echo "▶ 正在编译..."
swift build -c release

echo "▶ 正在打包 .app..."
rm -rf "${BUNDLE_NAME}"
mkdir -p "${BUNDLE_NAME}/Contents/MacOS"
mkdir -p "${BUNDLE_NAME}/Contents/Resources"

cp ".build/release/${EXECUTABLE}" "${BUNDLE_NAME}/Contents/MacOS/${EXECUTABLE}"
cp "Sources/AppleNotesApp/Info.plist" "${BUNDLE_NAME}/Contents/Info.plist"

echo "▶ 完成！"
echo "   ${BUNDLE_NAME} 已生成，双击即可运行。"

# 可选：直接打开
# open "${BUNDLE_NAME}"
