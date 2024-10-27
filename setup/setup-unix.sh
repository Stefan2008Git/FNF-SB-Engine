#!/bin/sh
# SETUP FOR MAC AND LINUX SYSTEMS!!!
# REMINDER THAT YOU NEED HAXE INSTALLED PRIOR TO USING THIS
# https://haxe.org/download/
cd ..
echo Welcome $USER to "FNF': SB Engine" lib setup by using this script for Linux/MacOS targets. Please relax and sit when this shell script will do everything for you without doing everything manually..
sleep 5

echo Making the main and setuping haxelib folder in same time..
mkdir ~/haxelib && haxelib setup ~/haxelib
sleep 3
echo Done!

sleep 1
echo Installing dependencies...

sleep 1
echo This might take a few moments depending on your internet speed.

sleep 3
echo Installing Hxcpp package...
haxelib git hxcpp https://github.com/mcagabe19-stuff/hxcpp --quiet

sleep 3
echo Installing Lime package and seting version to 8.0.2...
haxelib install lime 8.0.2 --quiet
haxelib set lime 8.0.2

sleep 3
echo Setuping lime command...
haxelib run lime setup

sleep 3
echo Installing OpenFL package...
haxelib install openfl --quiet

sleep 3
echo Installing HaxeFlixel package...
haxelib install flixel --quiet

sleep 3
echo Installing Flixel-addons package...
haxelib install flixel-addons --quiet

sleep 3
echo Installing Flixel-tools package...
haxelib install flixel-tools --quiet

sleep 3
echo Installing HScript-Iris package and seting version to 1.1.0...
haxelib install hscript-iris 1.1.0 -quiet

sleep 3
echo Installing TJson package...
haxelib install tjson --quiet

sleep 3
echo Installing FlxAnimate package...
haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate 768740a56b26aa0c072720e0d1236b94afe68e3e --quiet

sleep 3
echo Installing Linc_Luajit package..
haxelib git linc_luajit https://github.com/superpowers04/linc_luajit 1906c4a96f6bb6df66562b3f24c62f4c5bba14a7 --quiet

sleep 3
echo Installing HxDiscord_RPC package...
haxelib git hxdiscord_rpc https://github.com/MAJigsaw77/hxdiscord_rpc e2e60371cc9e705417533a9421feacb91fa25113 --quiet --skip-dependencies

sleep 3
echo Installing HxVLC package...
haxelib git hxvlc https://github.com/MAJigsaw77/hxvlc 70e7f5f3e76d526ac6fb8f0e6665efe7dfda589d --quiet --skip-dependencies

sleep 3
echo Installing Funkin.Vis package...
haxelib git funkin.vis https://github.com/FunkinCrew/funkVis d5361037efa3a02c4ab20b5bd14ca11e7d00f519 --quiet --skip-dependencies

sleep 3
echo Installing last package "(Grig.Audio)"...
haxelib git grig.audio https://gitlab.com/haxe-grig/grig.audio.git cbf91e2180fd2e374924fe74844086aab7891666 --quiet

sleep 2
echo Finished! Generating all important Haxelib packages on list...

sleep 3
haxelib list
echo Done!
