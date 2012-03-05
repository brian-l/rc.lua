-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
-- Theme handling library
require("beautiful")
-- Vain
require("vain")

-- Disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
	oldspawn(s, false)
end

-- Themes define colours, icons, and wallpapers
beautiful.init("/home/brian/.config/awesome/themes/custom/theme.lua")

-- Used for the uselessfail layout
beautiful.useless_gap_width = 20

-- Define the commands for various applications
terminal = "/usr/bin/urxvt -imlocale en_US.UTF8 -icon /usr/share/icons/Faenza/apps/16/terminal.xpm"
gmrun = "gmrun"
chrome = "chromium"
gedit = "gedit"
pcmanfm = "pcmanfm"

-- Startup items
awful.util.spawn(terminal)
awful.util.spawn("feh --bg-scale /home/brian/Pictures/Minimalist2/Flashlight.png")
awful.util.spawn("pypanel")
awful.util.spawn("wicd-client --tray")
awful.util.spawn("bluetooth-applet")

-- Default modkey.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	vain.layout.uselessfair,
}

tags = {}
for s = 1, screen.count()
do
	tags[s] = awful.tag({ "One", "Two", "Three", "Four" }, s, layouts[1])
end

myawesomemenu = 
{
	{"Reload Config", awesome.restart},
}

mychromemenu = 
{
   { "Chromium" ,  chrome},
   { "Incognito" ,  "chromium --incognito"},
   { "Tor" , incognito},
}

mynetmenu = 
{
   { "Chrome", mychromemenu },
   { "Konversation", "konversation" },
   { "Thunderbird", "thunderbird" },
   { "Skype", "skype" },
   { "Firefox", "firefox" },
}

myeditorsmenu = 
{
   { "GEdit", "gedit" },
   { "Geany", "geany" },
   { "Eclipse", eclipse },
   { "Root GEdit", "gksudo gedit" },
}

myofficemenu = 
{
   { "Base", "libreoffice -base" },
   { "Calc", "libreoffice -calc" },
   { "Draw", "libreoffice -draw" },
   { "Impress", "libreoffice -impress" },
   { "Math", "libreoffice -math" },
   { "Writer", "libreoffice -writer" },
}

mymediamenu = 
{
   { "Rhythmbox", "rhythmbox" },
   { "Evince", "evince" },
   { "Cheese", "cheese" },
}

myutilitiesmenu = 
{
   { "PCMan FM", "pcmanfm" },
   { "Terminal", terminal },
   { "Calculator", "gcalctool" },
   { "Alsamixer", terminal .. " -e sh -c alsamixer" },
   { "HTop", terminal .. " -e sh -c htop" },
   { "Evince", "evince" },
   { "VirtualBox", "virtualbox" },
}

mygraphicsmenu = 
{
   { "GIMP", "gimp" },
   { "Inkscape", "inkscape" },
   { "Eye of GNOME", "eog" },
}

mymainmenu = awful.menu(
{ 
	items = 
	{ 
		{ "Net", mynetmenu },
		{ "Editors", myeditorsmenu },
		{ "LibreOffice", myofficemenu },
		{ "Media", mymediamenu },
		{ "Utilities", myutilitiesmenu },
		{ "Graphics", mygraphicsmenu },
		{ "Reload Config", awesome.restart },
	}
})

mylayoutmenu = awful.menu(
{
    items =
    {
        { "Floating", function() awful.layout.set(awful.layout.suit.floating) end},
        { "Tile Left", function() awful.layout.set(awful.layout.suit.tile.left) end},
        { "Tile Right", function() awful.layout.set(awful.layout.suit.tile) end},
        { "Tile Bottom", function() awful.layout.set(awful.layout.suit.tile.bottom) end},
        { "Space Fair", function() awful.layout.set(vain.layout.uselessfair) end},
    }
})

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mymainmenu })      

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus 
            then 
            	client.focus:raise() 
        	end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus 
            then 
            	client.focus:raise() 
            end
        end),

	-- Show the custom menu (similar to openbox menu)
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),
    awful.key({ modkey,           }, "a", function () mylayoutmenu:show({keygrabber=true}) end),
	awful.key({}, "Menu", function () mymainmenu:show({keygrabber=true}) end),
	awful.key({ modkey,			  }, "d", function () 
											awful.util.spawn("dmenu_run -nb '#000000' -sb '#BBBBBB' -nf '#BBBBBB' -sf '#000000'")
										  end),

	-- XF86 Control
	awful.key({}, "XF86AudioRaiseVolume" , function () awful.util.spawn("amixer sset 'Master',0 5%+")    end),
	awful.key({}, "XF86AudioLowerVolume" , function () awful.util.spawn("amixer sset 'Master',0 5%-")    end),
	awful.key({}, "XF86AudioMute", function () awful.util.spawn("amixer sset 'Master',0 toggle")    end),
	awful.key({}, "XF86Calculator", function () awful.util.spawn("gcalctool")    end),
	awful.key({}, "XF86Mail", function () awful.util.spawn("thunderbird")    end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

	-- My custom launchers
	awful.key({ modkey, "Control" }, "l", function () awful.util.spawn("xscreensaver-command -lock") end),
	awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey,           }, "g", function () awful.util.spawn(gmrun) end),
    awful.key({ modkey,           }, "c", function () awful.util.spawn(chrome) end),
    awful.key({ modkey,           }, "i", function () awful.util.spawn("chromium --incognito") end),
    awful.key({ modkey,           }, "e", function () awful.util.spawn(gedit) end),
    awful.key({ "Fn"		      }, "Print" , function() awful.util.spawn(scrot) end),
    awful.key({ modkey },            "r",     function () awful.util.spawn(rhythmbox) end),
	awful.key({ modkey 			  }, "p",	  function () awful.util.spawn(eog) end), 
	awful.key({ modkey, "Control" }, "p",	  function () awful.util.spawn(pcmanfm) end), 
	awful.key({ modkey 			  }, "Up",	 	
	function ()
		if beautiful.useless_gap_width - 5 >= 0
		then
			beautiful.useless_gap_width = beautiful.useless_gap_width - 5
			awful.layout.set(awful.layout.get())
		end
	 end), 
	awful.key({ modkey 			  }, "Down",
    function ()
		if beautiful.useless_gap_width + 5 <= 180
		then
        	beautiful.useless_gap_width = beautiful.useless_gap_width + 5
        	awful.layout.set(awful.layout.get())
		end
     end),
    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.01)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.01)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey,           }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end))


clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey,           }, "x",      function (c) c:kill()                         end),
    awful.key({ modkey,           }, "v",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- 

-- Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { size_hints_honor = false,
					 border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
	{ rule = { class = "gmrun" },
      properties = { floating = true } },
    { rule = { class = "Gimp" },
      properties = { floating = true } },
    { rule = { class = "Skype" },
      properties = { floating = true } },
	{ rule = { class = "Gnome-terminal" },
	  properties = { floating = true } },
	{ rule = { class = "URxvt" },
	      properties = { floating = true } },
	{ rule = { class = "Key-mon" },
	      properties = { floating = true } },
	{ rule = { class = "Eog" },
		  properties = { floating = true } },
	{ rule = { class = "Wicd-client.py" },
		  properties = { floating = true } },

}
-- Signals
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

