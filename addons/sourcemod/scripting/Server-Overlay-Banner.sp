#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>
#include <clientprefs>
#include <multicolors>

#define SZF(%0) 			%0, sizeof(%0)
#define PLUGIN_VERSION    "1.0.0"

ConVar
	gc_sOverlayStartPath,
	g_CVAR_Toggle_CMD,
	g_SteamIDPath,
	g_overlayshow,
	g_hFlags,
	g_enable,
	g_Etoggles;

bool
	PlayerIsSpecial[MAXPLAYERS+1],
	DisableBanner[MAXPLAYERS+1],
	onetime[MAXPLAYERS+1],
	g_benable = false,
	RefreshBanner;

Handle 
	Arr_SteamIDs = INVALID_HANDLE,
	g_Timer[MAXPLAYERS+1],
	g_OvCookie;

int 
	g_boverlayshow = 0,
	g_btoggles = 0;

char g_sOverlayStartPath[256];

public Plugin myinfo =
{
	name = "[ANY] Graphic Banner Overlay",
	author = "Gold KingZ ",
	description = "Custom Overlay VTF Material",
	version = PLUGIN_VERSION,
	url = "https://github.com/oqyh"
}

public void OnPluginStart()
{
	LoadTranslations( "Server_Overlay_Banner.phrases" );
	
	CreateConVar("ov_version", PLUGIN_VERSION, "[ANY] Graphic Banner Overlay Plugin Version", FCVAR_NOTIFY|FCVAR_DONTRECORD);

	g_enable = CreateConVar("ov_enable_plugin", "1", "enable overlay plugin?\n1= yes\n0= no", _, true, 0.0, true, 1.0);
	g_overlayshow = CreateConVar("ov_show_overlay", "0", "show overlay to?\n2= alive players only and exclude died/spectators\n1= died/spectators only\n0= all alive + dead/spectators", _, true, 0.0, true, 2.0);
	g_Etoggles = CreateConVar("ov_enable_toggle"		     , "0", "make banner togglable?\n3= yes ( specific steamids ov_steamid_list_path ) need restart server\n2= yes ( specific flags ov_flags )\n1= yes ( everyone can toggle on/off )\n0= no (disable toggle on/off )", _, true, 0.0, true, 3.0);
	g_hFlags = CreateConVar("ov_flags",	"abcdefghijklmnoz",	"[if ov_enable_toggle 2] which flags is it");
	g_SteamIDPath = CreateConVar("ov_steamid_list_path", "configs/viplist.txt", "[if ov_enable_toggle 3] where is list steamid located in addons/sourcemod/");
	gc_sOverlayStartPath = CreateConVar("ov_overlay_path", "overlay/goldkingzbanner", "Path to the start Overlay DONT TYPE .vmt or .vft");
	g_CVAR_Toggle_CMD = CreateConVar("ov_cmd", "sm_hidebanner;sm_bannerhide;sm_banner", "[if ov_enable_toggle 1 or 2 or 3] which commands would you like to make it  toggle on/off hide banner (need restart server)");
	UTIL_LoadToggleCmd(g_CVAR_Toggle_CMD, Command_Banner);
	gc_sOverlayStartPath.GetString(g_sOverlayStartPath, sizeof(g_sOverlayStartPath));
	
	g_OvCookie = RegClientCookie("ov_toggle_banner", "Hide Server Banner", CookieAccess_Protected);

	HookConVarChange(g_enable, OnSettingsChanged);
	HookConVarChange(g_Etoggles, OnSettingsChanged);
	HookConVarChange(g_overlayshow, OnSettingsChanged);
	HookConVarChange(gc_sOverlayStartPath, OnSettingChanged);
	AutoExecConfig(true, "Server-Overlay-Banner");
	
	LoadSteamIDList();
}


public void OnMapStart()
{
	if (g_benable)
	{
		PrecacheFiles(g_sOverlayStartPath);
	}
}

public void OnClientPostAdminCheck(int client)
{
	char auth[32];

	GetClientAuthId(client, AuthId_Steam2, auth, sizeof(auth));

	if (FindStringInArray(Arr_SteamIDs, auth) != -1)
	{
		PlayerIsSpecial[client] = true;
	}
	else
	{
		PlayerIsSpecial[client] = false;
	}
}

public void OnClientPutInServer(int client)
{
	RefreshBanner = true;
	g_Timer[client] = CreateTimer(1.0, Timer_Banner, client, TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE);
}

