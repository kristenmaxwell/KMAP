; General usage functions

; Function to set a variable to be within a certain min/max range. If no min and max values are passed, assumes a range of 1 to 100
; Written by Kristen Maxwell, who's gonna carry that weight a long time
km_Bound(variable, min := 1, max := 100) {
		If (variable > max){ 
			variable := max
		}
		else If (variable < min){
			variable := min
		}
	return variable
} ; end bound

; function to change the screen resolution
; i did not write this, i stole it from somewhere. I'm sorry.

km_ChangeResolution( cD, sW, sH, rR ) {
  VarSetCapacity(dM,156,0), NumPut(156,2,&dM,36)
  DllCall( "EnumDisplaySettingsA", UInt,0, UInt,-1, UInt,&dM ), 
  NumPut(0x5c0000,dM,40)
  NumPut(cD,dM,104), NumPut(sW,dM,108), NumPut(sH,dM,112), NumPut(rR,dM,120)
  Return DllCall( "ChangeDisplaySettingsA", UInt,&dM, UInt,0 )
} ; end km_changeresolution


; Function to run a program or activate an already running instance
; stolen by Kristen Maxwell, who wishes there was something real
km_RunOrActivateProgram(Program, WorkingDir="", WindowSize=""){
	SplitPath Program, ExeFile
	Process, Exist, %ExeFile%
	PID = %ErrorLevel%
	if (PID = 0) {
		Run, %Program%, %WorkingDir%, %WindowSize%
	}else{
		WinActivate, ahk_pid %PID%
	}
} ; end km_runoractivateprogram
