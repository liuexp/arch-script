import XMonad
import Data.Monoid
import System.Exit
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops	hiding (fullscreenEventHook)
import XMonad.Hooks.DynamicLog		(dynamicLogWithPP,xmobarPP,xmobarColor,shorten,ppOutput,ppLayout,ppTitle,wrap,ppCurrent)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers	(isDialog, isFullscreen, doCenterFloat, doFullFloat)
import XMonad.Layout.Fullscreen		(fullscreenEventHook,fullscreenManageHook)
import XMonad.Prompt			(defaultXPConfig)
import XMonad.Prompt.XMonad		(xmonadPrompt)
import XMonad.Prompt.AppendFile		(appendFilePrompt)
import XMonad.Prompt.RunOrRaise		(runOrRaisePrompt)

import XMonad.Util.Run			(spawnPipe)
import System.IO			(hPutStrLn)
import XMonad.Hooks.SetWMName		(setWMName)
import XMonad.Actions.CycleWS		(prevWS,nextWS,shiftToNext,shiftToPrev)
import XMonad.Layout.NoBorders		(smartBorders)
import XMonad.Layout.Grid
import Graphics.X11.ExtraTypes.XF86

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import Codec.Binary.UTF8.String		(utf8Encode)
import Control.Applicative		((<$>),(<*>),pure)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "gnome-terminal"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Width of the window border in pixels.
--
myBorderWidth   = 1
myModMask       = mod4Mask
myWorkspaces    = ["1:web","2:code","3:work","4:util","5:system","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"
noteFile = "/home/liuexp/NOTE"
colorOrange          = "#ff7701"
colorDarkGray        = "#171717"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm , xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_r     ), spawn "exe=`yeganesh -x -- -p '>'` && eval \"exec $exe\"")
    
    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm .|. shiftMask, xK_Tab   ), windows W.focusUp)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Make current window fullscreen
    , ((modm,               xK_m     ), withFocused $ \f -> windows =<< appEndo <$> runQuery doFullFloat f )

    -- Swap the focused window to master
    , ((modm .|. shiftMask, xK_m     ), windows W.swapMaster  )

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

     , ((modm              , xK_b     ), sendMessage ToggleStruts)
     , ((modm .|. shiftMask, xK_l     ), spawn "xscreensaver-command -lock")

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io exitSuccess)

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((modm,               xK_Right ), nextWS)
    , ((modm,               xK_Left  ), prevWS)
    , ((modm .|. shiftMask, xK_Right ), shiftToNext)
    , ((modm .|. shiftMask, xK_Left  ), shiftToPrev)
    , ((0, xK_Print), spawn "scrot")
    , ((controlMask, xK_Print), spawn "sleep 0.2; scrot -s")
    , ((modm		, xK_p), runOrRaisePrompt defaultXPConfig)
    , ((modm .|. shiftMask, xK_n), spawn ("date>> "++noteFile) 
    					>> appendFilePrompt defaultXPConfig noteFile)
    , ((modm .|. controlMask, xK_n), spawn ("notify-send \"`tail -n 10 " ++ noteFile ++ "`\""))
    , ((modm .|. controlMask, xK_x), xmonadPrompt defaultXPConfig)
    , ((modm, 		xK_f), spawn "~/.xmonad/easyxmotion.py --colour='#0fff00' --font='-misc-fixed-bold-r-normal--45-0-100-100-c-0-iso8859-15'")
    -- Multimedia Keys
	, ((0, xF86XK_AudioMute), spawn "amixer sset Master toggle")		                   --Mute/unmute volume
	, ((0, xF86XK_AudioRaiseVolume), spawn "amixer set Master 2000+ unmute")       		   --Raise volume
	, ((0, xF86XK_AudioLowerVolume), spawn "amixer set Master 2000- unmute")  	           --Lower volume
	, ((0, xF86XK_AudioNext), spawn "ncmpcpp next")                                            --next song
	, ((0, xF86XK_AudioPrev), spawn "ncmpcpp prev")                                            --prev song
	, ((0, xF86XK_AudioPlay), spawn "ncmpcpp toggle")                                          --toggle song
	, ((0, xF86XK_AudioStop), spawn "ncmpcpp stop")   
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

	, ((modm, button4), (\_ -> prevWS))                                                -- switch to previous workspace
	, ((modm, button5), (\_ -> nextWS))                                                -- switch to next workspace
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = tiled ||| Mirror tiled ||| Full ||| Grid
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll 
	[ isDialog	--> doCenterFloat
 	, isFullscreen	--> doFullFloat
	, isInClass toFloat	--> doFloat
	, isInClass toIgnore	--> doIgnore
	]
	where
		isInClass c	=	foldl1 (<||>) [ className =? x | x <- c ]
		toFloat		=	[ "MPlayer","Gimp","Smplayer","Eog" ]
		toIgnore	=	[ "stalonetray", "trayer", "Xfce4-notifyd" ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = fullscreenEventHook

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
--myLogHook = return ()
------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
		xmproc <- spawnPipe "/usr/bin/xmobar /home/liuexp/.xmobarrc"
		xmonad $ defaults
			{ logHook = dynamicLogWithPP xmobarPP  
	         		  { ppOutput = hPutStrLn xmproc . utf8Encode
	         		  , ppTitle = xmobarColor "green" "#444444" . shorten 93   
	         		  , ppLayout = const "" -- to disable the layout info on xmobar  
	         		  }   
		}
--main = xmonad desktopConfig

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--

defaults = ewmh desktopConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = avoidStruts $ smartBorders $ myLayout ||| layoutHook desktopConfig,
        manageHook         = 	myManageHook <+> 
				manageHook desktopConfig <+> 
				manageDocks <+>
				fullscreenManageHook,
        handleEventHook    = myEventHook,
 --       logHook            = myLogHook,
        startupHook        = myStartupHook
    }

