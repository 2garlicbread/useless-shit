-- SERVICES

local DataStoreService = game:GetService("DataStoreService")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

-- MODULES

local PlayerData = require(ServerStorage.GameServer.Dependencies.PlayerData)
local Leaderstats = require(ServerStorage.GameServer.Dependencies.Leaderstats)
local GameSettings = require(ServerStorage.GameServer.GameSettings)

local DatastoreUtil = require(script.DatastoreUtil)
local DatastoreSettings = require(script.DatastoreSettings)

-- CONSTANTS

-- TYPES

export type Datastorer = {
	StoreAssets: () -> (boolean);
	StorePlayersAssets: (player: Player) -> (boolean?);
	StoreData: (datastore: string, key: string, data: string) -> (boolean);
	StoreDataRetry: (datastore: string, key: string, data: string) -> (boolean);
	
	RetrievePlayersAssets: (player: Player) -> (number?, number?);
	RetrieveData: (datastore: string, key: string) -> (string?);
	RetrieveDataRetry: (datastore: string, key: string) -> (string?);
	
	DatastoreUtil: typeof(DatastoreUtil),
	DatastoreSettings: typeof(DatastoreSettings)
}

-- VARIABLES

local Datastorer = {} :: Datastorer
	

-- FUNCTIONS

function Datastorer.StorePlayersAssets(player: Player): boolean?
	local currency = Leaderstats.GetLeaderstat(player, GameSettings.CURRENCY_NAME)
	local junk = Leaderstats.GetLeaderstat(player, GameSettings.JUNK_NAME)
	
	if not junk then return end
	if not currency then return end
	
	local encodedString = DatastoreUtil.EncodeAssets(currency.Value, junk.Value)
	if not encodedString then return end

	return Datastorer.StoreDataRetry(DatastoreSettings.ASSETS_DATASTORE, `{player.UserId}_MASTER`, encodedString)
end

function Datastorer.StoreData(datastore: string, key: string, data: string): boolean
	if typeof(datastore) ~= "string" then return false end
	if typeof(key) ~= "string" then return false end
	if typeof(data) ~= "string" then return false end
	
	local datastore = DataStoreService:GetDataStore(datastore)
	
	local success, err = pcall(datastore.SetAsync, datastore, key, data)
	if not success then
		warn(err)
		return false
	end
	
	return true
end

function Datastorer.StoreDataRetry(datastore: string, key: string, data: string): boolean
	local success = false
	
	for i = 1, DatastoreSettings.RETRIES do
		success = Datastorer.StoreData(datastore, key, data)
		if success then 
			break
		end
	end
	
	return success
end

function Datastorer.StoreAssets(): (boolean?)
	local success = false
	
	for _, player in Players:GetPlayers() do
		local storeSuccess = Datastorer.StorePlayersAssets(player)
		if storeSuccess then
			success = true
		end
	end
	
	return success
end

function Datastorer.RetrievePlayersAssets(player: Player): (number?, number?)
	local data = Datastorer.RetrieveDataRetry(DatastoreSettings.ASSETS_DATASTORE, `{player.UserId}_MASTER`)
	if not data then
		return 0, 0
	end
	
	return DatastoreUtil.DecodeAssets(data)
end

function Datastorer.RetrieveData(datastore: string, key: string): (string?)
	local datastore = DataStoreService:GetDataStore(datastore)
	
	local success, data = pcall(datastore.GetAsync, datastore, key)
	if not success then
		warn(data)
		return nil
	end
	
	return data
end

function Datastorer.RetrieveDataRetry(datastore: string, key: string): (string?)
	local finalData = nil
	
	for i = 1, DatastoreSettings.RETRIES do
		local data = Datastorer.RetrieveData(datastore, key)
		if data then
			finalData = data
			break
		end
	end
	
	return finalData
end

-- MAIN 

Datastorer.DatastoreUtil = DatastoreUtil
Datastorer.DatastoreSettings = DatastoreSettings 

return Datastorer
