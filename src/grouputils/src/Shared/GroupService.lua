---
-- @module GroupUtils
-- @author Quenty

local require = require(script.Parent.loader).load(script)

local Players = game:GetService("Players")


--- Syncronizes time
-- @module TimeSyncService

local require = require(script.Parent.loader).load(script)

local RunService = game:GetService("RunService")
local Maid = require("Maid")
local GetRemoteFunction = require("GetRemoteFunction")
local RemoteFunctionUtils = require("RemoteFunctionUtils")
local Promise = require("Promise")
local PromiseGetRemoteFunction = require("PromiseGetRemoteFunction")
local PromiseUtils = require("PromiseUtils")

local GroupServceUtils = require("GroupServceUtils")
local GroupConstants = require("GroupConstants")

local GroupService = {}

function GroupService:Init()
    self._maid = Maid.new()
    self._cache = {}
    self._maid.cache = self._cache
    if RunService:IsServer() then
        local REMOTE_IS_IN_GROUP =  GetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_IS_IN_GROUP)
        REMOTE_IS_IN_GROUP.InvokeServer = function(...)
            self:_handleRemoteFunctionIsInGroup()
        end
        local REMOTE_GET_RANK_IN_GROUP = GetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_GET_RANK_IN_GROUP)
        REMOTE_GET_RANK_IN_GROUP.InvokeServer = function(...)
            self:_handleRemoteFunctionGetRankInGroup()
        end
        local REMOTE_GET_ROLE_IN_GROUP = GetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_GET_ROLE_IN_GROUP)
        REMOTE_GET_ROLE_IN_GROUP.InvokeServer = function(...)
            self:_handleRemoteFunctionGetRoleInGroup()
        end
    end
end
function GroupService:Start()
    self._maid:GiveTask(Players.PlayerRemoving:Connect(function(player)
		self:_handlePlayerRemoving(player)
	end))
end
function GroupService:_handlePlayerRemoving(player)
	self._maid[player] = nil
end

function GroupService:_handleRemoteFunctionIsInGroup(player,groupId, cache)
    if cache ~= false then
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRoleInGroup ~= nil and self._cache[player.UserId].GetRoleInGroupp[groupId] ~= nil then
            return self._cache[player.UserId].GetRoleInGroupp[groupId]
        end
    end
    while GroupConstants.REMOTE_FUNCTION_RETRY_VALUE > 0 do
        local role
        local ok: boolean , err = pcall(function()
            role = GroupServceUtils.GetRoleInGroupAsync(player,groupId, cache)
        end)
        if ok and type(role) == "string" then
            self._cacheFunction(player,"GetRoleInGroup",groupId,role)
            return role
        end
        retrys -= 1
    end
end

function GroupService:_handleRemoteFunctionGetRankInGroup(player,groupId, cache)
    if cache ~= false then
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRoleInGroup ~= nil and self._cache[player.UserId].GetRoleInGroupp[groupId] ~= nil then
            return self._cache[player.UserId].GetRoleInGroupp[groupId]
        end
    end
    while GroupConstants.REMOTE_FUNCTION_RETRY_VALUE > 0 do
        local rank
        local ok: boolean , err = pcall(function()
            rank = GroupServceUtils.GetRankInGroupAsync(player,groupId)
        end)
        if ok and type(rank) == "number" then
            self._cacheFunction(player,"GetRankInGroup",groupId,rank)
            return rank
        end
        retrys -= 1
    end
end

function GroupService:_handleRemoteFunctionGetRoleInGroup(player,groupId, cache)
    if cache ~= false then
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRoleInGroup ~= nil and self._cache[player.UserId].GetRoleInGroupp[groupId] ~= nil then
            return self._cache[player.UserId].GetRoleInGroupp[groupId]
        end
    end
    while GroupConstants.REMOTE_FUNCTION_RETRY_VALUE > 0 do
        local isInGroup
        local ok: boolean , err = pcall(function()
            isInGroup = GroupServceUtils.IsInGroupAsync(player,groupId)
        end)
        if ok and type(isInGroup) == "boolean" then
            self._cacheFunction(player,"IsInGroup",groupId,isInGroup)
            return isInGroup
        end
        retrys -= 1
    end
end

function GroupService:_cacheFunction(player: Player,utilUsed: string,groupId:number,value: any)
    if self._cache[player] ==  nil then
        self._cache[player] = {}
        self._maid[player] = self._cache[player]
    end
    if self._cache[player][utilUsed] ==  nil then
        self._cache[player][utilUsed] = {}
    end
    if self._cache[player][utilUsed][groupId] ==  nil then
        self._cache[player][utilUsed][groupId] = value
    end
end

