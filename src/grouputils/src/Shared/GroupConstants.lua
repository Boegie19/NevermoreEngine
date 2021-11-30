local require = require(script.Parent.loader).load(script)

local Table = require("Table")

return Table.readonly({
	REMOTE_FUNCTION_NAME_IS_IN_GROUP = "IsInGroupRemoteFunction";
    REMOTE_FUNCTION_NAME_GET_RANK_IN_GROUP = "GetRankInGroupRemoteFunction";
    REMOTE_FUNCTION_NAME_GET_ROLE_IN_GROUP = "GetRoleInGroupRemoteFunction";
    REMOTE_FUNCTION_RETRY_VALUE = 3
})