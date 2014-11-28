    $(function() {
        $("#doj").datepicker({
            dateFormat: 'yy-mm-dd'
        });
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

        },


        submitHandler: function(form) {
            callme();
        },
    });

    function callme() {
        var fname = document.getElementById("fname").value;
        var lname = document.getElementById("lname").value;
        var email = document.getElementById("email").value;
        var doj = document.getElementById("doj").value;
        var role = document.getElementById("role").value;
        $.ajax({
            url: 'dashboard/newemployee',
            type: 'POST',
            data: {
                fname: fname,
                lname: lname,
                email: email,
                dateofjoining: doj,
                role: role,
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
