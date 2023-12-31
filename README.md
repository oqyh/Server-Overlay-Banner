# [ANY] Server Overlay Banner (1.0.0)
https://forums.alliedmods.net/showthread.php?p=2806823

### Toggle On/Off Server Banner with flags or vip list (...more)

![banner](https://github.com/oqyh/Server-Overlay-Banner/assets/48490385/1dc63c23-25f9-4ea2-a302-ca93270986df)


## .:[ ConVars ]:.
```
// enable overlay plugin?
// 1= yes
// 0= no
ov_enable_plugin "1"

// Path to the start Overlay DONT TYPE .vmt or .vft
ov_overlay_path "overlay/goldkingzbanner"

// show overlay to?
// 2= alive players only and exclude died/spectators
// 1= died/spectators only
// 0= all alive + dead/spectators
ov_show_overlay "0"

//==========================================================================================

// make banner togglable?
// 3= yes ( specific steamids ov_steamid_list_path ) need restart server
// 2= yes ( specific flags ov_flags )
// 1= yes ( everyone can toggle on/off )
// 0= no (disable toggle on/off )
ov_enable_toggle "0"

// [if ov_enable_toggle 2] which flags is it
ov_flags "abcdefghijklmnoz"

// [if ov_enable_toggle 3] where is list steamid located in addons/sourcemod/
ov_steamid_list_path "configs/viplist.txt"

//==========================================================================================

// [if ov_enable_toggle 0 or 1 or 2] which commands would you like to make it  toggle on/off hide banner (need restart server)
ov_cmd "sm_hidebanner;sm_bannerhide;sm_banner"
```

## .:[ Tutorial ]:.


[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/cV-qOZvUrhI/0.jpg)](https://www.youtube.com/watch?v=cV-qOZvUrhI)


1- Make sure you have [template](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/template%20.png) or just go to any game and screen shot ***3840x2160*** resolution.

2- Open photoshop/any edit program with transparent background ***3840x2160***.

![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/projectres.png)

3- Now import template and let it guide you where to locate banner at screen.
![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/lineup.png)

4- After you done make sure you delete/hide template and save files as PNG.

![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/lineup2.png)

![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/lineup3.png)

5- Download [VTFEdit](https://github.com/NeilJed/VTFLib) and use x86 or x64 depend on your pc.
```
6- Before you do anything you must enable "View"->"Mask" To see the result of transparency in real time after importing PNG (green or black or white) transparency means not good image transparent.
7- Also Disable "Options"->"Auto Create VMT File" To disable auto create VMT will will do it manually.
```
8- After That "File"->""Import" with following settings

![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/VTFEdit-1.png)

![alt text](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/VTFEdit-2.png)

```
9- Play with PNGs and see which number is ended/layers do you like to add if you want animated later in .VMT file at "animatedTextureFrameRate".
10- Then "File"->"Save As..." and name the file + locate where you want to put VTF path then save it and remember the path + file name.
11- After that "Tools"->"Create VMT File"->"Textures" press on browser of "Base Texture 1" and locate VTF + we make sure path not included csgo/materials.
12- Then "Tools"->"Create VMT File"->"Options" make sure "Shader > UnlitGeneric" + Tick/Enable on Translucent then press on "Create".
13- You will have now 2 files .VTF and .VMT at same path.
```

14- Now if you want animated open .VMT and add [These Lines](https://github.com/oqyh/Server-Overlay-Banner/blob/main/img/Animated%20VTF.txt) under "$translucent" 1 and edit "animatedTextureFrameRate" "X" For how many frames.

15- Uploaded it both server and FASTDL and make sure edit "Server-Overlay-Banner.cfg > ov_overlay_path" add path and file name without .VTF or .VMT at end.


## .:[ Change Log ]:.
```
(1.0.0)
- Initial Release
```

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
