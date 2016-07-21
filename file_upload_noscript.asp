<% Server.ScriptTimeout = 10800 %>
<html>
<head>
<title>CL&amp;D Digital File Upload</title>
<!-- #include file="file_upload_log.asp" -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<!-- bootstrap, JQuery, etc. -->
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link href="bootstrap-3.3.4.css" rel="stylesheet" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>


<%
Call addToLog((session("sessionPID") & " No Javascript in Browser"), logloc)

messageDiv="<div id=""message_text"" class=""alert alert-danger text-center"">"
	messageSpanText="<span class=""glyphicon glyphicon-alert""></span> Javascript must be enabled to upload files.<br><br>"
	messageDivEnd="<div class=""row""><div class=""col-xs-offset-3 col-xs-6"">"
	messageButton="<a class=""btn btn-default btn-block btn-danger"" href=""file_upload_pg1.asp""><span class=""glyphicon glyphicon-refresh""></span> Reload</a></div></div></div>"
	message=messageDiv & messageSpanText & messageDivEnd & messageButton
%>

</head>

<body>
      <div class="panel panel-default" style="background-color: #003399; height: 50px; font-size: large; margin: auto; font-weight: bold; padding-top: 10px">BUILDING BRANDS THROUGH PACKAGING</div>
        <div class="panel-footer" style="background-color: #ff4e00; font-size: medium; margin: auto; font-weight: bold;"></div>
	<div id="uplaod_app" class="container" style="width:80%">

<div class="h2 text-primary text-center"><img src="images/CL&D_Digital.png" style="margin-bottom: 10px"/>&nbsp;&nbsp;&nbsp;File&nbsp;Upload</div>
	  <div id="message_line">
		<% = message%>
	  </div>
	
	 
<div class="panel panel-default" style="border:none"><img src="images/digital_cover.jpg" alt="" width="70%" style="margin: auto"/></div>
<div class="container-fluid" style="margin: auto; height: 75px; text-align:center; padding: 20px"><strong>Oconomowoc Division &amp; Corporate Headquarters</strong> 1101 West Second Street, Oconomowoc, WI 53066&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060&nbsp;&nbsp;Fax: 262.569.4075<hr>
<strong>Hartland One Division &amp; CL&D Digital</strong> 535 Norton Drive, P.O. Box 567&nbsp;Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.369.1730&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 262.369.1734<hr><strong>Hartland Two Division</strong> 510 Cardinal Lane P.O. Box 567 Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060<hr><strong>South East Division </strong> 680 Bryant Boulevard, Rock Hill, SC 29732&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 803.985.7000&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 803.985.7004<br><br><strong>CL&amp;D is <A href="http://www.graphic-measures.com/" target="new">GMI</A> and <A href="http://www.asifood.com/" target="new">GMP</A> Certified&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&copy; 2016 CL&amp;D</strong></div> </div>
</body>
</html>