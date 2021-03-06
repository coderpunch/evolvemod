--[[-----------------------------------------------------------------------------------------------------------------------
	Clientside initialization
-----------------------------------------------------------------------------------------------------------------------]]--

-- Show startup message
print( "\n=====================================================" )
print( " Evolve succesfully started clientside." )
print( "=====================================================\n" )

net.Receive( "EV_Init", function( len )
	evolve.installed = true
	
	-- Load plugins
	evolve:LoadPlugins()
end )