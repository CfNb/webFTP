<% @Language = vbScript %>
<!-- #include file="file_upload_log.asp" -->
<%
' ends session and redirects user to different page
' used with both "Cancel"(before upload) and "Done"(after upload) buttons
' if user does not use these buttons, session will end at after default session timeout 

Call addToLog((session("sessionPID") & " < SESSION ENDED"), logloc)

Response.Redirect ("http://www.clddigital.com/cl-d-digital.html")
Session.Abandon
%>