$('.btn-info').click(function() {
    var cancelrequest = [];
    var lid = $(this).attr('id');
    cancelrequest.push(lid);
    $.ajax({
        url: 'dashboard/leavestatus',
        type: 'POST',
        data: {
            cancelrequest: cancelrequest,
        }
    }).done(function(data) {
        $("#leaves_left").html(data.AvailablePL);
        $('#' + lid + 'status').html('Cancelled');
        $('#' + lid).attr('disabled', 'disabled');
    });
});
