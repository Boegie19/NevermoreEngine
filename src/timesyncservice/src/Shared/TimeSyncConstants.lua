---
-- @module TimeSyncConstants
-- @author Quenty

local require = require(script.Parent.loader).load(script)

local Table = require("Table")

return Table.readonly({
	REMOTE_EVENT_NAME = "TimeSyncServiceRemoteEvent";
	REMOTE_FUNCTION_NAME = "TimeSyncServiceRemoteFunction";
})