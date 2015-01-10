--[[-----------------------------------------------------------------------------------------------------------------------
	Current time
-----------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "Time"
PLUGIN.Description = "Returns the current time."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "time"
PLUGIN.Privileges = { "The time" }

if SERVER then
	util.AddNetworkString( "EV_ShowTime" )
end

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "The time" ) ) then
		net.Start( "EV_ShowTime" )
		net.Send( ply )
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

net.Receive( "EV_ShowTime", function( len )
	evolve:Notify( evolve.colors.white, "It is now ", evolve.colors.blue, os.date( "%H:%M" ), evolve.colors.white, "." )
end )

evolve:RegisterPlugin( PLUGIN )