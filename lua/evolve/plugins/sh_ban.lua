--[[-----------------------------------------------------------------------------------------------------------------------
	Ban a player
		To do: Clean up this piece of shit.
-----------------------------------------------------------------------------------------------------------------------]]--

local PLUGIN = {}
PLUGIN.Title = "Ban"
PLUGIN.Description = "Ban a player."
PLUGIN.Author = "Overv"
PLUGIN.ChatCommand = "ban"
PLUGIN.Usage = "<player> [time=5] [reason]"
PLUGIN.Privileges = { "Ban", "Permaban" }

function PLUGIN:Call( ply, args )
	local time = math.Clamp( tonumber( args[2] ) or 5, 0, 10080 )
	
	if ( ( time > 0 and ply:EV_HasPrivilege( "Ban" ) ) or ( time == 0 and ply:EV_HasPrivilege( "Permaban" ) ) ) then
		--[[-----------------------------------------------------------------------------------------------------------------------
			Get the Steam ID to ban
		-----------------------------------------------------------------------------------------------------------------------]]--
		
		local sid
		if ( string.match( args[1] or "", "STEAM_[0-5]:[0-9]:[0-9]+" ) ) then 
			sid = args[1]
		else
			local pl = evolve:FindPlayer( args[1] )
			if ( #pl > 1 ) then
				evolve:Notify( ply, evolve.colors.white, "Did you mean ", evolve.colors.red, evolve:CreatePlayerList( pl, true ), evolve.colors.white, "?" )
				return
			elseif ( #pl == 1 ) then
				pl = pl[1]
				sid = pl:SteamID()
			end
		end
		
		--[[-----------------------------------------------------------------------------------------------------------------------
			Make sure the player exists and we're allowed to ban it
		-----------------------------------------------------------------------------------------------------------------------]]--
		
		if ( !sid or ( tonumber( evolve.ranks[ ply:EV_GetRank() ].Immunity ) <= tonumber( evolve.ranks[ evolve:GetProperty( sid, "Rank", "guest" ) ].Immunity ) and ply != NULL ) ) then
			evolve:Notify( ply, evolve.colors.red, evolve.constants.noplayers2 )
			return
		end
		
		--[[-----------------------------------------------------------------------------------------------------------------------
			Gather data and perform ban
		-----------------------------------------------------------------------------------------------------------------------]]--
		
		local length = math.Clamp( tonumber( args[2] ) or 5, 0, 10080 ) * 60
		local reason = table.concat( args, " ", 3 )
			if ( #reason == 0 ) then reason = "No reason specified" end
		local nick = evolve:GetProperty( sid, "Nick", sid )
		
		evolve:Ban( sid, length, reason, ply:SteamID() )
		
		if ( length == 0 ) then
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " permanently (" .. reason .. ")." )
		else
			evolve:Notify( evolve.colors.blue, ply:Nick(), evolve.colors.white, " banned ", evolve.colors.red, nick, evolve.colors.white, " for " .. length / 60 .. " minutes (" .. reason .. ")." )
		end
	else
		evolve:Notify( ply, evolve.colors.red, evolve.constants.notallowed )
	end
end

if ( SERVER ) then
	function PLUGIN:CheckPassword( steamID64, ipAddress, svPassword, clPassword, name )
		local sid = util.SteamIDFrom64( steamID64 )
		if evolve:IsBanned( sid ) then
			local msg = ""
			.."BANNED FROM SERVER"
			.."\n"
			.."\nTime Remaining:"
			.."\n    "..evolve:FormatTime( (evolve.bans[sid]["BanEnd"] or 0) - os.time() )
			.."\nBan Reason:"
			.."\n    "..(evolve.bans[sid]["BanReason"] or "N/A")
			.."\nYour SteamID:"
			.."\n    "..sid
			return false, msg
		end
	end
end

function PLUGIN:Menu( arg, players )
	if ( arg ) then
		RunConsoleCommand( "ev", "ban", players[1], arg )
	else
		return "Ban", evolve.category.administration, {
			{ "5 minutes", "5" },
			{ "10 minutes", "10" },
			{ "15 minutes", "15" },
			{ "30 minutes", "30" },
			{ "1 hour", "60" },
			{ "2 hours", "120" },
			{ "4 hours", "240" },
			{ "12 hours", "720" },
			{ "One day", "1440" },
			{ "Two days", "2880" },
			{ "One week", "10080" },
			{ "Two weeks", "20160" },
			{ "One month", "43200" },
			{ "One year", "525600" },
			{ "Permanently", "0" }
		}, "Time"
	end
end

evolve:RegisterPlugin( PLUGIN )