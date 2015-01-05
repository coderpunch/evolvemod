--[[-----------------------------------------------------------------------------------------------------------------------
	Serverside autorun file
-----------------------------------------------------------------------------------------------------------------------]]--

-- Set up Evolve table
evolve = {}

if SERVER then
	-- Distribute clientside and shared files
	AddCSLuaFile( "autorun/ev_autorun.lua" )
	AddCSLuaFile( "evolve/framework.lua" )
	AddCSLuaFile( "evolve/cl_init.lua" )
	AddCSLuaFile( "evolve/menu/cl_menu.lua" )

	-- Load serverside files
	include( "evolve/database.lua" )
	include( "evolve/framework.lua" )
	include( "evolve/sv_init.lua" )
	include( "evolve/menu/sv_menu.lua" )
elseif CLIENT then
	-- Load clientside files
	include( "evolve/framework.lua" )
	include( "evolve/menu/cl_menu.lua" )
	include( "evolve/cl_init.lua" )
end