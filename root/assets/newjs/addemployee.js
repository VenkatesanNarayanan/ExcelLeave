$(function() {

	$("#doj").datepicker({
		dateFormat: 'yy-mm-dd',
		maxDate:0
	});

	$("#div_managerlist").ListPicker({
		height : 130,
		width : 164,
	});

	$.ajax({
		url: 'dashboard/managerlist',
		type: 'POST',
	
	}).done(function(responseText) {
		$('#div_managerlist').ListPicker('option',{optionlist : responseText.managerslist });
	});


	$("#updateemployeeform").validate({
		rules: {
			fname: {
				required: true,
				lettersonly: true
			},
			lname: {
				required: true,
				lettersonly: true
			},
			email: {
				required: true,
				email: true
			},

			doj: {
				required: true,
			},

			role: {
				required: true,
			},
			manager: {
				required: true,
			},
		},
		submitHandler: function(form) {
			callme();
		},
	});

	function callme() {
		var fname = document.getElementById("fname").value;
		var lname = document.getElementById("lname").value;
		var email = document.getElementById("email").value;
		var doj   = document.getElementById("doj").value;
		var role  = document.getElementById("role").value;
		var mid   = new Array;
		$('#list_error').text("");
		var list  = $('#div_managerlist').ListPicker('getchooseditems');
		if(list.length > 0)
		{
			$.each(list, function(index,value){
				mid.push(value);
			});
			$.ajax({
				url: 'dashboard/newemployee',
				type: 'POST',
				data: {
					fname: fname,
					lname: lname,
					email: email,
					dateofjoining: doj,
					role: role,
					managerid: mid,
				},
			}).done(function(responseText) {
				$.ajax({
					url: 'dashboard/updatedetails',
					type: 'POST',
				}).done(function(responseText) {
					$("#maincontent").html(responseText);
				});

			});
		}
		else
		{
			$('#list_error').text("Manager list shoud not be empty");
		}

	}

});


