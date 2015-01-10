--[[-----------------------------------------------------------------------------------------------------------------------
	Serverside initialization
-----------------------------------------------------------------------------------------------------------------------]]--

-- Show startup message
print( "\n===========================================" )
print( " Evolve " ..evolve.version .. " succesfully started serverside." )
print( "===========================================\n" )

-- Load plugins
evolve:LoadPlugins()

-- Tell the clients Evolve is installed on the server
hook.Add( "PlayerSpawn", "EvolveInit", function( ply )
	if ( !ply.EV_SentInit ) then
		timer.Simple( 1, function()
			net.Start( "EV_Init" )
			net.Send( ply )
		end )
		
		ply.EV_SentInit = true
	end
end )