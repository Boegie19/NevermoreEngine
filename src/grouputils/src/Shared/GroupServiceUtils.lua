---
-- @module GroupServiceUtils
-- @author Boegie19

local require = require(script.Parent.loader).load(script)

local GroupService = game:GetService("GroupService")

local Promise = require("Promise")

local GroupServiceUtils = {}


function GroupServiceUtils.GetRankInGroupAsync(Player, GroupID)
	local Groups = GroupService:GetGroupsAsync(Player)
	for Index = 1, #Groups do
		local Group = Groups[Index]
		if Group.Id == GroupID then
			return Group.Rank
		end
	end
	return 0
end

function GroupServiceUtils.GetRoleInGroupAsync(Player, GroupID)
	local Groups = GroupService:GetGroupsAsync(Player)
	for Index = 1, #Groups do
		local Group = Groups[Index]
		if Group.Id == GroupID then
			return Group.Role
		end
	end
	return "Guest"
end

function GroupServiceUtils.IsInGroupAsync(Player, GroupID)
	local Groups = GroupService:GetGroupsAsync(Player)
	for Index = 1, #Groups do
		if Groups[Index].Id == GroupID then
			return true
		end
	end
	return false
end

function GroupServiceUtils.promiseRankInGroup(player, groupId)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")
	assert(type(groupId) == "number", "Bad groupId")

	return Promise.spawn(function(resolve, reject)
		local rank = nil
		local ok, err = pcall(function()
			rank = GroupServiceUtils.GetRankInGroupAsync(player,groupId)
		end)

		if not ok then
			return reject(err)
		end

		if type(rank) ~= "number" then
			return reject("Rank is not a number")
		end

		return resolve(rank)
	end)
end

function GroupServiceUtils.promiseRoleInGroup(player, groupId)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")
	assert(type(groupId) == "number", "Bad groupId")

	return Promise.spawn(function(resolve, reject)
		local role = nil
		local ok, err = pcall(function()
			role = GroupServiceUtils.GetRoleInGroupAsync(player,groupId)
		end)

		if not ok then
			return reject(err)
		end

		if type(role) ~= "string" then
			return reject("Role is not a string")
		end

		return resolve(role)
	end)
end

function GroupServiceUtils.promiseIsInGroup(player, groupId)
	assert(typeof(player) == "Instance" and player:IsA("Player"), "Bad player")
	assert(type(groupId) == "number", "Bad groupId")

	return Promise.spawn(function(resolve, reject)
		local isInGroup = nil
		local ok, err = pcall(function()
			isInGroup = GroupServiceUtils.IsInGroupAsync(player,groupId)
		end)

		if not ok then
			return reject(err)
		end

		if type(isInGroup) ~= "boolean" then
			return reject("isInGroup is not a boolean")
		end

		return resolve(isInGroup)
	end)
end

return GroupServiceUtils