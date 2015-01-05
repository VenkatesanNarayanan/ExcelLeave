$('#changepassword').on('hide.bs.modal', function() {
	var validator = $("#ChangePasswordForm").validate();
	validator.resetForm();
});        


$('input').focus(function() {
	$('#PasswordChangeError').html("");
});

$(function()
{
	$("#ChangePasswordForm").validate({
		rules: {

			oldpassword: {
				required: true,
				minlength: 6
			},
			newpassword: {
				required: true,
				minlength: 6
			},
			reenter: {
				required: true,
				equalTo: "#newpassword"
			}
		},
		submitHandler: function(form) {
			changepassword();		
		},
	});
});

Display();

function Display() {
	$("#datepicker").datepicker();
}

$(document).ready(function() {
	function DisableBackButton() {
		window.history.forward()
	}
	DisableBackButton();
	window.onload = DisableBackButton;
	window.onpageshow = function(evt) {
		if (evt.persisted) DisableBackButton()
	}
	window.onunload = function() {
		void(0)
	}
	$("#home").addClass("active");
	var id = "home";
	var current = "#home";

	$.ajax({
		url: '/dashboard/home',
		type: 'POST',
	}).done(function(responseText) {
		$("#maincontent").html(responseText);
	});

	$(".menubar").click(function() {
		id = $(this).attr('id');
		var path = "/dashboard/" + id;
		$.ajax({
			url: path,
			type: 'POST',
		}).done(function(responseText) {
			$("#maincontent").html(responseText);
		});

		id = '#' + id;
		$(current).removeClass("active");
		$(id).addClass("active");
		current = id;

	});
});

function changepassword() {
	var oldpassword = document.getElementById("oldpassword").value;
	var newpassword = document.getElementById("newpassword").value;
	var reentered = document.getElementById("reenter").value;
	$.ajax({
		url: 'dashboard/changepassword',
		data: {
			status: "existing",
			oldpassword: oldpassword,
			newpassword: newpassword
		},
	}).done(function(responseText) {
		console.log(responseText);
		if (responseText.PasswordStatus == "Success") {
			$('#changepassword').modal('hide');
			$('body').removeClass('modal-open');
			$('.modal-backdrop').remove();
			$('#ChangePasswordForm')[0].reset();
			$("#PasswordChangeError").html("");
		} else {
			$("#PasswordChangeError").html("*incorrect old password");
			$('#ChangePasswordForm')[0].reset();
		}
	});
}

$('#logout').click(function() {
	$.ajax({
		url: 'dashboard/logout',
		type: 'POST',
	});
});
