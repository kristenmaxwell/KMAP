; functions used by Adobe Premiere features
; written by Kristen Maxwell, who's got more rhymes than he's got grey hairs

;Function to read settings from INI. If INI does not exist, write one with the a default template.
; written by Kristen Maxwell, who doesn't wanna be a candidate for Vietnam or Watergate
; -- based on code genereously provided by reddit /r/autohotkey user radiantcabbage
; -- also contains stuff stolen from user Linear Spoon on old authohotkey.com forum
kmap_options_ini_read() {
	setworkingdir % a_scriptdir
	settingsobj := { } 										; creates an object to store what we're gonna return

    ; if there is no ini file, let's write one with a default template
    if !fileexist("kmap_options.ini") {
		
			; settings for general options
			pairs_general := "
			(
; Settings for use with Kristen Maxwell's Adobe Premiere Autohotkey features
; Only edit this file if you know what you're doing!
; (if you mess it up, just delete it, and run the script again-- it will regenreate a fresh copy, as if by magic!)
;
; NOTE -- hotkeys are defined as per the AHK syntax:  https://autohotkey.com/docs/KeyList.htm
; modifiers:
; +  is SHIFT
; ^  is CTRL 
; !  is ALT
; #  is WIN
;
enable_ripple_cut=1
ripple_cut_hotkey=+x
enable_paste_insert=1
paste_insert_hotkey=+v
enable_fit_to_fill=1
fit_to_fill_insert_hotkey=+,
fit_to_fill_overwrite_hotkey=+.
			)"
			iniwrite, %pairs_general%, kmap_options.ini, General
		
			; settings for the review head/tail feature
			pairs_headtail := "
			(
enable_review_head_tail=1
review_head_tail_hotkey=!enter
frame_rate=30
review_length=5
			)"
			iniwrite, %pairs_headtail%, kmap_options.ini, Review-Head-Tail
			
			; settings for single subclip tag feature
			pairs_singletag := "
			(
enable_single_tag_subclip=1
single_tag_modifier=!
single_tag_hotkeys=1,2,3,4,5,6,7,8,9,0
single_tag_use_numpad=0
single_tag_numpad_modifier=!
			)"
			iniwrite, %pairs_singletag%, kmap_options.ini, Single-Tag
			
			; settings for multitag subclip feature
			pairs_multitag := "
			(
enable_multitag_subclip=1
multitag_hotkey=^+u
multitag_use_numpad=0
multitag_use_alternate=1
multitag_alternate_hotkey=f1
			)"
			iniwrite, %pairs_multitag%, kmap_options.ini, Multi-Tag
			
			
			; the TAGS section
			pairs_tags := "
			(
tag1=WIDE
tag2=MED
tag3=CU
tag4=2-SHOT
tag5=OTS-A
tag6=OTS-B
tag7=MOVING
tag8=RXN
tag9=GOOD
tag10=OUTTAKE
			)"
			iniwrite, %pairs_tags%, kmap_options.ini, Tags

} ; end if !filexists

	; and now, here we are at the portion that actually READS the INI file, just like it says on the tin
	; the following loop will read all the lines in an INI file and put the k/v pairs into an object
	Loop, Read, kmap_options.ini ; read each line of the ini file
	{
		
		If ( ( InStr(A_LoopReadLine, "[") = 0) AND StrLen(A_LoopReadLine) > 2) 							; if line doesn't contain a [ and is more than 2 chars
		{ 			
			trimmed_string := A_LoopReadLine			
			trimmed_string := StrReplace(trimmed_string, " up", "öup")									; temporarily replace special case " up" 
																											; to avoid stripping its space
			trimmed_string := StrReplace(trimmed_string, A_Space, "")									; remove all spaces from line
			trimmed_string := StrReplace(trimmed_string, A_Tab, "")										; remove all tabs from line
			trimmed_string := StrReplace(trimmed_string, "öup"," up")									; restore " up"



			comment_position := Instr(trimmed_string, "`;",,1,1)										; look for a semicolon/comment
			if (comment_position <> 0) {																; if there is a semicolon (i.e. comment)
				trimmed_string := SubStr(trimmed_string, 1, comment_position)							; trim string to remove comment
			} ; end if			
			
			delim_position := InStr(trimmed_string, "=")												; find the position of the "="
			if (delim_position == 0) {			
				continue 																				; there's no = on this line, skip to next iteration
			} ; end if			
			
			keyname := SubStr(trimmed_string, 1, delim_position-1)										; the keyname is what's to the left of the "="
			val := Substr(trimmed_string, delim_position+1, strlen(trimmed_string) - delim_position) 	; the value is what's to the right of the "="
			
			
			settingsobj[keyname] := val																	; object.keyname := value
			OutputDebug, % keyname ", " val
		} ; end if
	
	} ; end loop
	
	
	return settingsobj
} ; end fn kmap_options_ini_read


; function to perform a Paste Insert in Premiere
kmap_paste_insert() {
	WinMenuSelectItem, Adobe Premiere Pro,, Edit, Paste Insert 	; select Paste Insert from Edit Menu
return
}

