import XMonad
import XMonad.Util.Replace
import Data.Map as M

-- default terminal program
myTerminal = "urxvt"

-- set Mod key to the win key
myModMask = mod4Mask

-- border width
myBorderWidth = 2

main = do
    replace
    xmonad $ defaultConfig
	{
		modMask = myModMask
    ,   terminal = myTerminal
    ,   borderWidth = myBorderWidth
	}