public void OnClientDisconnect(int client)
{
	DisableBanner[client] = false;
	onetime[client] = false;
	PlayerIsSpecial[client] = false;
	
	if (g_Timer[client] != INVALID_HANDLE)
	{
		KillTimer(g_Timer[client]);
		g_Timer[client] = INVALID_HANDLE;
	}
}

public void OnClientCookiesCached(int client)
{
	char sCookie[8];
	GetClientCookie(client,g_OvCookie, sCookie, sizeof(sCookie));
	DisableBanner[client] = view_as<bool>(StringToInt(sCookie));
}

public void OnConfigsExecuted()
{
	g_benable = GetConVarBool(g_enable);
	g_btoggles = GetConVarInt(g_Etoggles);
	g_boverlayshow = GetConVarInt(g_overlayshow);
	
	gc_sOverlayStartPath.GetString(g_sOverlayStartPath, sizeof(g_sOverlayStartPath));
}

public int OnSettingsChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	
	if(convar == g_enable)
	{
		RefreshBanner = true;
		g_benable = g_enable.BoolValue;
	}
	
	if(convar == g_Etoggles)
	{
		RefreshBanner = true;
		g_btoggles = g_Etoggles.IntValue;
	}
	
	if(convar == g_overlayshow)
	{
		RefreshBanner = true;
		g_boverlayshow = g_overlayshow.IntValue;
	}
	return 0;
}

public Action Timer_Banner(Handle timer, any client)
{
	if(!g_benable || g_btoggles == 0 && onetime[client] == true && IsPlayerValid(client))
	{
		ClientCommand(client, "r_screenoverlay 0");
		onetime[client] = false;
	}
	
	if(!g_benable || !IsPlayerValid(client)) return Plugin_Continue;
	
	if(g_btoggles == 0 && DisableBanner[client] == true)
	{
		DisableBanner[client] = false;
		onetime[client] = false;
	}
	
	char zFlags[32];
	GetConVarString(g_hFlags, zFlags, sizeof(zFlags));
	
	if(RefreshBanner == true)
	{
		onetime[client] = false;
	}
	
	if(g_boverlayshow == 1 && IsPlayerAlive(client) || g_boverlayshow == 2 && GetClientTeam(client) == 1)
	{
		ClientCommand(client, "r_screenoverlay 0");
		onetime[client] = false;
	}
	
	if(g_btoggles == 2 || g_btoggles == 3 && DisableBanner[client] == true && !CheckAdminFlagsByString(client, zFlags) || PlayerIsSpecial[client] == false)
	{
		if(g_btoggles == 1)return Plugin_Continue;
		
		DisableBanner[client] = false;
		onetime[client] = false;
	}
	
	if(DisableBanner[client] || onetime[client]) return Plugin_Continue;
	
	if(g_boverlayshow == 1 && IsPlayerAlive(client) || g_boverlayshow == 2 && GetClientTeam(client) == 1) return Plugin_Continue;
	
	ClientCommand(client, "r_screenoverlay %s", g_sOverlayStartPath);
	onetime[client] = true;
	
	return Plugin_Continue;
}

public Action Command_Banner(int client, int args)
{
	if(!g_benable || g_btoggles == 0) return Plugin_Continue;
	
	if (client == 0)
	{
		CReplyToCommand(client, "This command is only available in game.");
		return Plugin_Handled;
    }
	
	if(g_btoggles == 1)
	{
		if(IsPlayerValid(client))
		{
			DisableBanner[client] = !DisableBanner[client];
			
			char sCookie[8];
			IntToString(DisableBanner[client], sCookie, sizeof(sCookie));
			SetClientCookie(client, g_OvCookie, sCookie);
			
			if(DisableBanner[client])
			{
				ClientCommand(client, "r_screenoverlay 0");
				CReplyToCommand(client, " %t", "BannerOff");
			}
			else
			{
				onetime[client] = false;
				CReplyToCommand(client, " %t", "BannerOn");
			}
			return Plugin_Handled;
		}
	}else if(g_btoggles == 2)
	{
		char zFlags[32];
		GetConVarString(g_hFlags, zFlags, sizeof(zFlags));
		if(!CheckAdminFlagsByString(client, zFlags))
		{
			CReplyToCommand(client, " %t", "FlagVIP");
			return Plugin_Handled;
		}
		
		if(CheckAdminFlagsByString(client, zFlags))
		{
			if(IsPlayerValid(client))
			{
				DisableBanner[client] = !DisableBanner[client];
				
				char sCookie[8];
				IntToString(DisableBanner[client], sCookie, sizeof(sCookie));
				SetClientCookie(client, g_OvCookie, sCookie);
				
				if(DisableBanner[client])
				{
					ClientCommand(client, "r_screenoverlay 0");
					CReplyToCommand(client, " %t", "BannerOff");
				}
				else
				{
					onetime[client] = false;
					CReplyToCommand(client, " %t", "BannerOn");
				}
				return Plugin_Handled;
			}
		}
	}else if(g_btoggles == 3)
	{
		char zFlags[32];
		GetConVarString(g_hFlags, zFlags, sizeof(zFlags));
		if(!PlayerIsSpecial[client])
		{
			CReplyToCommand(client, " %t", "SpecialPlayer");
			return Plugin_Handled;
		}
		
		if(PlayerIsSpecial[client])
		{
			if(IsPlayerValid(client))
			{
				DisableBanner[client] = !DisableBanner[client];
				
				char sCookie[8];
				IntToString(DisableBanner[client], sCookie, sizeof(sCookie));
				SetClientCookie(client, g_OvCookie, sCookie);
				
				if(DisableBanner[client])
				{
					ClientCommand(client, "r_screenoverlay 0");
					CReplyToCommand(client, " %t", "BannerOff");
				}
				else
				{
					onetime[client] = false;
					CReplyToCommand(client, " %t", "BannerOn");
				}
				return Plugin_Handled;
			}
		}
	}
	
	return Plugin_Continue;
}

