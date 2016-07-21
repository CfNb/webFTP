<%
'Begins new session by setting session variable
'used to confirm that cookies are enabled in client browser

session("sessionTime") = Now()

Response.Redirect ("graphics_file_upload_pg1.asp")
%>