(function($, W, D)

{
	var validator = {};
	validator.call = {
		setupFormValidation: function() {
			$("#register-form").validate({
				rules: {
					email: {
						required: true,
						email: true
					},
					password: {
						required: true,
						minlength: 5
					},
				},
				messages: {
					password: {
						required: "Please provide a password",
						minlength: "Your password must be at least 5 characters long"
					},
					email: "Please enter a valid email address",
				},
				submitHandler: function(form) {
					form.submit();
				}
			});

			$("#ForgotPassword").validate({
				rules: {
					email: {
						required: true,
						email: true
					},
				},
				messages: {
					email: "Please enter a valid email address",
				},
				submitHandler: function(form) {
					$.ajax({
						url: 'login/forgotpassword',
						type: 'POST',
						data: {
							email: $('.form-control').val(),
						}
					}).done(function(data) {
						if (data.message == 'Success') {
							$('#myModal').modal('hide');
							$('.modal-backdrop').remove();
							$('#ForgotPassword')[0].reset();

						} else {
							$('#fpw').show();
						}
					});
				}

			});








		}

	}





	$(D).ready(function($) {
		$("input").focus(function() {
			$('#error').hide();
		});

		$("input").focus(function() {
			$('#fpw').hide();
		});
		validator.call.setupFormValidation();

	});



})(jQuery, window, document);
