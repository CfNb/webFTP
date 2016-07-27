<% Server.ScriptTimeout = 10800 %>
<html>
<head>
<title>CL&amp;D Graphics File Upload</title>
<!-- #include file="graphics_file_upload_log.asp" -->
<meta name="viewport" content="width=device-width, initial-scale=1">

<%
reCapDiv="<div style=""display: table; margin: 0 auto;"">"
reCapLabel="<label id=""hiddenRecaptcha-error"" class=""error text-danger"" for=""hiddenRecaptcha""></label>"
reCapInput="<input type=""hidden"" class=""hiddenRecaptcha"" name=""hiddenRecaptcha"" id=""hiddenRecaptcha"">"
reCaptcha="<div class=""g-recaptcha"" data-callback=""captchaCallback"" data-sitekey=""""></div></div>"
reCaptchaDiv=reCapDiv & reCapLabel & reCapInput & reCaptcha
reCaptchaScript="<script src=""https://www.google.com/recaptcha/api.js"" async defer></" & "script>"

If IsEmpty(session("sessionTime")) Then
	messageDiv="<div id=""message_text"" class=""alert alert-danger text-center"">"
	messageSpanText="<span class=""glyphicon glyphicon-alert""></span> Cookies must be enabled to use this form<br><br>"
	messageDivEnd="<div class=""row""><div class=""col-xs-offset-3 col-xs-6"">"
	messageButton="<a class=""btn btn-default btn-block btn-danger"" href=""graphics_file_upload.asp""><span class=""glyphicon glyphicon-refresh""></span> Reload</a></div></div></div>"
	message=messageDiv & messageSpanText & messageDivEnd & messageButton
	reCaptchaDiv="<div></div>" 'don't load recaptcha
	reCaptchaScript=""
Else
	message="<div id=""message_text"" class=""alert alert-info text-center"">Please enter your information.</div>"
End if

If not IsEmpty(session("sessionPID")) Then 'continued session
	Call addToLog((session("sessionPID") & " Returned to form entry page"), logloc)
	session("sessionCont")="true"
	If not IsEmpty(session("captchaResponse")) Then 'verification was attempted
		If session("captchaResponse")="true" Then
			reCaptchaDiv="<div></div>" 'don't load recaptcha
			reCaptchaScript=""
		End if
	End If
	message="<div  id=""message_text"" class=""alert alert-info text-center"">Update your information as needed.</div>"
Else 'new session
	Set UploadProgress = Server.CreateObject("Persits.UploadProgress")
	session("sessionPID")=UploadProgress.CreateProgressID()
	Call addToLog((session("sessionPID") & " NEW SESSION > " & request.servervariables("HTTP_USER_AGENT")), logloc)
End If
%>

<noscript><!-- javascript must be enabled! -->
	<meta http-equiv="refresh" content="0;url=graphics_file_upload_noscript.asp">
</noscript>

<!-- bootstrap, JQuery, Plugins, etc. -->
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
<link href="bootstrap-3.3.4.css" rel="stylesheet" type="text/css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.2/jquery.min.js"></script>
<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
<script src="http://cdn.jsdelivr.net/jquery.validation/1.15.0/jquery.validate.min.js"></script>
<script src="http://cdn.jsdelivr.net/jquery.validation/1.15.0/additional-methods.min.js"></script>

<!-- custom JavaScript-->
<script src="graphics_file_upload.js"></script>

<% = reCaptchaScript%>
</head>

<body>
      <div class="panel panel-default" style="background-color: #003399; height: 50px; font-size: large; margin: auto; font-weight: bold; padding-top: 10px">BUILDING BRANDS THROUGH PACKAGING</div>
        <div class="panel-footer" style="background-color: #abc37f; font-size: medium; margin: auto; font-weight: bold;"></div>
	<div id="uplaod_app" class="container" style="width:80%">
      <div class="h2 text-primary text-center">
      	<img src="images/CL&D_graphics.png" style="margin-bottom: 10px"/>&nbsp;&nbsp;&nbsp;&nbsp;File&nbsp;Upload
      </div>
	  <div id="message_line">
		<% = message%>
	  </div>
	
	  <form id="info-form" method="post" autocomplete="on" action="graphics_file_upload_pg2.asp" role="form">
	    <div class="row">
		  <div class="col-xs-12 col-sm-6">
			<div class="form-group">
			  <label id="nameLabel" for="name" class="formLabel">Name:</label>
			  <label id="name-error" class="error text-muted small" for="name"></label>
			  <input id="name" name="name" class="form-control input-sm textRequired" type="text" tabindex="1" value="<% = session("sessionName")%>" autofocus>
			  <span id="nameIcon"></span>
			</div>
			<div class="form-group">
			  <label id="companyLabel" for="company" class="formLabel">Company:</label>
			  <label id="company-error" class="error text-muted small" for="company"></label>
			  <input id="company" name="company" class="form-control input-sm textRequired" type="text" tabindex="2" value="<% = session("sessionCompany")%>">
			  <span id="companyIcon"></span>
			</div>
			<div class="form-group">
			  <label id="phoneLabel" for="phone" class="formLabel">Phone:</label>
			  <label id="phone-error" class="error text-muted small" for="phone"></label>
			  <input id="phone" name="phone" class="form-control input-sm" type="text" tabindex="3" value="<% = session("sessionPhone")%>">
			  <span id="phoneIcon"></span>
			</div>
			<div class="form-group">
			  <label id="emailLabel" for="email" class="formLabel">Email:</label>
			  <label id="email-error" class="error text-muted small" for="email"></label>
			  <input id="email" name="email" class="form-control input-sm" type="text" tabindex="4" value="<% = session("sessionEmail")%>">
			  <span id="emailIcon"></span>
			</div>
		  </div>
		  <div class="col-xs-12 col-sm-6">
			<div class="form-group">
			  <label id="projectLabel" for="project" class="formLabel">Project:</label>
			  <label id="project-error" class="error text-muted small" for="project"></label>
			  <input id="project" name="project" class="form-control input-sm textRequired" type="text" tabindex="5" value="<% = session("sessionProject")%>">
			  <span id="projectIcon"></span>
			</div>
			<div class="form-group">
			  <label for="Additional_Info">Additional Information (optional):</label>
			  <textarea name="Additional_Info" class="form-control input-sm" rows="5" tabindex="6"><% = session("sessionNotes")%></textarea>
			</div>	  
			<div class="form-group">
				<% = reCaptchaDiv%>
			</div>
		  </div>
		</div>
		<br><br>
		<div class="row">
		  <div class="col-xs-6">
			<a class="btn btn-primary btn-block" href="graphics_file_upload_redirect.asp"><span class="glyphicon glyphicon-remove-circle"></span> Cancel</a>
		  </div>
		  <div class="col-xs-6">
		    <button id="contBtn" TYPE=SUBMIT class="btn btn-primary btn-block">Continue <span class="glyphicon glyphicon-circle-arrow-right"></span>
			</button>
		  </div>
		</div>
	  </form>
      <div class="panel panel-default" style="border:none"><img src="images/graphics_cover.jpg" alt="" width="70%" style="margin: auto"/></div>
<div class="container-fluid" style="margin: auto; height: 75px; text-align:center; padding: 20px"><strong>Oconomowoc Division &amp; Corporate Headquarters</strong> 1101 West Second Street, Oconomowoc, WI 53066&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060&nbsp;&nbsp;Fax: 262.569.4075<hr>
<strong>Hartland One Division &amp; CL&D Digital</strong> 535 Norton Drive, P.O. Box 567&nbsp;Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.369.1730&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 262.369.1734<hr><strong>Hartland Two Division</strong> 510 Cardinal Lane P.O. Box 567 Hartland, WI 53029&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 262.569.4060<hr><strong>South East Division </strong> 680 Bryant Boulevard, Rock Hill, SC 29732&nbsp;&nbsp;|&nbsp;&nbsp;Phone: 800.777.1114&nbsp;&nbsp;|&nbsp;&nbsp;Direct: 803.985.7000&nbsp;&nbsp;|&nbsp;&nbsp;Fax: 803.985.7004<br><br><strong>CL&amp;D is <A href="http://www.graphic-measures.com/" target="new">GMI</A> and <A href="http://www.asifood.com/" target="new">GMP</A> Certified&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&copy; 2016 CL&amp;D</strong></div> </div>
</body>
</html>
