/*-------------------------------------------------------------------------------------------------------------------------
	Display all chat commands
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Chatcommands"
PLUGIN.Description = "Display all available chat commands."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "commands"

if SERVER then 
	util.AddNetworkString( "EV_CommandStart" )
	util.AddNetworkString( "EV_CommandEnd" )
	util.AddNetworkString( "EV_Command" )
	
end

function PLUGIN:Call( ply, args )
	local commands = table.Copy( evolve.plugins )
	table.sort( commands, function( a, b )
		local cmdA, cmdB = ( a.ChatCommand or "" ), ( b.ChatCommand or "" )
		if ( type(cmdA) == "table" ) then cmdA = cmdA[1] end
		if ( type(cmdB) == "table" ) then cmdB = cmdB[1] end
		return cmdA < cmdB
	end )
	
	if ( ply:IsValid() ) then
		net.Start( "EV_CommandStart" ) net.Send( ply )
		
		for _, plug in ipairs( commands ) do
			if ( plug.ChatCommand ) then
				if ( type( plug.ChatCommand ) == "string" ) then
					net.Start( "EV_Command" )
						net.WriteString( plug.ChatCommand )
						net.WriteString( tostring( plug.Usage ) )
						net.WriteString( plug.Description )
					net.Send( ply )
				elseif ( type( plug.ChatCommand ) == "table" ) then
					for _, cmd in pairs( plug.ChatCommand ) do
						net.Start( "EV_Command" )
							net.WriteString( cmd )
							net.WriteString( tostring( plug.Usage ) )
							net.WriteString( plug.Description )
						net.Send( ply )
					end
				end
			end
		end
		net.Start( "EV_CommandEnd") net.Send( ply )
		
		evolve:Notify( ply, evolve.colors.white, "All chat commands have been printed to your console." )
	else
		for _, plugin in ipairs( commands ) do
			if ( plugin.ChatCommand ) then
				if ( plugin.Usage ) then
					print( "!" .. plugin.ChatCommand .. " " .. plugin.Usage .. " - " .. plugin.Description )
				else
					print( "!" .. plugin.ChatCommand .. " - " .. plugin.Description )
				end
			end
		end
	end
end

net.Receive( "EV_CommandStart", function( len )
	print( "\n============ Available chat commands for Evolve ============\n" )
end )

net.Receive( "EV_CommandEnd", function( len )
	print( "" )
end )

net.Receive( "EV_Command", function( len )
	local com = net.ReadString()
	local usage = net.ReadString()
	local desc = net.ReadString()
	
	if ( usage != "nil" ) then
		print( "!" .. com .. " " .. usage .. " - " .. desc )
	else
		print( "!" .. com .. " - " .. desc )
	end
end )

evolve:RegisterPlugin( PLUGIN )