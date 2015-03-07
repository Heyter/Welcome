#pragma semicolon 1

#include <sourcemod>
#include <morecolors>

public Plugin myinfo =
{
	name = "Welcome",
	author = "Hunter S. Thompson | Modified by Shadow_Man",
	description = "Displays a welcome message when the user joins.",
	version = "1.1",
	url = "http://forums.alliedmods.net/showthread.php?t=187975"
};

ConVar cVarJoinMessage = null;
ConVar cVarMessageTime = null;
bool showMessage[MAXPLAYERS + 1];

public void OnPluginStart()
{
	cVarJoinMessage = CreateConVar("sm_join_message", "Welcome {name}[{steamid}]!", "Default Join Message", FCVAR_NONE);
	cVarMessageTime = CreateConVar("sm_join_message_time", "4.0", "Delay for message to display.", FCVAR_NONE, true, 0.0, true, 60.0);
	HookEvent("player_activate", Player_Activated, EventHookMode_Post);

	for(int i = 0; i <= MAXPLAYERS; i++)
		showMessage[i] = true;
}

public Action Player_Activated(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(!showMessage[client])
		return Plugin_Continue;

	CreateTimer(cVarMessageTime.FloatValue, Timer_Welcome, client, TIMER_FLAG_NO_MAPCHANGE);
	showMessage[client] = false;
	return Plugin_Continue;
}

public void OnClientDisconnect(int client)
{
	showMessage[client] = true;
}

public Action Timer_Welcome(Handle timer, any client)
{
	if(!IsClientConnected(client) || !IsClientInGame(client))
		return Plugin_Handled;

	char message[512];
	cVarJoinMessage.GetString(message, sizeof(message));
	FormatMessage(client, message, sizeof(message));

	CPrintToChat(client, message);
	return Plugin_Handled;
}

void FormatMessage(int client, char[] msg, int length)
{
	char steamID[64];
	GetClientAuthId(client, AuthId_Engine, steamID, sizeof(steamID));
	ReplaceString(msg, length, "{steamid}", steamID, false);

	char ip[128];
	GetClientIP(client, ip, sizeof(ip));
	ReplaceString(msg, length, "{ip}", ip, false);

	char name[256];
	GetClientName(client, name, sizeof(name));
	ReplaceString(msg, length, "{name}", name, false);
}
