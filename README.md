# [ANY] Server Overlay Banner (1.0.0)
https://forums.alliedmods.net/showthread.php?t=342531

### Toggle On/Off Server Banner with flags or vip list (...more)

![alt text](https://github.com/oqyh/Chat-Command-Silencer/blob/main/img/ex.png?raw=true)
![alt text](https://github.com/oqyh/Chat-Command-Silencer/blob/main/img/dot.png?raw=true)
![alt text](https://github.com/oqyh/Chat-Command-Silencer/blob/main/img/slash.png?raw=true)

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
// -
// Default: "sm_hidebanner;sm_bannerhide;sm_banner"
ov_cmd "sm_hidebanner;sm_bannerhide;sm_banner"
```

## .:[ Tutorial ]:.
```
[![IMAGE ALT TEXT HERE](https://img.youtube.com/vi/cV-qOZvUrhI/0.jpg)](https://www.youtube.com/watch?v=cV-qOZvUrhI)
```

## .:[ Change Log ]:.
```
(1.0.0)
- Initial Release
```

## .:[ Donation ]:.

If this project help you reduce time to develop, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://paypal.me/oQYh)
