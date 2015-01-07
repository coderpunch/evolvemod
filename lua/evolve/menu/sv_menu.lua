/*-------------------------------------------------------------------------------------------------------------------------
	Serverside menu framework
-------------------------------------------------------------------------------------------------------------------------*/

// Send all tabs to the clients
<<<<<<< HEAD:lua/evolve/menu/sv_menu.lua
local tabs,_ = file.Find( "evolve/menu/tab_*.lua", "LUA" )
for _, tab in ipairs( tabs ) do
=======
for _, tab in ipairs( file.Find( "evolve/menu/tab_*.lua", "LUA_PATH" ) ) do
>>>>>>> origin/master:lua/evolve/menu/sv_menu.lua
	AddCSLuaFile( tab )
end

// Register privileges
table.insert( evolve.privileges, "Menu" )

function evolve:RegisterTab( tab )
	table.Add( evolve.privileges, tab.Privileges or {} )
end

<<<<<<< HEAD:lua/evolve/menu/sv_menu.lua
for _, tab in ipairs( tabs ) do
=======
for _, tab in ipairs( file.Find( "evolve/menu/tab_*.lua", "LUA_PATH" ) ) do
>>>>>>> origin/master:lua/evolve/menu/sv_menu.lua
	include( tab )
end