--[[-----------------------------------------------------------------------------------------------------------------------
	Default custom scoreboard
-----------------------------------------------------------------------------------------------------------------------]]--

resource.AddFile( "materials/gui/scoreboard_header.png" )
resource.AddFile( "materials/gui/scoreboard_middle.png" )
resource.AddFile( "materials/gui/scoreboard_bottom.png" )

resource.AddFile( "materials/gui/scoreboard_ping.png" )
resource.AddFile( "materials/gui/scoreboard_frags.png" )
resource.AddFile( "materials/gui/scoreboard_skull.png" )
resource.AddFile( "materials/gui/scoreboard_playtime.png" )

local PLUGIN = {}
PLUGIN.Title = "Scoreboard"
PLUGIN.Description = "Default custom scoreboard."
PLUGIN.Author = "Overv"

if ( CLIENT ) then
	PLUGIN.MatHeader = Material( "gui/scoreboard_header.png", "smooth" )
	PLUGIN.MatMiddle = Material( "gui/scoreboard_middle.png", "smooth" )
	PLUGIN.MatBottom = Material( "gui/scoreboard_bottom.png", "smooth" )
	
	PLUGIN.MatPing = Material( "gui/scoreboard_ping.png", "smooth" )
	PLUGIN.MatFrags = Material( "gui/scoreboard_frags.png", "smooth" )
	PLUGIN.MatDeaths = Material( "gui/scoreboard_skull.png", "smooth" )
	PLUGIN.MatPlaytime = Material( "gui/scoreboard_playtime.png", "smooth" )
	
	PLUGIN.Width = 687

	surface.CreateFont( "EvolveScoreboardTitle", {
		font	= "Helvetica",
		size	= 25,
		weight	= 800
	} )
	
	surface.CreateFont( "EvolveInfoBarBold", {
		font = "CloseCaption_Normal", 
		weight = 600
	} )
	surface.CreateFont( "EvolveInfoBar", {
		font = "CloseCaption_Normal", 
		weight = 400
	} )
	surface.CreateFont( "EvolveScoreboardText", {
		font = "Default", 
		weight = 600, 
		size = 12
	} )
	surface.CreateFont( "EvolveScoreboardUser", {
		font = "Default", 
		weight = 500, 
		size = 13
	} )
end

function PLUGIN:ScoreboardShow()
	if ( GAMEMODE.IsSandboxDerived and evolve.installed ) then
		self.DrawScoreboard = true
		gui.EnableScreenClicker( true )
		return true
	end
end

function PLUGIN:ScoreboardHide()
	if ( self.DrawScoreboard ) then
		self.DrawScoreboard = false
		gui.EnableScreenClicker( false )
		return true
	end
end

function PLUGIN:DrawTexturedRect( tex, x, y, w, h )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetTexture( tex )
	surface.DrawTexturedRect( x, y, w, h )
end

function PLUGIN:QuickTextSize( font, text )
	surface.SetFont( font )
	return surface.GetTextSize( text )
end

function PLUGIN:FormatTime( raw )
	if ( raw < 60 ) then
		return math.floor( raw ) .. " secs"
	elseif ( raw < 3600 ) then
		if ( raw < 120 ) then return "1 min" else return math.floor( raw / 60 ) .. " mins" end
	elseif ( raw < 3600*24 ) then
		if ( raw < 7200 ) then return "1 hour" else return math.floor( raw / 3600 ) .. " hours" end
	else
		if ( raw < 3600*48 ) then return "1 day" else return math.floor( raw / 3600 / 24 ) .. " days" end
	end
end

