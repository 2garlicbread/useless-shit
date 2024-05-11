-- SERVICES

local Players = game:GetService("Players")

-- TYPES

export type PlayerData = {
	[string]: any
}

export type PlayerDataManager = {
	PlayerData: {[number]: PlayerData},
	
	_CreatePlayerData: (player: Player) -> (PlayerData),
	_DeletePlayerData: (player: Player) -> (),
	
	GetPlayerData: (player: Player) -> (PlayerData?),
	GetPlayerDataKV: (player: Player, key: string) -> (any),
	SetPlayerDataKV: (player: Player, key: string, value: any) -> ()
}

-- VARIABLES

local PlayerDataManager = {
	PlayerData = {}
} :: PlayerDataManager

-- FUNCTIONS

PlayerDataManager._CreatePlayerData = function(player: Player): PlayerData
	local playerData = {}
	PlayerDataManager.PlayerData[player.UserId] = playerData
	return playerData
end

PlayerDataManager._DeletePlayerData = function(player: Player): ()
	local data = PlayerDataManager.GetPlayerData(player)
	if not data then return end

	table.clear(data)
	PlayerDataManager.PlayerData[player.UserId] = nil
end

function PlayerDataManager.GetPlayerData(player: Player): PlayerData
	return PlayerDataManager.PlayerData[player.UserId]
end

function PlayerDataManager.GetPlayerDataKV(player: Player, key: string): any
	return PlayerDataManager.PlayerData[player.UserId][key]
end

function PlayerDataManager.SetPlayerDataKV(player: Player, key: string, value: any): ()
	local playerData = PlayerDataManager.GetPlayerData(player)
	if not playerData then return end
	playerData[key] = value
end


-- MAIN

Players.PlayerAdded:Connect(PlayerDataManager._CreatePlayerData)
Players.PlayerRemoving:Connect(PlayerDataManager._DeletePlayerData)

return PlayerDataManager
