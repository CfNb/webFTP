<% Server.ScriptTimeout = 10800 %>
<!-- #include file="file_upload_log.asp" -->
<%
If IsEmpty(session("captchaResponse")) Or session("captchaResponse")="false" Then
	Response.Redirect ("file_upload_pg1.asp")
End If

Set Upload = Server.CreateObject("Persits.Upload")
Upload.ProgressID = session("sessionPID")

'Email Variables:
SMTP = "172.16.1.38" ' SMTP Server
ReplyAdd = "digitalmail@clddigital.com"

' Recipients that will receive alerts upon a successful submittal.
' Semicolon needed to seperate more than one recipient
strRcpt = "digital@clddigital.com"
	
' Upload directory, This directory must have write permissions by IUSER and IWAM
' Files will be placed here until the upload is complete
uploaddir = "C:\DigitalFTP Folder\TMP\"

'Successful Uploads will be moved here
finaldir = "C:\DigitalFTP Folder\"

'Create upload instance folder
thefolderpath = uploaddir & session("sessionPID")
Dim myFSO
SET myFSO = Server.CreateObject("Scripting.FileSystemObject")
	 myFSO.CreateFolder(thefolderpath)
SET myFSO = NOTHING
	
Call addToLog(session("sessionPID") & " Tmp Folder Created, Upload Started", logloc)
 
'Create instance of upload
Upload.Save thefolderpath
	
Call addToLog(session("sessionPID") & " Upload Completed", logloc)

'Create SubmitInfo.txt file
set fso = CreateObject("Scripting.FileSystemObject")
set WrFile = fso.CreateTextFile(thefolderpath & "\SubmitInfo.txt", true, false)
Wrfile.WriteLine("Name: " & session("sessionName"))
Wrfile.WriteLine("Company: " & session("sessionCompany"))
Wrfile.WriteLine("Phone: " & session("sessionPhone"))
Wrfile.WriteLine("Email: " & session("sessionEmail"))
Wrfile.WriteLine("Project: " & session("sessionProject"))
Wrfile.WriteLine("PID: "& session("sessionPID"))
Wrfile.WriteLine("Notes: ")
Wrfile.WriteLine(session("sessionNotes"))
Wrfile.Close
set fso = nothing

Call addToLog(session("sessionPID") & " SubmitInfo.txt Created", logloc)

'Remove special characters in Company and Project names for file system folder name
theChars = Array(" ", "<", ">", ":", """", "/", "\", "|", "?", "*")
Function replaceChars(theString, theChars, theReplacement)
	For Each x In theChars
		theString = Replace(theString, x, theReplacement)
	Next
	replaceChars=theString
End Function

folderCompany = session("sessionCompany")
folderCompany = replaceChars(folderCompany, theChars, "_")
folderProject = session("sessionProject")
folderProject = replaceChars(folderProject, theChars, "_")

'Rename and move Project folder
todaydate = Right("0" & Month(Now),2) & Right("0" & Day(Now),2) & Year(Now) & "-" & Right("0" & Hour(Now),2) & Right("0" & Minute(Now),2)
oldFolderName = thefolderpath
foldername = todaydate & "-" & folderCompany & "-" & folderProject 'foldername used below
newfolderpath = finaldir & foldername

Dim fso
Set fso = CreateObject("Scripting.FileSystemObject")
  fso.MoveFolder oldFolderName, newfolderpath
Set fso = Nothing

Call addToLog(session("sessionPID") & " Folder Moved and Renamed: " & foldername, logloc)
 
Dim strSend, strBodyFsubmitter, errEmail, strFile, strFilesize, foldername, strBody, strRcpt, strBodyF, strCommon
For Each File in Upload.Files
	strFilesize = File.size / 1000000
	If File.size > (1024 * 1024 * 1024) Then
		strFilesize = Round((File.size * 100 / (1024 * 1024 * 1024)) / 100, 2) & " GB"
	ElseIf File.size > (1024 * 1024) Then
		strFilesize = Round((File.size * 100 / (1024 * 1024)) / 100, 2) & " MB"
	Else
		strFilesize = Round((File.size * 100 / 1024) / 100, 2) & " KB"
	End if
	
	strBodyF = strBodyF & "File Name:    " & File.FileName & chr(13)
	strBodyF = strBodyF & "File Size:    " & strFileSize & chr(13) & chr(13)
	strBodyFsubmitter = strBodyF
next
strBodyF = strBodyF & "Folder:    " & foldername & chr(13)

'Send Email to recipients
Call addToLog(session("sessionPID") & " Start Confirmation Email", logloc)

strCommon = "******************************************************************" & chr(13) & chr(13)
strCommon = strCommon & "Date Submitted: " & Now() & chr(13) & chr(13)
strCommon = strCommon & "Upload Details:" & chr(13)
strCommon = strCommon & "--------------------------------------------"  & chr(13)
strCommon = strCommon & "Submitted by:   " & session("sessionName") & chr(13)
strCommon = strCommon & "Company Name:   " & session("sessionCompany") & chr(13)
strCommon = strCommon & "Phone Number:   " & session("sessionPhone") & chr(13)
strCommon = strCommon & "Sender Email:   " & session("sessionEmail") & chr(13)
strCommon = strCommon & "Project Title:  " & session("sessionProject") & chr(13) & chr(13)
If Len(session("sessionNotes") & "") > 0 Then
	strCommon = strCommon & "Additional Information:" & chr(13)
	strCommon = strCommon & session("sessionNotes") & chr(13) & chr(13) & chr(13)
Else
	strCommon = strCommon & chr(13)
End If
strCommon = strCommon & "File Information:" & chr(13)
strCommon = strCommon & "--------------------------------------------"  & chr(13)
		
strBody = chr(13) & "WebFTP File Submittal for the project: " & session("sessionProject") & chr(13)
strBody = strBody & strCommon
strBody = strBody & strBodyF

Dim objMail
Set objMail = Server.CreateObject("Persits.MailSender")
objMail.Host = SMTP
objMail.From = session("sessionEmail")
objMail.AddAddress strRcpt 
objMail.Subject = "WebFTP file submitted from " & session("sessionCompany") & " for the project: " & session("sessionProject")
objMail.Body = strBody
objMail.Send
Set objMail = Nothing
	
Call addToLog(session("sessionPID") & " Confirmation Sent", logloc)
	
'delay 1 second to ensure 2nd email sends correctly...
set shell = CreateObject("WScript.Shell")
shell.popup "pausing", 1,"pause",64
			
'Send Email to Submitter
Call addToLog(session("sessionPID") & " Start Submitter Confirmation Email", logloc) 

strBody = chr(13) & "CL&D Digital WebFTP File Submittal" & chr(13)
strBody = strBody & strCommon
strBody = strBody & strBodyFsubmitter
		
Set objMail = Server.CreateObject("Persits.MailSender")
objMail.Host = SMTP
objMail.From = ReplyAdd
objMail.AddAddress session("sessionEmail")
objMail.Subject = "CL&D Digital File Upload Successful"
objMail.Body = strBody
objMail.Send
Set objMail = Nothing
		
Call addToLog(session("sessionPID") & " Submitter Confirmation Sent", logloc)
%>