function GroupService:GetRoleInGroup(player: Player, groupId: number,cache: boolean?, retrys: number? ): string?
    if cache ~= false then
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRoleInGroup ~= nil and self._cache[player.UserId].GetRoleInGroupp[groupId] ~= nil then
            return self._cache[player.UserId].GetRoleInGroupp[groupId]
        end
    end
	if retrys == nil then
		retrys = 3
	end
	assert(type(retrys) == "number")
    while retrys > 0 do
        local role
        local ok: boolean , err = pcall(function()
            role = GroupServceUtils.GetRoleInGroupAsync(player,groupId)
        end)
        if ok and type(role) == "string" then
            self._cacheFunction(player,"GetRoleInGroup",groupId,role)
            return role
        end
        retrys -= 1
    end
    if RunService:IsClient() and game:GetService("ReplicatedStorage"):FindFirstChild("GetRoleInGroup") then

        local remote: RemoteFunction = game.ReplicatedStorage.GetRoleInGroup
        local data= remote:InvokeServer(groupId,cache, retrys)
        self._cacheFunction(player,"GetRoleInGroup",groupId,data)
        return data
	end
    return nil
end
function GroupService:promiseRoleInGroupWithCache(player, groupId)
    return Promise.spawn(function(resolve, reject)
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRoleInGroup ~= nil and self._cache[player.UserId].GetRoleInGroup[groupId] ~= nil then
            return resolve(self._cache[player.UserId].GetRoleInGroupp[groupId])
        end
        return GroupService.promiseRoleInGroupWithRetryAndFallback(player, groupId):Then(function(role)
            self:_cacheFunction(player,"GetRoleInGroup",groupId,role)
            return Promise.resolved(role)
        end)
    end)
end
function GroupService:promiseRankInGroupWithCache(player, groupId)
    return Promise.spawn(function(resolve, reject)
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetRankInGroup ~= nil and self._cache[player.UserId].GetRankInGroup[groupId] ~= nil then
            return resolve(self._cache[player.UserId].GetRankInGroup[groupId])
        end
        return GroupService.promiseRoleInGroupWithRetryAndFallback(player, groupId):Then(function(role)
            self:_cacheFunction(player,"GetRankInGroup",groupId,role)
            return Promise.resolved(role)
        end)
    end)
end
function GroupService:promiseIsInGroupWithCache(player, groupId)
    return Promise.spawn(function(resolve, reject)
        if self._cache[player.UserId] ~= nil and self._cache[player.UserId].GetIsInGroup ~= nil and self._cache[player.UserId].GetIsInGroup[groupId] ~= nil then
            return resolve(self._cache[player.UserId].GetIsInGroup[groupId])
        end
        return GroupService.promiseRoleInGroupWithRetryAndFallback(player, groupId):Then(function(role)
            self:_cacheFunction(player,"GetIsInGroup",groupId,role)
            return Promise.resolved(role)
        end)
    end)
end
if not RunService:IsClient() then
    -- Handle testing
    function GroupService:promiseRoleInGroupWithRetryAndFallback(player,retrys, groupId)
        return PromiseUtils.retry(GroupService.promiseRoleInGroupWithCache,retrys,0,player,self,groupId)
    end
    function GroupService:promiseRankInGroupWithRetryAndFallback(player,retrys, groupId)
        return PromiseUtils.retry(GroupServceUtils.promiseRankInGroupWithCache,retrys,0,player,self,groupId)
    end
    function GroupService:promiseIsInGroupWithRetryAndFallback(player,retrys, groupId)
        return PromiseUtils.retry(GroupServceUtils.promiseIsInGroupWithCache,retrys,0,player,self,groupId)
    end
else -- RunService:IsClient()
    function GroupService:promiseRoleInGroupWithRetryAndFallback(player,retrys, groupId)
        return Promise.spawn(function(resolve, reject)
            return PromiseUtils.retry(GroupServceUtils.promiseRoleInGroup,retrys,0,player,groupId)
            :Catch(function()
                return PromiseGetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_GET_ROLE_IN_GROUP)
                :Then(function(remote)
                    return RemoteFunctionUtils.promiseInvokeServer(remote,retrys,self,groupId)
                end)
            end)
        end)
    end
    function GroupService:promiseRankInGroupWithRetryAndFallback(player,retrys, groupId)
        return Promise.spawn(function(resolve, reject)
            return PromiseUtils.retry(GroupServceUtils.promiseRankInGroup,retrys,0,player,groupId)
            :Catch(function()
                return PromiseGetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_GET_RANK_IN_GROUP)
                :Then(function(remote)
                    return RemoteFunctionUtils.promiseInvokeServer(remote,retrys,self,groupId)
                end)
            end)
        end)
    end
    function GroupService:promiseIsInGroupWithRetryAndFallback(player,retrys, groupId)
        return Promise.spawn(function(resolve, reject)
            return PromiseUtils.retry(GroupServceUtils.promiseIsInGroup,retrys,0,player,groupId)
            :Catch(function()
                return PromiseGetRemoteFunction(GroupConstants.REMOTE_FUNCTION_NAME_IS_IN_GROUP)
                :Then(function(remote)
                    return RemoteFunctionUtils.promiseInvokeServer(remote,retrys,self,groupId)
                end)
            end)
        end)
    end
end

return GroupService