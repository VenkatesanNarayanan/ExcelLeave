$(function() {
	$("#doj").datepicker({
		dateFormat: 'yy-mm-dd'
	});

	$("#div_managerlist").ListPicker({
		height : 130,
		width : 164,
	}); 

	getmanagerlist();

});

function getmanagerlist()
{
	var empid = $('#employeeid').val();
	$.ajax({
		url: 'dashboard/managerlist',
		type: 'POST',
		data: { employeeid : empid}, 

	}).done(function(responseText) {
		$('#div_managerlist').ListPicker('option',{optionlist : responseText.managerslist }); 
		
		console.log(responseText.managersselected);
		$('#div_managerlist').ListPicker('option',{selectedlist : responseText.managersselected }); 
	}); 
}

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
		status: {
			required: true,
		},
		manager: {
			required: true,
		}

	},


	submitHandler: function(form) {
		callme();
	},
});

$('#btn_back').click(function()
{
	$.ajax({
		url: 'dashboard/updatedetailsform',
		type: 'POST',
	}).done(function(responseText) {
		$.ajax({
			url: 'dashboard/updatedetails',
		}).done(function(responseText) {
			$("#maincontent").html(responseText);
		});
	}
	)
});

function callme() {
	var employeeid = document.getElementById("employeeid").value;
	var fname = document.getElementById("fname").value;
	var lname = document.getElementById("lname").value;
	var email = document.getElementById("email").value;
	var doj = document.getElementById("doj").value;
	var role = document.getElementById("role").value;
	var status = document.getElementById("status").value;
	var mid =  new Array;
	$('#list_error').text("");
	var list  = $('#div_managerlist').ListPicker('getchooseditems');
	if(list.length > 0)
	{
/*	$.each(list, function(index,value){
		mid.push(value);
	}); */

	$.ajax({
		url: 'dashboard/employeeupdate',
		type: 'POST',
		data: {
			employeeid: employeeid,
			fname: fname,
			lname: lname,
			email: email,
			dateofjoining: doj,
			role: role,
			status: status,
			managerid: list,
		},
	}).done(function(responseText) {
		$.ajax({
			url: 'dashboard/updatedetails',

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
