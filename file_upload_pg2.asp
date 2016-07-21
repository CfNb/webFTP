<% Server.ScriptTimeout = 10800 %>
<html>
<head>
<title>CL&amp;D Digital File Upload</title>
<!-- #include file="file_upload_log.asp" -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<%
If IsEmpty(session("sessionTime")) then 'user should enable cookies
	Response.Redirect ("file_upload_pg1.asp")
end if

session("sessionName")=request.form("Name")
session("sessionCompany")=request.form("Company")
session("sessionPhone")=request.form("Phone")
session("sessionEmail")=request.form("Email")
session("sessionProject")=request.form("Project")
session("sessionNotes")=request.form("Additional_Info")

if not session("sessionCont")="true" then
	Call addToLog(session("sessionPID") & " " & session("sessionName") & " - " & session("sessionCompany") & " - " & session("sessionPhone") & " - " & session("sessionEmail"), logloc)
end if

If IsEmpty(session("captchaResponse")) Or session("captchaResponse")="false" Then 'verify recaptcha
	Dim recaptcha_response, recaptcha_secret, sendstring, objXML
	recaptcha_response = request.form("g-recaptcha-response")
	recaptcha_secret = ""
	sendstring = "https://www.google.com/recaptcha/api/siteverify?secret=" & recaptcha_secret & "&response=" & recaptcha_response
	Set objXML = Server.CreateObject("MSXML2.ServerXMLHTTP")
	objXML.Open "GET", sendstring, False
	objXML.Send
	Call addToLog(session("sessionPID") & " check recaptcha...", logloc)
	captchaResponse = InStr(objXML.responseText,"true,")
	If captchaResponse = "0" then 'captcha failed, go back
		session("captchaResponse")="false"
		Call addToLog(session("sessionPID") & " g-recaptcha-response:" & session("captchaResponse"), logloc)
		Response.Redirect ("file_upload_pg1.asp")
	else 'captcha successful, continue
		session("captchaResponse")="true"
		Call addToLog(session("sessionPID") & " g-recaptcha-response:" & session("captchaResponse"), logloc)
	end if
	Set objXML = Nothing
End If

message = "<div id=""message_text"" class=""alert alert-info text-center"">Review your information and select files to upload</div>"
%>

<!-- bootstrap, JQuery, Plugins, etc. -->
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link href="bootstrap-3.3.4.css" rel="stylesheet" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>


<!-- custom JavaScript-->
<script src="file_upload.js"></script>

</head>

<body>
<div class="panel panel-default" style="background-color: #003399; height: 50px; font-size: large; margin: auto; font-weight: bold; padding-top: 10px">BUILDING BRANDS THROUGH PACKAGING</div>
        <div class="panel-footer" style="background-color: #ff4e00; font-size: medium; margin: auto; font-weight: bold;"></div>
	<div  id="uplaod_app" class="container" style="width:80%">

