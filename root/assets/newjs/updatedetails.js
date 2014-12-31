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
        var employee = [];
        var counter = 0;
        $('#'+viewbtnid).find("td").each(function() {
            employee[counter++] = $(this).html();
        });
        $.ajax({
            url: 'dashboard/updatedetailsform',
            data: {
                employeeid: employee[0],
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
