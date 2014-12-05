		var oTable = $('#LeaveRequest').dataTable({
		    "iDisplayLength": 5,
		});
		var viewbtnid;
		$('#LeaveRequest').delegate('.view_request', 'click', function() {
		    viewbtnid = $(this).attr('id');
		    leavecall();
		});

		var checked = 0;
		var unchecked = 0;
		var eid;
		var bid;

		function leavecall() {
		    $('#denyreq').prop('disabled', false);
		    checked = 0;
		    unchecked = 0;
		    var e = window.event,
		        btn = e.target || e.srcElement;
		    bid = btn.name;
		    $.ajax({
		        url: 'dashboard/viewrequest',
		        type: 'POST',
		        data: {
		            batchid: bid,
		        },
		    }).done(function(res) {
		        var list = "";
		        $.each(res.leavecollection, function(i, x) {
		            eid = x.EmployeeId;
		            $("#Empview").html(x.FirstName + " " + x.LastName);
		            $("#Empmsg").html(x.Message);
		            if (x.LeaveStatus != 'Cancelled') {
		                list += "<tr>";
		                list += "<td class=" + "leavelist" + ">" + x.LeaveDate + "</td>";
		                list += "<td class=" + "leavelist" + ">" + x.LeaveStatus + "</td>";
		                list += "<td class=" + "leavelist" + "><input type=" + "checkbox" + " class=" + "lcheck" + " id=" + x.LeaveId + " onchange=" + "callcheck();" + " checked></td>";
		                list += "</tr>";
		            }
		        });
		        $("#viewreqbody").html();
		        $("#viewreqbody").html(list);
		    });
		    $("#viewreq").modal({
		        "backdrop": "static"
		    });
		}

		function callcheck() {
		    var even = window.event,
		        btn = even.target || even.srcElement;
		    var val1 = btn.id;
		    if ($("#" + val1).is(':checked')) {
		        checked++;
		    } else {
		        unchecked++;
		    }

		    if (checked == unchecked) {
		        $('#denyreq').prop('disabled', false);
		    } else {
		        $('#denyreq').prop('disabled', true);
		    }
		}
		var requestrow;
		$('.request_call').click(function() {
		    requestrow = $(this).attr('id');
		});
		$('.sendreq').click(function() {
		    var acceptreq = [];
		    var denyreq = [];
		    var fillarr = $(this).attr('id');
		    var revfillarray;
		    if (fillarr == 'acceptreq') {
		        revfillarray = 'denyreq';
		    } else {
		        revfillarray = 'acceptreq';
		    }


		    $(".lcheck").each(function() {
		        if ($("#" + $(this).attr('id')).is(':checked')) {
		            if (fillarr == 'acceptreq') {
		                acceptreq.push($(this).attr('id'));
		            } else {
		                denyreq.push($(this).attr('id'));
		            }
		        } else {
		            if (revfillarray == 'acceptreq') {
		                acceptreq.push($(this).attr('id'));
		            } else {
		                denyreq.push($(this).attr('id'));
		            }
		        }

		    });
		    $.ajax({
		        url: 'dashboard/requestview',
		        type: 'POST',
		        data: {
		            employeeid: eid,
		            acceptreq: acceptreq,
		            denyreq: denyreq,
		            batch_id: bid,
		        },
		    }).done(function() {
		        oTable.fnDeleteRow('#' + requestrow);
		    });
		});
