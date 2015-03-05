#pragma semicolon 1

#include <sourcemod>
#include <morecolors>

public Plugin myinfo =
{
	name = "Welcome",
	author = "Hunter S. Thompson | Modified by Shadow_Man",
	description = "Displays a welcome message when the user joins.",
	version = "1.0.0.0",
	url = "http://forums.alliedmods.net/showthread.php?t=187975"
};

ConVar cVarJoinMessage = null;
char message[512];

public void OnPluginStart()
{
	cVarJoinMessage = CreateConVar("sm_join_message", "Welcome {name}[{steamid}]!", "Default Join Message", FCVAR_NOTIFY);
	AutoExecConfig(true, "onJoin");
	HookEvent("player_activate", Player_Activated, EventHookMode_Post);
}

public Action Player_Activated(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	CreateTimer(4.0, Timer_Welcome, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action Timer_Welcome(Handle timer, any client)
{
	if (IsClientConnected(client) && IsClientInGame(client))
	{
		GetConVarString(sm_Join_Message, message, sizeof(message));
		char Name[128];
		char SteamID[128];
		char IP[128];
		char Count[128];
		GetClientName(client, Name, sizeof(Name));
		GetClientAuthId(client, AuthId_Engine, SteamID, sizeof(SteamID));
		GetClientIP(client, IP, sizeof(IP));
		ReplaceString(message, sizeof(message), "{name}", Name, false);
		ReplaceString(message, sizeof(message), "{steamid}", SteamID, false);
		ReplaceString(message, sizeof(message), "{ip}", IP, false);
		CPrintToChat(client, Message, client);
	}
}
