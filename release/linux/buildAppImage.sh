#!/bin/bash

path=$(dirname $(realpath $0))
cd $path
loveAppImage="https://github.com/love2d/love/releases/download/11.4/love-11.4-x86_64.AppImage"
loveFileName=$(basename $loveAppImage)
gameName="taiko-bird"
appImageTool="https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"
appImageFileName=$(basename $appImageTool)
iconPath="https://raw.githubusercontent.com/aureki/taiko-bird/master/assets/taikobird.png"
iconFileName=$(basename $iconPath)

function zipGame() {
	# zip is bugged using ".." idk
	cd ../../ && zip -9 -r $path/$gameName.love src/ libraries/ assets/ *.lua CREDITS.md LICENSE.md && cd $path
	chmod +x $gameName.love
}

function downloadLoveAppImage() {
	if [ ! -f "$loveFileName" ]; then
		wget $loveAppImage
	fi
}

function setLoveAppImageExecuteFlag() {
	chmod +x $loveFileName
}

function runLoveAppImage() {
	if [ ! -f "squashfs-root" ]; then
		./$loveFileName --appimage-extract
	fi
}

function fuseGame() {
	cat squashfs-root/bin/love $gameName.love > squashfs-root/bin/$gameName
}

function setGameExecuteFlag() {
	chmod +x squashfs-root/bin/$gameName
}

function downloadAppImageTool() {
	if [ ! -f "$appImageFileName" ]; then
		wget $appImageTool
	fi
}

function setAppImageExecuteFlag() {
	chmod +x $appImageFileName
}

function modifyDesktopDescription() {
	sed -i "s/love/$gameName/g" squashfs-root/love.desktop
}

function getGameIcon() {
	if [ ! -f "squashfs-root/$gameName.png" ]; then
		wget $iconPath
		mv $iconFileName squashfs-root/$gameName.png
	fi
}

function repackageGame() {
	./$appImageFileName squashfs-root $gameName.AppImage
}

function createLoveAppImage() {
	downloadLoveAppImage
	setLoveAppImageExecuteFlag
	runLoveAppImage
	fuseGame
	setGameExecuteFlag
}

function repackageToAppImage() {
	downloadAppImageTool
	setAppImageExecuteFlag
	modifyDesktopDescription
	getGameIcon
	repackageGame
}

function main() {
	zipGame
	createLoveAppImage
	repackageToAppImage
}

main
