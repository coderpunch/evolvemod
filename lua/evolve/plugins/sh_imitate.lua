--[[-----------------------------------------------------------------------------------------------------------------------
	Imitate a player
-----------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "Imitate"
PLUGIN.Description = "Imitate a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "im"
PLUGIN.Usage = "<player> <message>"
PLUGIN.Privileges = { "Imitate" }

if SERVER then
	util.AddNetworkString( "EV_Imitate" )
end

function PLUGIN:Call( ply, args )
	if ( ply:EV_HasPrivilege( "Imitate" ) ) then	
		local players = evolve:FindPlayer( args[1] )
		local msg = table.concat( args, " ", 2 )
		
		if ( #players == 1 ) then
			if ( #msg > 0 ) then
				net.Start( "EV_Imitate" )
					net.WriteEntity( players[1] )
					net.WriteString( msg )
					net.WriteBit( players[1]:IsBot() or players[1]:Alive() )
				net.Broadcast()
			else
				evolve:Notify( ply, evolve.colors.red, "No message specified." )
			end
		elseif ( #players > 1 ) then
			evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( players, true ), evolve.colors.white, "?" )
		else
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

net.Receive( "EV_Imitate", function( len )
	local ply = net.ReadEntity()
	hook.Call( "OnPlayerChat", nil, ply, net.ReadString(), false, net.ReadBit() == 0 )
end )

evolve:RegisterPlugin( PLUGIN )