void LoadSteamIDList()
{
	char[] path = new char[PLATFORM_MAX_PATH];
	char szBuffer[PLATFORM_MAX_PATH];
	g_SteamIDPath.GetString(szBuffer, sizeof(szBuffer));
	BuildPath(Path_SM, path, PLATFORM_MAX_PATH, "%s", szBuffer);

	Handle fSteamIDList = OpenFile(path, "rt");

	if (fSteamIDList == INVALID_HANDLE)
	{
		SetFailState("Unable to load file: %s", path);
	}

	Arr_SteamIDs = CreateArray(256);

	char auth[256];

	while (!IsEndOfFile(fSteamIDList) && ReadFileLine(fSteamIDList, auth, sizeof(auth)))
	{
		ReplaceString(auth, sizeof(auth), "\r", "");
		ReplaceString(auth, sizeof(auth), "\n", "");

		PushArrayString(Arr_SteamIDs, auth);
	}

	CloseHandle(fSteamIDList);
} 

void UTIL_LoadToggleCmd(ConVar &hCvar, ConCmd Call_CMD)
{
	char szPart[64], szBuffer[128];
	int reloc_idx, iPos;
	hCvar.GetString(SZF(szBuffer));
	reloc_idx = 0;
	while ((iPos = SplitString(szBuffer[reloc_idx], ";", SZF(szPart))))
	{
		if (iPos == -1)
		{
			strcopy(SZF(szPart), szBuffer[reloc_idx]);
		}
		else
		{
			reloc_idx += iPos;
		}
		
		TrimString(szPart);
		
		if (szPart[0])
		{
			RegConsoleCmd(szPart, Call_CMD);
			
			if (iPos == -1)
			{
				return;
			}
		}
	}
}

stock bool CheckAdminFlagsByString(int client, const char[] flagString)
{
    AdminId admin = view_as<AdminId>(GetUserAdmin(client));
    if (admin != INVALID_ADMIN_ID)
    {
        int flags = ReadFlagString(flagString);
        for (int i = 0; i <= 20; i++)
        {
            if (flags & (1<<i))
            {
                if(GetAdminFlag(admin, view_as<AdminFlag>(i)))
                    return true;
              }
          }
    }
    return false;
} 

static bool IsPlayerValid( int client ) 
{
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) || IsFakeClient(client))
        return false; 
     
    return true; 
}

public void OnSettingChanged(Handle convar, const char[] oldValue, const char[] newValue)
{
	if (convar == gc_sOverlayStartPath) 
	{
		strcopy(g_sOverlayStartPath, sizeof(g_sOverlayStartPath), newValue);
		
		if (g_benable)
		{
			PrecacheFiles(g_sOverlayStartPath);
		}
	}
}

stock void PrecacheFiles(char[] path)
{
	if (strlen(path) == 0)
		return;

	char sBuffer[256];
	Format(sBuffer, sizeof(sBuffer), "%s.vmt", path);
	PrecacheDecal(sBuffer, true);
	Format(sBuffer, sizeof(sBuffer), "materials/%s.vmt", path);
	AddFileToDownloadsTable(sBuffer);

	Format(sBuffer, sizeof(sBuffer), "%s.vtf", path);
	PrecacheDecal(sBuffer, true);
	Format(sBuffer, sizeof(sBuffer), "materials/%s.vtf", path);
	AddFileToDownloadsTable(sBuffer);
}