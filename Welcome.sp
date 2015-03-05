#pragma semicolon 1

#include <sourcemod>
#include <colors>

public Plugin myinfo =
{
	name = "Welcome",
	author = "Hunter S. Thompson | Modified by Shadow_Man",
	description = "Displays a welcome message when the user joins.",
	version = "1.0.0.0",
	url = "http://forums.alliedmods.net/showthread.php?t=187975"
};

Handle sm_Join_Message = null;
char Message[128];

public void OnPluginStart()
{
	sm_Join_Message = CreateConVar("sm_join_message", "Welcome {name}[{steamid}], to Conflagration Deathrun!", "Default Join Message", FCVAR_NOTIFY);
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
		GetConVarString(sm_Join_Message, Message, sizeof(Message));
		char Name[128];
		char SteamID[128];
		char IP[128];
		char Count[128];
		GetClientName(client, Name, sizeof(Name));
		GetClientAuthString(client, SteamID, sizeof(SteamID));
		GetClientIP(client, IP, sizeof(IP));
		ReplaceString(Message, sizeof(Message), "{name}", Name, false);
		ReplaceString(Message, sizeof(Message), "{steamid}", SteamID, false);
		ReplaceString(Message, sizeof(Message), "{ip}", IP, false);
		CPrintToChat(client, Message, client);
	}
}
