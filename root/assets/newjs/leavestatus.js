	var oTable = $('#LeaveStatus').dataTable({
	    "iDisplayLength": 5,
		  "aoColumnDefs": [ { "bSortable": false, "aTargets": [ 4] } ] 
	});
	var viewbtnid;
	$('#LeaveStatus').delegate('.view_request', 'click', function(e) {
	    viewbtnid = $(this).attr('id');
	    leavecall(e);
	});

	var TotalRows;
	var CancelledRows;
	var bid;

	function leavecall(e) {
		TotalRows = 0;
		CancelledRows = 0;
		btn = e.target || e.srcElement;
		bid = btn.name;
		$.ajax({
			url: 'dashboard/LeaveStatusHandle',
			type: 'POST',
			data: {
				batchid: bid
			},
			success:function(res) {
				console.log(res);
				var list = "";
				if (res) {
					$.each(res.leavecollection, function(i, x) {
						$("#Empview").html(x.FirstName + " " + x.LastName);
						$("#Empmsg").html(x.Message);
						TotalRows++;
						list += "<tr>";
						list += '<td class="leavelist">' + x.LeaveDate + '</td>';
						list += '<td class="leavelist">' + x.LeaveStatus + '</td>';
						if (x.LeaveStatus == 'Cancelled' || x.LeaveStatus == 'Denied' || x.Status < 0) {
							list += '<td class="leavelist"><input disabled type="checkbox" class="lcheck" id="' + x.LeaveId + '" onchange="callcheck();"></td>';
							CancelledRows++;
						} else {
							list += '<td class="leavelist"><input type="checkbox" class="lcheck" id="' + x.LeaveId + '" onchange="callcheck();" checked></td>';
						}
						list += "</tr>";
					});
				}
				$("#viewreqbody").html(list);

				if (TotalRows == CancelledRows) {
					$('#cancelselected').prop('disabled', true);
				} else {
					$('#cancelselected').prop('disabled', false);
				}

				$("#viewreq").modal({
					"backdrop": "static"
				});
			},
			error : function(data){
				alert("Hello");
			}
		});
		}


	function callcheck() {
	    var even = window.event,
	        btn = even.target || even.srcElement;
	    var val1 = btn.id;
	    if ($("#" + val1).is(':checked')) {
	        CancelledRows--;
	    } else {
	        CancelledRows++;
	    }

	    if (TotalRows == CancelledRows) {
	        $('#cancelselected').prop('disabled', true);
	    } else {
	        $('#cancelselected').prop('disabled', false);
	    }
	}

	$('.cancelreq').click(function() {
	    var cancelrequest = [];
	    $('.lcheck').each(function() {
	        var checkboxid = $(this).attr('id');
	        if ($('#' + checkboxid).is(':checked')) {
	            cancelrequest.push(checkboxid);
	        }

	    });
	    $.ajax({
	        url: 'dashboard/leavestatus',
	        type: 'POST',
	        data: {
	            cancelrequest: cancelrequest,
	            bid: bid
	        }
	    }).done(function(data) {
	        $("#leaves_left").html(data.AvailablePL);
	    });
	});
