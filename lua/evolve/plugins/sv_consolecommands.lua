--[[-----------------------------------------------------------------------------------------------------------------------
	Provides console commands
-----------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "Console Commands"
PLUGIN.Description = "Provides console commands to run plugins."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = nil
PLUGIN.Usage = nil

function PLUGIN:GetArguments( allargs )
	local newargs = {}
	for i = 2, #allargs do
		table.insert( newargs, allargs[i] )
	end
	return newargs
end

function PLUGIN:MakePatternSafe( str )
	return str:gsub( "([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1" )
end
function PLUGIN:StripQuotes( s )
	return s:gsub( "^%s*[\"]*(.-)[\"]*%s*$", "%1" )
end
function PLUGIN:Explode( separator, str, limit )
	local t = {}
	local curpos = 1
	while true do -- We have a break in the loop
		local newpos, endpos = str:find( separator, curpos ) -- find the next separator in the string
		if newpos ~= nil then -- if found then..
			table.insert( t, str:sub( curpos, newpos - 1 ) ) -- Save it in our table.
			curpos = endpos + 1 -- save just after where we found it for searching next time.
		else
			if limit and table.getn( t ) > limit then
				return t -- Reached limit
			end
			table.insert( t, str:sub( curpos ) ) -- Save what's left in our array.
			break
		end
	end

	return t
end
function PLUGIN:SplitArgs( str ) -- Borrowed from ULib
	str = string.Trim( str )
	if str == "" then return {} end
	local quotes = {}
	local t = {}
	local marker = "^*#" 

	str:gsub( "%b\"\"", function ( match ) 
		local s = self:StripQuotes( match )
		table.insert( quotes, s )

		str = str:gsub( self:MakePatternSafe( match ), marker .. #quotes, 1 ) 
	end )

	t = self:Explode( "%s+", str )

	
	for i, v in ipairs( t ) do
		t[ i ] = string.Trim( v )
	end

	for i, v in ipairs( t ) do
		if v:sub( 1, 3 ) == marker then 
			local num = tonumber( string.sub( v, 4 ) )
			t[ i ] = quotes[ num ]
		end
	end

	return t
end

function PLUGIN:CCommand( ply, com, cargs )
	local args = self:SplitArgs( cargs )
	if ( #args == 0 ) then return end
	
	local command = table.remove(args,1)
	
	evolve:Log( evolve:PlayerLogStr( ply ) .. " ran command '" .. command .. "' with arguments '" .. table.concat( args, " " ) .. "' via console." )
	
	for _, plugin in ipairs( evolve.plugins ) do
		if ( plugin.ChatCommand == string.lower( command or "" ) or ( type(plugin.ChatCommand) == "table" and table.HasValue( plugin.ChatCommand, command ) ) ) then
			plugin:Call( ply, args )
			return ""
		end
	end
	
	evolve:Message( "Unknown command '" .. command .. "'" )
end
concommand.Add( "ev", function( ply, com, args, argsStr ) PLUGIN:CCommand( ply, com, argsStr ) end )
concommand.Add( "evs", function( ply, com, args, argsStr ) evolve.SilentNotify = true PLUGIN:CCommand( ply, com, argsStr ) evolve.SilentNotify = false end )

evolve:RegisterPlugin( PLUGIN )