; function to perform a "fit to fill" edit
; written by Kristen Maxwell, who has gone savage for teenagers with automatic weapons and boundless love
kmap_fit_to_fill(edit_type := "i") {
	WinMenuSelectItem, Adobe Premiere Pro,, Clip, % (edit_type == "o")  ? "Overwrite" : "Insert" ; if passed "o" do overwrite, else do insert 
	WinWaitActive , Fit Clip,, 1 											; wait for subclip dialog to open, or timeout after 1 second
	if (errorlevel) {
		return 																	; if the fit clip window didn't open in time, skip the rest of this function
	} ; end if 
	Send {tab 2}{up 5}														; select "fit to fill"
	sleep 50
	Send {Enter}															; submit/OK
return
} ; end fn kmap_fit_to_fill

; function to perform single-tag subclip in Premiere
; written by Kristen Maxwell, who sends his thoughts to far-off destinations
kmap_subclip_with_tag(tagnumber) {
	global tags 													; array variable setup in AUTOEXEC
    WinMenuSelectItem, Adobe Premiere Pro, , Clip, Make Subclip... 	; opens Make Subclip dialog box
	WinWaitActive , Make Subclip,, 1 								; wait for subclip dialog to open, or timeout after 1 second
	if (errorlevel) {
		return 														; if the Make Subclip window didn't open in time, skip the rest of this function
	} ; end if 
	Send {right} 													; move cursor to end of subclip name field
	sleep 10 														; pause to let Premiere catch its breath
	send {left 3}{backspace 7} 										; keep serialized ###, delete the word "Subclip"
	Sleep 10 														; pause to let Premiere catch its breath
	send ^{end} 													; go to the end of the input field
	string_to_send := "." . tags[tagnumber]							; ex ".Tag1" or ".Wide"-- prefix dot to help clarify search bin function in Premiere
	Send %string_to_send% {Enter}									; append tags[n]'s contents to subclip name, then hits Enter to close Subclip dialog box
	return
} ; end function subclip_with_tag



; function to perform multiple-tag subclip in Premiere
; written by Kristen Maxwell, who's just tired and doesn't love you anymore
kmap_subclip_with_multiple_tags() {
	global tags, multitag 														; access the global variable array that contains the user-defined tags
																				; should already be global via main script INIT in autoexec
		
	string_to_send := "" 														; initialize the string we're going to return
		loop, 10 { 																; we're gonna loop through 10 array elements
			string_to_send .= (multitag[a_index]) ? "." . tags[a_index] : "" 	; if the current variable is a 1 (i.e. it was checked in the GUI), 
																				; we add that tag to our string that's gonna be returned
		} ; end loop
	WinMenuSelectItem, Adobe Premiere Pro, , Clip, Make Subclip... 				; opens Make Subclip dialog box
	WinWaitActive , Make Subclip,, 1 											; wait for subclip dialog to open, or timeout after 1 second
	if (errorlevel) {
		return 																	; if the Subclip window didn't open in time, skip the rest of this function
	} ; end if 
	

	; this is the portion of the function that just uses regular AHK commands to send input to the program. If you want some different
	; behavior from this function, this is a good place to do it.

	Send {right} 																; move cursor to end of subclip name field
	sleep 10 																	; pause to let Premiere catch its breath
	send {left 3}{backspace 7} 													; keep the . and serialized ###, delete the word "Subclip"
	Sleep 10 																	; pause to let Premiere catch its breath
	send ^{end} 																; go to the end of the input field
	Send %string_to_send% {Enter} 												; append all the tags selected in the GUI to the end of the subclip name,
																				; then hit Enter to close Make Subclip dialog box
	return
} ; end function subclip_with_multiple_tags




; function to copy pseudoarray into an actual array, b/c GUIs are assholes
; written by Kristen Maxwell, who describes how you're feeling all the time
kmap_shitbird(reverse := 0) {
	global multitag
	
	loop, 10 {
			if !reverse {
				multitag[a_index] := multitag_pa%a_index% ; copy pseudoarray into actual array, b/c shitbird
			} else {
				multitag_pa%a_index% := multitag[a_index] ; copy actual array into pseudoarray, b/c dribtihs 
			} ; end else
	} ; end loop
} ; end fn shitbird


; function to make hotkeys for me based on INI settings
; written by Kristen Maxwell, who fills their heads with rumors of impending doom
kmap_makehotkeys(gatekeeper := "true", hkname := "z", destination := "kmap_deadend") {
	hotkey, IfWinActive, Adobe Premiere
	;~ if (gatekeeper == "kmap_settings.enable_single_tag_subclip") {	; special case (multiple keys need to be defined)
		;~ kmap_makenumberhotkeys(gatekeeper, hkname, destination)		; run special function
		;~ return														; and then return
	;~ } ; end if
	if (!gatekeeper) { 
		hotkey, IfWinActive											; reset hotkey scope
		return 														; short-circuit this function if the INI has disabled this feature
	} ; end if
	if !IsLabel(destination) {
		destination := "kmap_deadend"								; set a trap for undefined destinations
	} ; end if
	;hkname := kmap_escapar(hkname)									; escape any commas in key name
	hotkey, %hkname%, %destination%									; actually define they hotkey
	hotkey, IfWinActive												; reset hotkey scope
	; msgbox, made hotkey %hkname% go to %destination%
return

return
} ; end of fn kmap_makehotkeys	
		
