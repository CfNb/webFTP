<%
'Begins new session by setting session variable
'used to confirm that cookies are enabled in client browser

session("sessionTime") = Now()

Response.Redirect ("file_upload_pg1.asp")
%>