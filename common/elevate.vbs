Option Explicit
Dim shell, script
If WScript.Arguments.Count <> 1 Then WScript.Quit 1
script = WScript.Arguments(0)
Set shell = CreateObject("Shell.Application")
shell.ShellExecute script, "", "", "runas", 1
