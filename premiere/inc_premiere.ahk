; hotkeys for use with Adobe Premiere
; written by Kristen Maxwell, who looks like you on Sunday


;;;Premiere
#IfWinActive Adobe Premiere


{
;-------------------	
;laptop key bindings
;-------------------
;trying to make up for lack of extended keys and keypad
!=:: Send {NumpadAdd}
!-::Send {NumpadSub}
!1::Send {Numpad1}
!2::Send {Numpad2}
!3::Send {Numpad3}
!4::Send {Numpad4}
!5::Send {Numpad5}
!6::Send {Numpad6}
!7::Send {Numpad7}
!8::Send {Numpad8}
!9::Send {Numpad9}
!0::Send {Numpad0}
!`::Send {NumpadDot}
!Enter::Send {NumpadEnter}


; FIT TO FILL
; !,:: kmap_fit_to_fill()
; !.:: kmap_fit_to_fill("o")



;------------------------------------	
; Play Head and Tail -- keypad method
;------------------------------------
; shows quickly how well an inserted clip matches with surrounding clips, playing just a few seconds around both edges of the clip.
; KNOWN ISSUES: 
;--only works with clips with a duration longer than the variable "review_length." I don't know of any way around this
; since we can't get the clip duration from premiere AFAIK. If your "review_length" is longer than the clip you're working with, 
; the macro will correctly play around the head of your clip, but then it will jump ahead and play around the tail of the NEXT clip instead. 
;
;~ +Enter:: ; bind to key Shift Enter
	;~ Send {Up} ;jump to prev edit
	;~ WinMenuSelectItem, Adobe Premiere Pro, , Edit, Deselect All ; deselects any clips in the timeline so that they don't get shifted via keypad timecode entry
	;~ ; the following line uses the numeric keypad to enter the seconds and frames to jump back from the current edit
	;~ ; these values are initialized in the AUTOEXEC portion of the script
	;~ Send {NumpadSub}{Numpad%review_seconds%}{NumpadDot}{Numpad%review_frames_tens%}{Numpad%review_frames_ones%}{NumpadEnter} 
	;~ Sleep 100 ; tiny pause to make sure Premeire is caught up and ready for further commands
	;~ Send {l} ; play
	;~ Sleep %review_length%000 ; wait while premiere plays the portion around the edit
	;~ Send {k} ; pause
	;~ Sleep 2000 ; optional-- two-second breather before jumping ahead to the next edit 
	;~ Send {Down} ; jump to next edit
	;~ ; the following line uses the numeric keypad to enter the seconds and frames to jump back from the current edit
	;~ Send {NumpadSub}{Numpad%review_seconds%}{NumpadDot}{Numpad%review_frames_tens%}{Numpad%review_frames_ones%}{NumpadEnter} 
	;~ Sleep 100 ; tiny pause to make sure Premeire is caught up and ready for further commands
	;~ Send {l} ;play
	;~ Sleep %review_length%000 ; wait while premiere plays the portion around the edit
	;~ Send {k} ;pause
;~ Return


;~ ;------------------------------------	
;~ ; Ripple Cut 
;~ ;------------------------------------
;~ ; copies the selected clip, then ripple deletes it. Handy when used with the built-in Paste Insert function. 
;~ ;I map Paste Insert to Shift V, so i can easily ripple cut/paste insert clips around the timeline.
;~ +x:: ; bind to key Shift X
	;~ WinMenuSelectItem, Adobe Premiere Pro, , Edit, Copy ; copies the current clip via menu 
	;~ WinMenuSelectItem, Adobe Premiere Pro, , Edit, Ripple Delete ; ripple deletes the current clip via menu 
;~ return



;------------------------------------	
; Subclip to Single Smartbin
;------------------------------------
; hotkeys to make a new subclip and append a "tag" to the subclip's name. 
; Combine this with your own Smart Bins in premiere (i.e. saved search bins)
; and this will allow you to subclip to a single bin with one keypress.
;
; relies on the function kmap_subclip_with_tag(), defined in the FUNCTION section, 
; and the array variable tags[], initialized in the AUTOEXEC section
;
; by default, bound keys are Shift Ctrl (1 through 0), this is done in autoexec section. 
; To change the hotkeys assigned to this feature, edit the kmap_settings.ini file.



;------------------------------------	
; Subclip with multiple tags/smartbins
;------------------------------------
; hotkeys to make a GUI open, where you can select any combination of 
; 10 predefined tags to append to the end of a new subclip's name.
; Combine this with your own Smart Bins in premiere (i.e. saved search bins)
; to automatically sort new subclips to multiple bins
;
; relies on the function kmap_subclip_with_multiple_tags(), defined in the FUNCTION section, 
; and the array variable tags[], initialized in the AUTOEXEC section 




; ************ ALTERNATE GUI METHOD ************************
; this version requires user to HOLD DOWN a key to keep the GUI open, 
; upon release it makes the subclip with the selected tags.
; 
; hit ESC to cancel.
; 
; or, if no tags have been selected, no subclip will be made

;~ f1:: ; default keybind to F1
;~ {
	;~ checkboxes_sum := 0 ; init var to hold count of # of checkboxes that were activated
	;~ gosub preparegui ; make the gui, kmap_gui:behind the scenes
	;~ gosub, resetguivalues ; reset its values (unless its sticky)
	;~ gui, kmap_gui:Show, w478 h378, multitag_gui  ; show the GUI at the specified size
	;~ gui_canceled := 0 ; init flag that tells if the GUI was canceled with escape or x button or OK button
	;~ KeyWait, f1 ; wait for f1 to be released
	;~ if !winexist("multitag_gui") {
		;~ return 	; if the gui has been closed by any means (including hitting OK/Enter), skip the rest of this fn, 
				;~ ; because it has already been handled via other subroutines
	;~ } ; end if
	;~ gui, kmap_gui:submit ; when f1 is released, the varaibles are saved
	;~ kmap_shitbird() ; pseudoarray shenanigans
	;~ gui, kmap_gui:destroy ; then the window is destroyed
	;~ loop, 10 { ; then we check to see if any checkboxes were active
		;~ ;i := SubStr(a_index, 0, 1) ; 1-9, 0
		;~ checkboxes_sum := checkboxes_sum + multitag[a_index] ; sum will be 0 if all checkboxes are unchecked
	;~ } ; end loop
	;~ ; the gui_canceled flag gets set in the preparegui subroutine, as the action taken when user hits escape or the cancel button is clicked
	;~ if (gui_canceled <> 1) and (checkboxes_sum > 0) { ; if they actually wanted to make a subclip...
		;~ kmap_subclip_with_multiple_tags() ; then it calls the function that actually makes the subclip and adds the tags specified in the GUI
	;~ } ; end if
			
;~ return
;~ } ; end of f1 hotkey


} ; end ifwinactive premiere
