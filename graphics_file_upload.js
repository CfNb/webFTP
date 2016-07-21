function fileSelected() {
	  totalSize = 0;
	  var fileNames = "";
	  var fileSize = 0;
	  var delimiter = "";
	  for (i = 0; i < document.getElementById('filesToUpload').files.length; i++) {
		totalSize += document.getElementById('filesToUpload').files[i].size;
		if (document.getElementById('filesToUpload').files.length > 0) {delimiter = '<br/>';} 
		if (i == document.getElementById('filesToUpload').files.length - 1) {delimiter = "";}
		fileNames += document.getElementById('filesToUpload').files[i].name + delimiter;
	  }

	  if (totalSize !== 0) {
		if (totalSize > 1024 * 1024 * 1024) {
		  fileSize = (Math.round(totalSize * 100 / (1024 * 1024 * 1024)) / 100).toString() + 'GB';
		} else if (totalSize > 1024 * 1024) {
		  fileSize = (Math.round(totalSize * 100 / (1024 * 1024)) / 100).toString() + 'MB';
		} else {
		  fileSize = (Math.round(totalSize * 100 / 1024) / 100).toString() + 'KB';
		}
		$('#fileNames').html(fileNames);
		$('#fileSize').html('Total File Size: ' + fileSize);
	  }

	  if (totalSize > 2 * 1024 * 1024 * 1024) {
		$('#message_text').html('<span class="glyphicon glyphicon-alert"></span>Total file size must be less than 2GB.<br/>Please post your files in multiple uploads.');
		$('#message_text').removeClass('alert-info');
		$('#message_text').addClass('alert-danger');
		$("#uploadBtn").prop("disabled", true);
	  } else {
		$('#message_text').html("Press upload to begin transfering files");
		$('#message_text').removeClass('alert-danger');
		$('#message_text').addClass('alert-info');
		$("#uploadBtn").prop("disabled", false);
	  }
	}		
		
function uploadFile() {
	var fd = new FormData();
	for (i = 0; i < document.getElementById('filesToUpload').files.length; i++) {
	  fd.append("fileToUpload", document.getElementById('filesToUpload').files[i]);
	}
	var xhr = new XMLHttpRequest();
	xhr.upload.addEventListener("progress", uploadProgress, false);
	xhr.addEventListener("load", uploadComplete, false);
	xhr.addEventListener("error", uploadFailed, false);
	xhr.addEventListener("abort", uploadCanceled, false);
	xhr.open("POST", "graphics_file_upload_transfer.asp");
	xhr.send(fd);
}

function uploadProgress(evt) {
	if (evt.lengthComputable) {
	  var percentComplete = Math.round(evt.loaded * 100 / evt.total);
	  $('#progressBar').html('<span class="sr-only">' + percentComplete.toString() + '% </span>'); 
	  $('#progressBar').css('width', percentComplete.toString() + '%');
	  $('.modal-title').html("Files Uploading..." + percentComplete.toString() + "%");
	} else {
	  $('#progressBar').html('unable to compute');
	}
}

function uploadComplete(evt) {
/* This event is raised when the server send back a response */
	$('.modal-title').html("Upload Complete!");
	$('#modal-text').html("A confirmation email with the details of this upload has been sent to you.<br/>Our staff will contact you soon.");
	$('#uploadedFiles').html($('#fileNames').html());
	$('#summary').slideDown("slow");
}

function uploadFailed(evt) {
	$('.modal-title').html("Upload Failed");
	$('#modal-text').html("There was an error attempting to upload the file.");
	$('#fail').slideDown("slow");
}

function uploadCanceled(evt) {
	$('.modal-title').html("Upload Interrupted");
	$('#modal-text').html("The upload has been cancelled or the connection was lost.");
	$('#fail').slideDown("slow");
}

function captchaCallback() { // resets warning after user checks recaptcha
  $('#hiddenRecaptcha-error').text('');
}

 $.validator.addMethod("cRequired", $.validator.methods.required, "This field is required");
 $.validator.addClassRules("textRequired", {
   cRequired: true
 });

 $.validator.addMethod("strictEmail", function(value, element) {
   return this.optional(element) || /[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,63}$/.test(value);
 }, "Please enter a valid email address")

 $.validator.addMethod("phoneNum", function(value, element) {
   return this.optional(element) || (/^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/.test(value) || /^\+(?:[0-9] ?){6,14}[0-9]$/.test(value));
 }, "Please enter a valid phone number")

 $(document).ready(function() {
   if ($('#message_text').attr('class') == 'alert alert-danger text-center') {
    $("input").attr("disabled", true);
    $("textarea").attr("disabled", true);
   }
 
   $('.formLabel').css('width', '27%');

   $('#info-form').validate({
     ignore: [],

     rules: {
       phone: {
         required: true,
         phoneNum: true
       },
       email: {
         required: true,
         strictEmail: true
       },
       "hiddenRecaptcha": {
         required: function() {
          if (grecaptcha.getResponse() == '') {
            return true;
          } else {
            return false;
          }
    	  }
    	}
     },

     messages: {
       "hiddenRecaptcha": {
        required: "Please check the box below:"
       }
     },

     highlight: function(element) {
       $(element).closest('.form-group').addClass('has-error has-feedback');
       $(element.form).find("span[id=" + element.id + "Icon]")
         .addClass('glyphicon glyphicon-exclamation-sign form-control-feedback');
       $(element.form).find("label[id=" + element.id + "Label]")
         .addClass('text-danger');

     },

     unhighlight: function(element) {
       $(element).closest('.form-group').removeClass('has-error has-feedback');
       $(element.form).find("span[id=" + element.id + "Icon]")
         .removeClass();
       $(element.form).find("label[id=" + element.id + "Label]")
         .removeClass('text-danger');
     }
   });
 });