function PLUGIN:DrawInfoBar()
	-- Background
	surface.SetDrawColor( 192, 218, 160, 255 )
	surface.DrawRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawOutlinedRect( self.X + 15, self.Y + 110, self.Width - 30, 28 )
	
	-- Content
	local x = self.X + 24
	draw.SimpleText( "Currently playing ", "EvolveInfoBar", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBar", "Currently playing " )
	draw.SimpleText( GAMEMODE.Name, "EvolveInfoBarBold", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBarBold", GAMEMODE.Name )
	draw.SimpleText( " on the map ", "EvolveInfoBar", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBar", " on the map " )
	draw.SimpleText( game.GetMap(), "EvolveInfoBarBold", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBarBold", game.GetMap() )
	draw.SimpleText( ", with ", "EvolveInfoBar", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBar", ", with " )
	draw.SimpleText( #player.GetAll(), "EvolveInfoBarBold", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	x = x + self:QuickTextSize( "EvolveInfoBarBold", #player.GetAll() )
	local s = ""
	if ( #player.GetAll() > 1 ) then s = "s" end
	draw.SimpleText( " player" .. s .. ".", "EvolveInfoBar", x, self.Y + 128, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
end

function PLUGIN:DrawUsergroup( playerinfo, usergroup, title, icon, y )
	local playersFound = false
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			playersFound = true
			break
		end
	end
	if ( !playersFound ) then return y end
	
	surface.SetDrawColor( 168, 206, 116, 255 )
	surface.DrawRect( self.X + 0.5, y, self.Width - 2, 22 )
	surface.SetMaterial( icon )
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.DrawTexturedRect( self.X + 15, y + 4, 14, 14 )
	draw.SimpleText( title, "EvolveScoreboardText", self.X + 40, y + 15, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
	
	surface.SetMaterial( self.MatPing )
	surface.DrawTexturedRect( self.X + self.Width - 50, y + 4, 14, 14 )
	surface.SetMaterial( self.MatDeaths )
	surface.DrawTexturedRect( self.X + self.Width - 150.5, y + 4, 14, 14 )
	surface.SetMaterial( self.MatFrags )
	surface.DrawTexturedRect( self.X + self.Width - 190.5,  y + 4, 14, 14 )
	surface.SetMaterial( self.MatPlaytime )
	surface.DrawTexturedRect( self.X + self.Width - 100,  y + 4, 14, 14 )
	
	y = y + 18
	
	for _, pl in ipairs( playerinfo ) do
		if ( pl.Usergroup == usergroup ) then
			y = y + 20
			draw.SimpleText( pl.Nick, "EvolveScoreboardUser", self.X + 40, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Frags, "EvolveScoreboardUser", self.X + self.Width - 184, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Deaths, "EvolveScoreboardUser", self.X + self.Width - 144, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( pl.Ping, "EvolveScoreboardUser", self.X + self.Width - 43, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			draw.SimpleText( self:FormatTime( pl.PlayTime ), "EvolveScoreboardUser", self.X + self.Width - 92, y, Color( 39, 39, 39, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP )
			
		end
	end
	
	return y + 15
end

function PLUGIN:DrawPlayers()
	local playerInfo = {}
	for _, v in pairs( player.GetAll() ) do
		table.insert( playerInfo, { Nick = v:Nick(), Usergroup = v:EV_GetRank(), Frags = v:Frags(), Deaths = v:Deaths(), Ping = v:Ping(), PlayTime = evolve:Time() - v:GetNWInt( "EV_JoinTime" ) + v:GetNWInt( "EV_PlayTime" ) } )
	end
	table.SortByMember( playerInfo, "Frags" )
	
	local y = self.Y + 155
	
	local sortedRanks = {}
	for id, rank in pairs( evolve.ranks ) do
		table.insert( sortedRanks, { ID = id, Title = rank.Title, Immunity = rank.Immunity, Icon = rank.IconMaterial } )
	end
	table.SortByMember( sortedRanks, "Immunity" )
	
	for _, rank in ipairs( sortedRanks ) do
		if( string.Right( rank.Title, 2 ) != "ed" ) then
			y = self:DrawUsergroup( playerInfo, rank.ID, rank.Title .. "s", rank.Icon, y )
		else
			y = self:DrawUsergroup( playerInfo, rank.ID, rank.Title, rank.Icon, y )
		end
	end
	
	return y
end

function PLUGIN:HUDDrawScoreBoard()
	if ( !self.DrawScoreboard ) then return end
	if ( !self.Height ) then self.Height = 139 end
	
	-- Update position
	self.X = ScrW() / 2 - self.Width / 2
	self.Y = ScrH() / 2 - ( self.Height ) / 2
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	
	surface.SetMaterial( self.MatHeader )
	surface.DrawTexturedRect( self.X, self.Y, self.Width, 122 )
	draw.SimpleText( GetHostName(), "EvolveScoreboardTitle", self.X + 133, self.Y + 51, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	draw.SimpleText( GetHostName(), "EvolveScoreboardTitle", self.X + 132, self.Y + 50, Color( 255, 255, 255, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	
	surface.SetDrawColor( 255, 255, 255, 255 )
	surface.SetMaterial( self.MatMiddle )
	surface.DrawTexturedRect( self.X, self.Y + 122, self.Width, self.Height - 122 - 37 )
	surface.SetMaterial( self.MatBottom )
	surface.DrawTexturedRect( self.X, self.Y + self.Height - 37, self.Width, 37 )
	
	self:DrawInfoBar()
	
	local y = self:DrawPlayers()
	
	self.Height = y - self.Y
end
if IsValid( g_Scoreboard ) then g_Scoreboard:Remove() end
evolve:RegisterPlugin( PLUGIN )