<div class="h2 text-primary text-center"><img src="images/CL&D_Digital.png" style="margin-bottom: 10px"/>&nbsp;&nbsp;&nbsp;File&nbsp;Upload</div>
	  <div id="message_line">
		<% = message%>
	  </div>
	  
	  <div style="padding-left:15px; padding-right:15px">
	  <div class="well row" >
		<dl class="col-xs-12 col-sm-6">
		  <dt>Name:</dt>
		  <dd>
			<% = session("sessionName")%>
		  </dd>
		  <dt>Company:</dt>
		  <dd>
			<% = session("sessionCompany")%>
		  </dd>
		  <dt>Phone:</dt>
		  <dd>
			<% = session("sessionPhone")%>
		  </dd>
		  <dt>Email:</dt>
		  <dd>
			<% = session("sessionEmail")%>
		  </dd>
		</dl>
		<dl class="col-xs-12 col-sm-6">
		  <dt>Project:</dt>
		  <dd>
			<% = session("sessionProject")%>
		  </dd>
		  <dt>Additional Information:</dt>
		  <dd style="word-wrap:break-word">
			<% = Replace(session("sessionNotes"), vbCrLf, "<br/>")%></dd>
		</dl>
	  </div>
	  </div>
			
	  <form name="MyForm" method="post" enctype="multipart/form-data" role="form">
		<div class="form-group text-center">
		  <label class="sr-only" for="Files">Files to Upload:</label>
		  <input name="Files" type="file" class="form-control-file" id="filesToUpload" onchange="fileSelected();" multiple required style="display: none;" />
		  <input type="button" value="Choose Files" onclick="document.getElementById('filesToUpload').click();" autofocus />
		  <br/><br/>
		  <div>Files Selected:</div>
		  <div id="fileNames" class="text-muted">None</div><br/>
		  <div>Total File Size: <span id="fileSize" class="text-muted">0</span></div>
		  <div class="text-muted small">(Maximum combined file size is 2GB)</div>
		</div>
		<br>
		<div class="row">
		  <div class="col-xs-6">
			<a class="btn btn-primary btn-block" href="file_upload_pg1.asp">
			  <span class="glyphicon glyphicon-circle-arrow-left"></span> Back</a>
		  </div>
		  <div class="col-xs-6">
			<button id="uploadBtn" type="button" class="btn btn-primary btn-block" onclick="uploadFile()" data-toggle="modal" data-target="#myModal" data-backdrop="static" data-keyboard="false" disabled="true">
					Upload <span class="glyphicon glyphicon-circle-arrow-right"></span></button>
		  </div>
		</div>
	  </form>

	  <div id="myModal" class="modal fade" role="dialog">
		<div class="modal-dialog">
		  <!-- Modal content-->
		  <div class="modal-content">
			<div class="modal-header text-center">
			  <h4 class="modal-title">Files Uploading...</h4>
			</div>
			<div class="modal-body">
			  <div class="progress" id="progressContainer">
				<div id="progressBar" class="progress-bar" role="progressbar" aria-valuemin="0" aria-valuemax="100" style="width:0%;"></div>
			  </div>
			  <div id="modal-text" class="text-center">Please wait for your transfer to complete.</div><br/>
			  <div id="summary" style="display:none">
				<div class="well col-xs-offset-1 col-xs-10 text-center">
					<dl><!--
						<dt>Name:</dt>
						<dd>  <% = session("sessionName")%></dd>
						<dt>Company:</dt>
						<dd>  <% = session("sessionCompany")%></dd>
						<dt>Phone:</dt>
						<dd>  <% = session("sessionPhone")%></dd>
						<dt>Email:</dt>
						<dd>  <% = session("sessionEmail")%></dd>
						<dt>Project:</dt>
						<dd>  <% = session("sessionProject")%></dd>
						<dt>Additional Information:</dt>
						<dd style="word-wrap:break-word"><% = Replace(session("sessionNotes"), vbCrLf, "<br>")%></dd>
						<br/>-->
						<dt>Uploaded Files:</dt>
						<dd id="uploadedFiles" style="word-wrap:break-word"></dd>
					</dl>	
				</div>
			    <div class="row">
				  <div class="col-xs-6"><a class="btn btn-default btn-block modalbtn" href="file_upload_pg1.asp"><span class="glyphicon glyphicon-circle-arrow-left"></span> Upload More</a></div>
				  <div class="col-xs-6"><a class="btn btn-default btn-block modalbtn" href="file_upload_redirect.asp">Done <span class="glyphicon glyphicon-ok-circle"></span></a></div>
			    </div>
			  </div>
			  <div id="fail" style="display:none">
			    <div class="row">
				  <div class="col-xs-6"><a class="btn btn-default btn-block modalbtn" href="file_upload_pg1.asp"><span class="glyphicon glyphicon-circle-arrow-left"></span> Back</a></div>
				  <div class="col-xs-6"></div>
			    </div>
			  </div>
			</div>
		  </div>
		</div>
	  </div>

   <div class="panel panel-default" style="border:none"><img src="images/digital_cover.jpg" alt="" width="70%" style="margin: auto"/></div>
<div class="container-fluid" style="margin: auto; height: 75px; text-align:center; padding: 20px"><strong>Oconomowoc Division &amp; Corporate Headquarters</strong> 1101 West Second Street, Oconomowoc, WI 53066&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060&nbsp;&nbsp;Fax: 262.569.4075<hr>
<strong>Hartland One Division &amp; CL&D Digital</strong> 535 Norton Drive, P.O. Box 567&nbsp;Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.369.1730&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 262.369.1734<hr><strong>Hartland Two Division</strong> 510 Cardinal Lane P.O. Box 567 Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060<hr><strong>South East Division </strong> 680 Bryant Boulevard, Rock Hill, SC 29732&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 803.985.7000&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 803.985.7004<br><br><strong>CL&amp;D is <A href="http://www.graphic-measures.com/" target="new">GMI</A> and <A href="http://www.asifood.com/" target="new">GMP</A> Certified&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&copy; 2016 CL&amp;D</strong></div> </div>
</body>
</html>