; function to check if a variable is valid a keyboard modifier
kmap_ismodifier(string := "") {
		; special case for ALTGR
		if (string == "<^>!") {				; modifier is ALTGR
			; msgbox, % "special case, string is " string
			return TRUE											; cancel function, return TRUE to caller
		} ; end if


		mod_matchlist := ",~,!,#,$,^,&,*,<,>,<^>!"
		if string not contains %mod_matchlist%  				; INI supplied modifier doesn't have any modifier characters
		{
			msgbox, 48, % "Invalid Modifier in INI: " string, % a_loopfield " contains no valid modifiers. Setting to BLANK"
			return FALSE										; cancel function, return FALSE to caller
		} ; end if not contains
		
		counter := {"^":0, "+":0, "!":0, "#":0}					; an array to hold the counter for each modifier -- to make sure they're only used once each
		modifiers_list := "^+!#~*$&<>"

		loop, parse, string 										; loop through each character in string
		{	
			; msgbox, % "field= " a_loopfield
			charposition := instr(modifiers_list, a_loopfield) 
			; msgbox, % "charposition= " charposition
			if  (charposition == 0)	{			; character is not contained  in modifiers list
				msgbox, 48, % "Invalid Modifier in INI: " string, % a_loopfield " cannot be in a modifier. Setting to BLANK"
				return false										; stop running function and return FALSE to caller
			} ; end if
			counter[a_loopfield] += 1
			if (counter[a_loopfield] > 1) { 						; there's more than one occurrence of a given modifier
				msgbox, 48, % "Invalid Modifier in INI: " string, % "Too many " a_loopfield "s. Setting to BLANK"
				return false										; stop running function, return FALSE to caller
			} ; end if
		} ; end loop
return true															; end of function, return TRUE to caller
} ; end fn kmap_ismodifier

	
; function to create hotkeys from numeric keys
; written by Kristen Maxwell, who saw stars falling all around your head
kmap_makenumberhotkeys(gatekeeper := "true", hkname := "1,2,3,4,5,6,7,8,9,0", destination := "kmap_deadend") {
	hotkey, IfWinActive, Adobe Premiere								; restrict hotkeys to Premiere window
	if (!gatekeeper) { 												; if INI variable is NOT enabled	
		hotkey, IfWinActive											; reset hotkey scope
		return 														; short-circuit this function if the INI has disabled this feature
	} ; end if
	
	numberkeyarray := []											; make an array to store the hotkeys
	modifier := kmap_settings.single_tag_modifier					; get modifier keys from INI settings object
	num_modifier := kmap_settings.single_tag_numpad_modifier		; ditto for numpad keys
	if (!kmap_ismodifier(modifier)) {								; check validity of modifier
		modifier :=""												; if invalid, set to blank
	} ; end if
	if (!kmap_ismodifier(num_modifier)) {							; check validity of num_modifier
		num_modifier :=""												; if invalid, set to blank
	} ; end if



	loop, parse, hkname, `, 										; loop through each comma-separated element
	{
		numberkeyarray[A_index] := A_LoopField						; puts each key into a separate entry in the array
	} ; end loop

	if (numberkeyarray.length() <> 10) {								; if there aren't exactly 10 keys, force the default value of 1...0
		msgbox, % "INI file contained unusable keys for Single-Tab Subclip. `n Restoring default (keys 1...9, 0)"
		numberkeyarray := [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
	} ; end if


	; this loop creates 10 hotkeys (and numpad keys, if set in the INI) to invoke the single_tag subclip function	
	loop, 10 { 
		index_zero := substr(a_index, 0, 1) 							; get last digit, 1...9, 0
		hotkeyfunc := Func("kmap_subclip_with_tag").bind(a_index) 		; calls ex. kmap_subclip_with_tag(1) 
		hkname := modifier . numberkeyarray[a_index]					; combine modifier and key
		hotkey, %hkname% , % hotkeyfunc 								; define hotkey to make a subclip with a specific tag		
		if (kmap_settings.singletag_use_numpad) { 						; if numpad option enabled in INI
			hkname := num_modifier . "Numpad" . index_zero				; build hotkey name
			hotkey, %hkname%, % hotkeyfunc 								; define numpad hotkeys to make a subclip with a specific tag
																		; [user defined modifier(s)]  NUMPAD0 - NUMPAD9  
		} ; end if
	} ; end loop
	hotkey, IfWinActive													; return hotkey definition scope to default
	
return
} ; end fn kmap_makenumberhotkeys

