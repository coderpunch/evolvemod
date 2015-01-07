/*-------------------------------------------------------------------------------------------------------------------------
	Evolve version
-------------------------------------------------------------------------------------------------------------------------*/

local PLUGIN = {}
PLUGIN.Title = "Version"
PLUGIN.Description = "Returns the version of Evolve."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = { "version", "about" }

function PLUGIN:Call( ply, args )
	evolve:Notify( ply, evolve.colors.white, "This server is running ", evolve.colors.red, "revision " .. evolve.version, evolve.colors.white, " of Evolve." )
end

function PLUGIN:PlayerInitialSpawn( ply )
	if ( ply:EV_IsOwner() ) then
		if ( !self.LatestVersion ) then
			http.Fetch( "http://raw.githubusercontent.com/edgarasf123/evolvemod/master/lua/evolve/version.lua", 
				function( body, len, headers, code )
					self.LatestVersion = tonumber( body or 0 ) or 0
					self:PlayerInitialSpawn( ply )
				end, 
				function( err )
					self.LatestVersion = -1
				end
			);
			return
		end
		if ( evolve.version < self.LatestVersion ) then
			evolve:Notify( ply, evolve.colors.red, "WARNING: Your Evolve needs to be updated to revision " .. self.LatestVersion .. "!" )
		end
	end
end

evolve:RegisterPlugin( PLUGIN )