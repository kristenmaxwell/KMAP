# KMAP
AuthoHotkey Stuff for Adobe Premiere
written by Kristen Maxwell, who thrusts his fists against the post and still insists he sees a ghost

Howdy, and welcome to the first real release of my AHK stuff for Premiere.



To utilize this script, you'll need to install AutoHotKey (get it at https://autohotkey.com/). Once that's installed, simply navigate to this folder, right click on KM_AdobePremeireStuff.ahk and select "Run Script." You'll know it's working if:
a. there are no screeching errors and/or flames shooting out of your computer
b. there is a little green icon in your taskbar with a big white H on it.


SETTINGS
--------
This release includes a handy KMAP_options.ini file, where you can configure the options and customize your hotkeys. But be warned-- you edit this file at your own risk. If you totally screw it up, you can just delete it, and the script will create a fresh one the next time it is run.

In the INI file, you can enable/disable any feature. Simply look for the relevant keyname (such as enable_fit_to_fill), and set its value to 1 to enable, or 0 to disable. 

Likewise, you can redefine which hotkeys are used for each feature-- but you have to be careful with this as it's pretty easy to break things if you define your hotkeys incorrectly. I'm not a good enough programmer to make the script impervious to data entry errors, so you'll have to help me out by providing valid input in the INI file. 

for q quick reference about hotkey prefixes (to add modifier keys), see https://autohotkey.com/docs/Hotkeys.htm#Symbols

for a list of the names of all the keys that can be defined in AHK, see 
https://autohotkey.com/docs/KeyList.htm#Keyboard

--------
FEATURES
--------

Fit to Fill:
------------
If you set up a four-point edit (IN and OUT points in both Source and Timeline), you can tell Premiere to do a fit-to-fill edit with a single keystroke. This bypasses the usual routine of having to make an edit, tab through the Fit Clip options, and submit the Fit Clip dialog. So it saves you about 5-6 keystrokes, and restores the functionality that USED to be available in older versions of Premiere (there was a fit-to-fill button, even!).

This feature uses the following hotkeys:

SHIFT ,			Fit-to-Fill Insert Edit
SHIFT .			Fit-to-Fill Overwrite Edit






Ripple Cut:
----------- 
If you've ever wanted to fly through your timeline, moving clips around at breakneck speed, this is the thing for you. Simply make a selection (default keyboard shortcut to select clip at playhead is D), then fire off this hotkey to copy the selection and Ripple Delete it. The real magic comes when you use it in conjunction with  "Insert Paste," so you can ripple cut and ripple insert super easily. 

This feature uses the following hotkeys:

SHIFT X			Ripple Cut
SHIFT V			Paste Insert (or if you prefer, "Ripple Paste")




Review Head and Tail:
---------------------
This is designed to aid in insert editing, to provide a quick view of the around the "edges" of a clip in the timeline. When you press this hotkey, Premiere will jump back to the beginning of the clip under the playhead, and play a few seconds across the edit. Then it will jump to the end of your clip, and play a few seconds around it.
The amount of time to be played (as well as the frame rate of the sequence) can be configured in the INI file to suit your needs. 

Default values: 

Sequence Frame Rate: 30 fps (this is only used to calculate fractional seconds in the review duration, so you don't HAVE to change this to match your frame rate-- but it's included for those of you who crave precision)

Review Time: 5 seconds 

This feature uses the following hotkeys:

ALT ENTER 		Review Head and Tail of clip at playhead





Subclip Tagging:
----------------
This is actually two separate features that share a common premise-- using snippets of text in a subclip's name to act as "tags" to aid in organization.

The Problem-- Premiere's subclipping feature leaves a lot to be desired when it comes to organization. You can't really control where subclips are created, and it's kind of a chore to wrangle them into any sense of order.

The Solution-- Search Bins. Basically I've given up on using normal bins for this process, because they're so inflexible. So I recommend setting up your project with one bin that houses all your master clips (and will consequently be where your subclips actually end up... probably). Then, in a separate bin, create several Search Bins to keep track of your subclips. You'll need one search bin for each tag you're using. So, for example, you might define one search bin to look for the text ".WIDE" -- this will populate that bin with any clip that contains ".WIDE" in its name.

And here's where this feature comes in handy. Rather than manually typing ".WIDE" at the end of all your subclip names, this script uses 10 preset tags and assigns them to a quick subtag-creation system.

To instantly make a subclip with any ONE tag applied to its name, simply press its corresponding key:

ALT 1			Create Subclip with Tag 1		Default: WIDE
ALT 2			Create Subclip with Tag 2		Default: MED
ALT 3			Create Subclip with Tag 3		Default: CU
ALT 4			Create Subclip with Tag 4		Default: 2-SHOT
ALT 5			Create Subclip with Tag 5		Default: OTS-A
ALT 6			Create Subclip with Tag 6		Default: OTS-B
ALT 7			Create Subclip with Tag 7		Default: MOVING
ALT 8			Create Subclip with Tag 8		Default: RXN
ALT 9			Create Subclip with Tag 9		Default: GOOD
ALT 0			Create Subclip with Tag 10		Default: OUTTAKE

You are HIGHLY encouraged to customize these tags by editing the KMAP_options.ini file in the script's directory. Note that any spaces will be automatically stripped out for, um, technical reasons? And avoid special, non-alphanumeric characters so it doesn't break anything in AutoHotKey. 

Optionally, you can configure the NUMPAD keys to do the same thing. To enable this feature, open KMAP_options.ini and set single_tag_use_numpad=1, and configure the modifier key using single_tag_numpad_modifier= 
(for a list of modifier key syntax, see https://autohotkey.com/docs/Hotkeys.htm#Symbols)




Alternatively, you can create a subclip while appying MULTIPLE tags. To do this, you first bring up the Multi-Tag interface with its hotkey. (default: SHIFT CTRL U)
With this window open, you can select any combination of the 10 preset tags, using either the mouse, or by pressing the number of each tag on the keyboard. When you submit the list of tags (by hitting Enter or pressing the OK button), the script will create a new subclip and append ALL of the selected tags to its name. Pretty nifty, right?

There's also an alternate method of using this interface, if you find it to be faster (I do...). Using a separate hotkey (default: F1), you can bring up the window WHILE HOLDING THE HOTKEY DOWN. You can then select your tags, and as soon as you RELEASE the hotkey, it will automatically submit the tag list and create your subclip. I find this to be super cool, but as always, your mileage may vary.

This feature uses the following hotkeys:

SHIFT CTRL U			Open Tag Selection Window

F1 (while pressed) 		Open Tag Selection Window in Alternate mode
F1 (when released)		Submit tags list, create subclip


You can also optionally enable the numpad keys to select the tags in the Tag Selection window, the same way that the numeral keys do. To enable this feature, open KMAP_options.ini and set multitag_use_numpad=1

