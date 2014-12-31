    $('#example').dataTable({
        "iDisplayLength": 5,
		  "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 6 ] } ] 
    });
	var viewbtnid;
	$('#example').delegate('.empdetails', 'click', function() {
		viewbtnid = $(this).attr('id');
		updateemployee();
	});
	function updateemployee() {
		$.ajax({
			url: 'dashboard/updatedetailsform',
			data: {
				employeeid: viewbtnid,
			}
		}).done(function(responseText) {
			$("#maincontent").html(responseText);
		});

	};

	function AddNewEmp() {
		$.ajax({
			url: 'dashboard/addemployee',
		}).done(function(responseText) {
			$("#maincontent").html(responseText);
		});

	}
