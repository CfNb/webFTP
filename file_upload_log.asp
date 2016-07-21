<%
'function for adding info to log file
'creates a new log file for each day

'This directory must have write permissions by IUSER and IWAM
logpath = "C:\DigitalFTP Folder\Tmp\Log Files_Digital\"

todaydate = Right("0" & Month(Now),2) & Right("0" & Day(Now),2) & Year(Now)
logfile = todaydate + ".txt"

logloc = logpath&logfile

'Does the log file exist? If not, create one
set fso = createobject("scripting.filesystemobject")
If Not fso.FileExists (logloc) then 
	fso.CreateTextFile (logloc)
end if
set fso = Nothing

Sub addToLog(theInfo, logLocation)
	set fso = CreateObject("Scripting.FileSystemObject")
	set logfile = fso.OpenTextFile(logLocation, 8)
	Logfile.WriteLine(Now()&theInfo)
	Logfile.Close()
	set fso = nothing 
End Sub
%>