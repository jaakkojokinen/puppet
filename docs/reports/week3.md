## Week 3

### Test environment
- Macbook Pro (early 2011) 
- Xubuntu 16.04 on VirtualBox (5.0.28 r111378) / Puppet version 3.8.5

### Configuring terminal settings with puppet
Assingment was to configure desktop settings with puppet and to push them to VCS. I tried to configure terminal color settings because I always change those anyway. First I created the init.pp file.

```puppet
class terminal {
	file { "/home/jaakko/.config/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
```

I also tested with another file path. This will change the colors for all the users, not just me.

```puppet
class terminal {
	file { "/etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc":
		ensure => "file",
		content => template("terminal/terminalrc.erb"),
	}
}
```

Default terminal settings can be found from file ~/.config/xfce4/terminal/terminalrc or from /etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc. The latter is for configuring settings system wide. 

/etc/xdg/xdg-xubuntu/xfce4/terminal/terminalrc
```
[Configuration]
FontName=DejaVu Sans Mono 9
ColorForeground=#b7b7b7
ColorBackground=#131926
ColorPalette=#000000;#aa0000;#44aa44;#aa5500;#0039aa;#aa22aa;#1a92aa;#aaaaaa;#777777;#ff8787;#4ce64c;#ded82c;#295fcc;#cc58cc;#4ccce6;#ffffff
ColorSelection=#163b59
ColorSelectionUseDefault=FALSE
ColorCursor=#0f4999
ColorBold=#ffffff
ColorBoldUseDefault=FALSE
TabActivityColor=#0f4999
```

~/.config/xfce4/terminal/terminalrc
```
[Configuration]
ColorForeground=#b7b7b7
ColorBackground=#131926
ColorCursor=#93a1a1
ColorSelection=#163b59
ColorSelectionUseDefault=FALSE
ColorBoldUseDefault=FALSE
ColorPalette=#000000;#aa0000;#44aa44;#aa5500;#0039aa;#aa22aa;#1a92aa;#aaaaaa;#777777;#ff8787;#4ce64c;#ded82c;#295fcc;#cc58cc;#4ccce6;#ffffff
FontName=DejaVu Sans Mono 9
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=FALSE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_BLOCK
MiscDefaultGeometry=80x24
MiscInheritGeometry=FALSE
MiscMenubarDefault=TRUE
MiscMouseAutohide=FALSE
MiscToolbarDefault=FALSE
MiscConfirmClose=TRUE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscTabPosition=GTK_POS_TOP
MiscHighlightUrls=TRUE
MiscScrollAlternateScreen=TRUE
TabActivityColor=#0f4999
```

New values for the keys ColorForeground, ColorBackground and ColorPalette. I defined these in the templates/terminalrc.erb file.

```
ColorForeground=#93a1a1
ColorBackground=#002b36
ColorPalette=#002b36;#dc322f;#859900;#b58900;#268bd2;#6c71c4;#2aa198;#93a1a1;#657b83;#cb4b16;#073642;#586e75;#839496;#eee8d5;#d33682;#fdf6e3
```

```
sudo puppet apply -e 'class{terminal:}'
sudo apt-get update
sudo apt-get install -y tree
```

![print1]
(https://github.com/jaakkojokinen/puppet/blob/master/docs/images/Screen%20Shot%202016-11-15%20at%2014.02.21.png?raw=true)


### Sources
https://www.puppetcookbook.com

List of ready-to-use color configurations
https://github.com/chriskempson/base16-xfce4-terminal

http://askubuntu.com/questions/151403/xubuntu-how-to-restore-default-terminal-text-coloring
