#NoTrayIcon
#RequireAdmin
#include <APIShellExConstants.au3>
#include <WinAPIDlg.au3>
#include <WinAPIShellEx.au3>
#include <Array.au3>
#include <Misc.au3>

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=icon.ico
#AutoIt3Wrapper_Outfile=wtfic-86.Exe
#AutoIt3Wrapper_Outfile_x64=wtfic-64.Exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=Windows 10 Folder Icon Changer | A FREE TOOL BY BLACK SWAN LAB
#AutoIt3Wrapper_Res_Description=Windows 10 Folder Icon Changer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.46
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_CompanyName=Black Swan Lab ( https://blackswanlab.ir )
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © BLACK SWAN LAB , all rights reserved.
#AutoIt3Wrapper_Res_LegalTradeMarks=Programmed by Amirhoseeinhpv ( https://hpv.im )
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****


If @OSArch = "X64" Then

    Global $HKCR = "HKCR64"

Else

    Global $HKCR = "HKCR"

EndIf

If _Singleton("WINDOWS 10 FOLDER ICON CHANGER | A FREE TOOL BY BLACK SWAN LAB", 1) = 0 Then

    Exit

EndIf

checkForNewverSion()

Local $aLast[2] = [@SystemDir & '\imageres.dll', 3]
Local $sPath[1]
Local $sPath
Local $oItemsd = ""
Local $oItemsFnd = 0

If $CmdLine[0] And $CmdLine[0] = 1 AND ($CmdLine[1] <> "") Then

	If Not IsFile($CmdLine[1]) Then

		$oItemsFnd +=1

		Local $sPath[1]

		$sPath[0] = $CmdLine[1]

	EndIf

ElseIf $CmdLine[0] And $CmdLine[2] <> "" Then

	$hExplorer = WinGetHandle( "[REGEXPCLASS:^(Cabinet|Explore)WClass$]" )

	If Not $hExplorer Then Exit

	$oShell = ObjCreate( "Shell.Application" )

	For $oWindow In $oShell.Windows()

	  If $oWindow.HWND() = $hExplorer Then ExitLoop

	Next

	$i = 0

	For $oItem In $oWindow.Document.SelectedItems()

	  	If Not IsFile($oItem.Path()) Then

			$oItemsd &= $oItem.Path() & "|"

			$oItemsFnd +=1

		EndIf

	Next

EndIf

If $oItemsd <> "" Then

	$sPath = StringSplit ($oItemsd, "|")

EndIf

If $oItemsFnd == 0 Then

	Local $sPath[1]

	$file = FileSelectFolder('Select Folder', '', 0, @ScriptDir)

	If $file  Then

		$sPath[0] = $file

	Else

		Exit

	EndIf

EndIf

Local $aIcon = _WinAPI_PickIconDlg($aLast[0], $aLast[1])

If @error Then Exit

For $folder in $sPath

	If Not IsFile($folder) Then

		Local $tSHFCS = DllStructCreate($tagSHFOLDERCUSTOMSETTINGS & ';wchar szIconFile[' & (StringLen($aIcon[0]) + 1) & ']')
		DllStructSetData($tSHFCS, 'Size', DllStructGetPtr($tSHFCS, 'szIconFile') - DllStructGetPtr($tSHFCS))
		DllStructSetData($tSHFCS, 'Mask', $FCSM_ICONFILE)
		DllStructSetData($tSHFCS, 'IconFile', DllStructGetPtr($tSHFCS, 'szIconFile'))
		DllStructSetData($tSHFCS, 'SizeIF', 260)
		DllStructSetData($tSHFCS, 'IconIndex', $aIcon[1])
		DllStructSetData($tSHFCS, 'szIconFile', $aIcon[0])

		_WinAPI_ShellGetSetFolderCustomSettings($folder, $FCS_FORCEWRITE, $tSHFCS)

	EndIf

Next

Func checkForNewverSion()

	If @Compiled Then

		$copy = False

		$current = FileGetVersion(@WindowsDir&"\wtfic.exe","FileVersion")

		$now = FileGetVersion(@ScriptFullPath,"FileVersion")

		If $now > $current Then

			FileCopy(@ScriptFullPath,@WindowsDir&"\wtfic.exe",9)

			ToolTip("Windows 10 Folder Icon Changer | Update installed on your system automatically. " & $current & " => " & $now,1,4)

			$copy = true

			Sleep(1000)

			ToolTip("")

		EndIf

		If $copy == true Then

			RegWrite($HKCR &"\Folder\shell\wtfic")

			RegWrite($HKCR &"\Folder\shell\wtfic","","REG_SZ","Change Folder Icon")

			RegWrite($HKCR &"\Folder\shell\wtfic","Icon","REG_SZ",@WindowsDir&"\wtfic.exe")

			RegWrite($HKCR &"\Folder\shell\wtfic","Version","REG_SZ",$now)

			RegWrite($HKCR &"\Folder\shell\wtfic","Position","REG_SZ","BOTTOM")

			RegWrite($HKCR &"\Folder\shell\wtfic\command")

			RegWrite($HKCR &"\Folder\shell\wtfic\command","","REG_SZ",@WindowsDir&'\wtfic.exe /new "%1"')

		EndIf

	EndIf

EndFunc

Func IsFile($sFilePath)

    Return StringInStr(FileGetAttrib($sFilePath), "D") = 0

EndFunc

