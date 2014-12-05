    var year = (new Date).getFullYear();
    $(function() {
        $("#fromdate").datepicker({
            dateFormat: 'yy-mm-dd',
            beforeShowDay: $.datepicker.noWeekends,
            defaultDate: "+0d",
            maxDate: new Date(year, 11, 31),
            minDate: "+1d",
            numberOfMonths: 2,
            onClose: function(selectedDate) {
                $("#todate").datepicker("option", "minDate", selectedDate);
            }
        });
    });

    $(function() {
        $("#todate").datepicker({
            dateFormat: 'yy-mm-dd',
            beforeShowDay: $.datepicker.noWeekends,
            defaultDate: "+4d",
            changeMonth: true,
            maxDate: new Date(year, 11, 31),
            numberOfMonths: 2,
            onClose: function(selectedDate) {
                $("#fromdate").datepicker("option", selectedDate);
            }
        });
    });

    $('#leavesubmit').click(function(event) {

        var datereg = /^\d{4}[-]\d{2}[-]\d{2}$/;
        var fromdate = document.getElementById("fromdate").value;
        var todate = document.getElementById("todate").value;
        var leavemessage = document.getElementById("leavemessage").value;
        if (datereg.test(fromdate) == true && datereg.test(todate) == true && leavemessage != "") {
            event.preventDefault();
            $.ajax({
                url: 'dashboard/leaverequesthandler',
                type: 'POST',
                data: {
                    fromdate: fromdate,
                    todate: todate,
                    message: leavemessage
                },
            }).done(function(responseText) {
                $('#leaveapply')[0].reset();
                $.ajax({
                    url: 'dashboard/leavesleft',
                    type: 'POST',
                }).done(function(res) {
                    $("#leaves_left").html(res.TotalPersonalLeaves);
                });

                if (responseText.lstatus == "Success") {
                    $("#ErrorMessage").html("Leave Request is submitted");
                    $("#leaves_left").html(resposeText.apl);
                } else {
                    $("#ErrorMessage").html("Applied leaves is more than available leaves");
                }
            });

        } else {
            event.preventDefault();
            var message = "";
            if (datereg.test(fromdate) == false) {
                message += "*Invalid from date\n";
            }
            if (datereg.test(todate) == false) {
                message += "*Invalid to date\n";
            }
            if (leavemessage == "") {
                message += "*Invalid message\n";
            }
            $("#ErrorMessage").html(message);
            return false;
        }
    });
