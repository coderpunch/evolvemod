--[[-----------------------------------------------------------------------------------------------------------------------
	Unban a player
-----------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "Unban"
PLUGIN.Description = "Unban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "unban"
PLUGIN.Usage = "<steamid|nick>"
PLUGIN.Privileges = { "Unban" }

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Unban" ) ) then
		if ( args[1] ) then
			local sid
			local str = table.concat(args)
			if ( string.match( str, "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then
				sid = str
			end
			
			if ( sid and evolve:IsBanned( sid ) ) then
				evolve:UnBan( sid, ply:SteamID() )
				
				evolve:Notify( evolve.colors.blue, ply:Nick(), color_white, " has unbanned ", evolve.colors.red, evolve:GetProperty( sid, "Nick" ), color_white, "." )
			elseif ( sid ) then
				evolve:Notify( ply, evolve.colors.red, evolve:GetProperty( sid, "Nick" ) .. " is not currently banned." )
			else
				evolve:Notify( ply, evolve.colors.red, "No matching players found!" )
			end
		else
			evolve:Notify( ply, evolve.colors.red, "You need to specify a SteamID!" )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

evolve:RegisterPlugin( PLUGIN )