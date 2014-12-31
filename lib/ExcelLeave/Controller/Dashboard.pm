package ExcelLeave::Controller::Dashboard;
use Moose;
use Data::Dumper;
use DateTime;
use Digest::MD5;
use JSON;
use Session::Token;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);
use Date::Simple;
BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLeave::Controller::dashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub CurrentDate : Local
{

    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    return $current_date->ymd();
}

sub EncryptPassword
{
    my ($normalpassword) = @_;
    my $ctx = Digest::MD5->new;
    $ctx->add($normalpassword);
    my $encryptedpassword = $ctx->hexdigest;
    return $encryptedpassword;
}

sub ExcelLeaveMailing : Local
{
	my($self,$c);
    if (scalar(@_) > 4) {
        $self = shift(@_);
        $c = shift(@_);
    }
    my ($contenttype,$fromeid, $toeid, $esubject, $content) = @_;
    my $message = Email::MIME->create(
        header_str => [
            From    => $fromeid,
            To      => $toeid,
            Subject => $esubject,

        ],
        attributes => {
            encoding => 'quoted-printable',
            charset  => 'ISO-8859-1',
        },
        body_str => $content,
    );
	$message->content_type_set($contenttype);
    sendmail($message);
}

sub index : Path
{
	my ($self, $c) = @_;

	if ($c->user) {
		my $employeeid = $c->user->EmployeeId;
		my $username   = $c->user->FirstName; 
		$c->stash->{ProfileDetails} = $c->model('Leave::Employee')->search({EmployeeId => $employeeid});

		my @allemployee = $c->model('Leave::Employee')->search(
			{EmployeeId => $employeeid},
			{
				join      => 'role',
				'+select' => ["role.RoleName"],
				'+as'     => ["RoleName"],
			}
		);
		foreach (@allemployee) {
			$c->stash->{Role} = $_->get_column('RoleName');
		}

		$c->stash->{uname} = $username;

		my @holidaylist = $c->model('Leave::OfficialHolidays')->search({});
		my $count       = 1;
		push(
			@{$c->stash->{holidayslist}},
			{
				Count           => $count++,
				HolidayDate     => $_->HolidayDate,
				HolidayOccasion => $_->HolidayOccasion,
			}
		) foreach @holidaylist;

		my @empcollection = $c->model('Leave::LeaveRequest')->search({EmployeeId => $employeeid});

		my $counter = 1;
		push(
			@{$c->stash->{leavelist}},
			{
				Counter     => $counter++,
				LeaveId     => $_->LeaveId,
				LeaveDate   => $_->LeaveDate,
				LeaveStatus => $_->LeaveStatus,
			}
		) foreach @empcollection;

		my @totalleaves = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
		foreach my $var (@totalleaves) {
			$c->stash->{TotalPersonalLeaves} = $var->AvailablePersonalLeaves;
		}
		my @priorleaves = $c->model('Leave::SystemConfig')->search({ConfigKey => 'LeaveRequestPrior'});
		foreach my $var (@priorleaves) {
			$c->stash->{LeaveRequestPrior} = $var->ConfigValue;
		}
		$c->forward('View::TT');
	}
	else
	{
		$c->res->redirect( "/login" );
	}

}

sub leaverequest : Local
{
    my ($self, $c) = @_;
 	my $employeeid=$c->user->EmployeeId;
	my $leavehash;
	
	my @leavecollectionhash = $c->model('Leave::LeaveRequest')->search({
		-and =>[
				EmployeeId => $employeeid,
						],
		});
	
	my $string="";
	foreach(@leavecollectionhash)
	{
		if(exists $leavehash->{$employeeid}->{$_->LeaveDate})
		{
		$string .= $leavehash->{$employeeid}->{$_->LeaveDate};
		}
		else
		{
			$leavehash->{$employeeid}->{$_->LeaveDate}=$_->LeaveStatus;
		}
	}
	print Dumper $string;
    print Dumper $leavehash;

   $c->forward('View::TT');
}

sub leaverequesthandler : Local
{
    my ($self, $c) = @_;
    my $user = $c->user->FirstName;
    my ($ManagerEmailId, $ManagerName);
    my $employeeid = $c->user->EmployeeId;

    my @empl = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
    my $apl;

	my @fromdate = split('-', $c->req->params->{fromdate});
    my @todate   = split('-', $c->req->params->{todate});
    my $start = DateTime->new(year => $fromdate[0], month => $fromdate[1], day => $fromdate[2]);
    my $end   = DateTime->new(year => $todate[0],   month => $todate[1],   day => $todate[2]);
    my %offcialsholidays;
    my @collected     = $c->model('Leave::OfficialHolidays')->search({});
    my $requesteddays = 0;
    foreach my $var (@collected) {
        $offcialsholidays{$var->HolidayDate} = "";
    }

    foreach (@empl) {
        $apl = $_->AvailablePersonalLeaves;
    }

    while ($start <= $end) {
        unless (exists $offcialsholidays{$start->ymd}) {
            if ($start->day_of_week <= 5) {
                $requesteddays++;
            }
        }
        $start->add(days => 1);
    }

    if ($requesteddays <= $apl) {
        $start = DateTime->new(year => $fromdate[0], month => $fromdate[1], day => $fromdate[2]);
        my @batchcollection = $c->model('Leave::LeaveRequestBatch')->search({});

        my @arr = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

        my $flag    = 0;
        my $batchid = "";
        while ($flag == 0) {
            $batchid = "";
            for my $var (0 .. 16) {
                $batchid .= $arr[int rand(25)];
            }

            foreach my $var (@batchcollection) {
                if ($var->BatchId eq $batchid) {
                    $flag = 1;
                    last;
                }
            }
            if ($flag == 0) {
                $c->model('Leave::LeaveRequestBatch')->create(
                    {
                        BatchId   => $batchid,
                        FromDate  => $c->req->params->{fromdate},
                        ToDate    => $c->req->params->{todate},
                        Message   => $c->req->params->{message},
                        CreatedBy => $employeeid,
                        CreatedOn => CurrentDate(),
                    }
                );
                last;
            }
            else {
                $flag = 0;
            }
        }

        while ($start <= $end) {
            unless (exists $offcialsholidays{$start->ymd}) {
                if ($start->day_of_week <= 5) {
                    $c->model('Leave::LeaveRequest')->create(
                        {
                            EmployeeId => $employeeid,
                            BatchId    => $batchid,
                            LeaveDate  => $start->ymd,
                            CreatedBy  => $employeeid,
                            CreatedOn  => CurrentDate(),
                        }
                    );
                }
            }
            $start->add(days => 1);
        }

        $apl = $apl - $requesteddays;

        my $empleave = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
        $empleave->update(
            {
                AvailablePersonalLeaves => $apl,
                UpdatedBy               => $employeeid,
                UpdatedOn               => CurrentDate(),
            }
        );

        $c->stash->{apl} = $apl;

        my @EmpManager = $c->model('Leave::EmployeeManager')->search({EmployeeId => $employeeid});
        my $ManagerId;
        foreach (@EmpManager) {
            $ManagerId = $_->ManagerEmployeeId;
        }

        my @ManagerDetail = $c->model('Leave::Employee')->search({EmployeeId => $ManagerId});
        foreach (@ManagerDetail) {
            $ManagerEmailId = $_->Email;
            $ManagerName    = $_->FirstName;
        }

        my $esubject = "Leave request login to ExcelLeave System !!";
        my $content  = "Hai "
          . $ManagerName
          . ",\n\n\t"
          . $user
          . " have applied for leave From "
          . $c->req->params->{fromdate} . " To "
          . $c->req->params->{todate}
          . "\n\tWith reason : "
          . $c->req->params->{message}
          . "\n\nRegards,\n..................\nExcelLeave System,\nExceleron Software (India).";

        ExcelLeaveMailing('ExcelLeave@exceleron.com', $ManagerEmailId, $esubject, $content);
        $c->stash->{lstatus} = "Success";
    }
    else {
        $c->stash->{lstatus} = "Invalid";
    }

    $c->forward('View::JSON');
}

sub home : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;
    my @colors     = qw/#8B3A3A#FFDAB9 #000000 #708090 #6495ED #0000CD #8B8682 #B452CD #8F8F8F #9B30FF #E3E3E3 #2E8B57 #00FF00 #FFD700 #CD5C5C #B22222 #FF4500 #FF00FF #8B5742 #8B5A00/;
    my @leaveslist = $c->model('Leave::LeaveRequest')->search(
        {},
        {
            columns  => [qw/EmployeeId/],
            distinct => 1,
        }
    );
    my @leaveapplied;
    push(@leaveapplied, $_->EmployeeId) foreach @leaveslist;
    my $calendar   = [];
    my $colorcount = 0;

    foreach my $lid (@leaveapplied) {

        my @leavelist = $c->model('Leave::LeaveRequest')->search(
            {
                'me.EmployeeId'  => $lid,
                'me.LeaveStatus' => 'Approved',
            },
            {
                join      => [qw/employee batch/],
                '+select' => [qw/employee.FirstName employee.LastName batch.FromDate batch.ToDate/],
                '+as'     => [qw/FirstName LastName FromDate ToDate/],
                columns   => [qw/employee.FirstName employee.LastName batch.FromDate batch.ToDate/],
                distinct  => 1,
            }
        );
        my $leavedisplay = [];
        foreach (@leavelist) {
            my $date;
            my @datearray = split('-', $_->get_column('ToDate'));
            $date = DateTime->new(day => $datearray[2], year => $datearray[0], month => $datearray[1]);
            $date->add(days => 1);

            push(
                @{$leavedisplay},
                {
                    start => $_->get_column('FromDate'),
                    end   => $date->ymd,
                    title => $_->get_column('FirstName'),
                }
            );
        }
        push(@{$calendar}, {events => $leavedisplay, color => $colors[$colorcount++]});
        $leavedisplay = [];
    }

    my @OfficialHolidays = $c->model('Leave::OfficialHolidays')->search({});
    push(
        @{$c->stash->{leaveslist}},
        {
            start => $_->HolidayDate,
            title => $_->HolidayOccasion,
        }
    ) foreach @OfficialHolidays;

    push(@{$calendar}, {events => $c->stash->{leaveslist}, color => 'red'});
    $c->stash->{messages} = JSON->new->utf8->encode($calendar);
    $c->forward('View::TT');
}

sub changepassword : Local
{
    my ($self, $c) = @_;
    my $user;
    my $myencryptedpassword = EncryptPassword($c->req->params->{newpassword});
    if ($c->req->params->{status} eq "new") {
        $user = $c->model('Leave::Employee')->search({Token => $c->req->params->{token}});

        $user->update(
            {
                Status    => 'Active',
                Password  => $myencryptedpassword,
                UpdatedOn => CurrentDate(),
            }
        );
        $c->stash->{PasswordStatus} = "Success";
        print Dumper $user;
        $c->res->redirect($c->uri_for_action('login/index'));
    }
    else {
        my $employeeid      = $c->user->EmployeeId;
        my $currentpassword = $c->user->Password;
        $user = $c->model('Leave::Employee')->search({EmployeeId => $employeeid});
        my $encryptedoldpassword = EncryptPassword($c->req->params->{oldpassword});
        if ($encryptedoldpassword eq $currentpassword) {
            my $tokencheck = $user->update(
                {
                    Password  => $myencryptedpassword,
                    UpdatedBy => $employeeid,
                    UpdatedOn => CurrentDate(),
                }
            );
            $c->stash->{PasswordStatus} = "Success";
        }
        else {
            $c->stash->{PasswordStatus} = "fail";
        }
    }
    $c->forward('View::JSON');
}

sub updatedetails : Local
{

    my ($self, $c) = @_;

    my @collected = $c->model('Leave::Employee')->search(
        {},
        {
            join      => 'role',
            '+select' => ["role.RoleName"],
            '+as'     => ["RoleName"],
        }
    );

    push(
        @{$c->stash->{details}},
        {
            EmployeeId    => $_->EmployeeId,
            FirstName     => $_->FirstName,
            LastName      => $_->LastName,
            RoleName      => $_->get_column('RoleName'),
            DateOfJoining => $_->DateOfJoining,
            Email         => $_->Email,
        }
    ) foreach @collected;

    $c->forward('View::TT');

}

sub newemployee : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;
    my $email      = $c->user->Email;

    my $Token = Session::Token->new->get;

    my @chars = ("A" .. "Z", "a" .. "z", '1' .. '9');
    my $RandomPassword;
    $RandomPassword .= $chars[rand @chars] for 1 .. 6;

    my $ctx = Digest::MD5->new;
    $ctx->add($RandomPassword);
    my $EncryptedPassword = $ctx->hexdigest;

    my @roles = $c->model('Leave::Role')->search({RoleName => $c->req->params->{role}});
    my $RoleId;
    foreach (@roles) {
        $RoleId = $_->RoleId;
    }

    my @respdata = $c->model('Leave::Employee')->create(
        {

            FirstName     => $c->req->params->{fname},
            LastName      => $c->req->params->{lname},
            DateOfJoining => $c->req->params->{dateofjoining},
            RoleId        => $RoleId,
            Email         => $c->req->params->{email},
            Password      => $EncryptedPassword,
            Token         => $Token,
            CreatedBy     => $employeeid,
            CreatedOn     => CurrentDate(),

        }
    );

    my $eid = $c->model('Leave::Employee')->search(
        {
            Email => $c->req->params->{email},
        },
        {
            columns => [qw/EmployeeId/],
        }
    );

    my $empid = $eid->next;

    $c->model('Leave::EmployeeManager')->create(
        {
            EmployeeId        => $empid->EmployeeId,
            ManagerEmployeeId => $c->req->params->{managerid},
            CreatedBy         => $employeeid,
            CreatedOn         => CurrentDate(),
        }
    );

    my $esubject = "Activate yourself to ExcelLeave System !!";
    my $content  = "Hi "
      . $c->req->params->{fname}
	  #     . ",\n\n\tClick on following link to activate your account in ExcelLeave System.\n\n\tlogin/"
       .',<br> <p>  We are happy to inform that your account has been created in ExcelLeave System<p><a href="http://10.10.10.46:3000/login/'
	  . $Token

	  . '"> <button> Click me </button></a>'
	  . "<br><br>\n\nThank You,<br>ExcelLeave System,\n<br>Exceleron Software (India).";



	    my $contenttype = 'text/html';
	my @args =	( $contenttype,'ExcelLeave@exceleron.com', $c->req->params->{email}, $esubject, $content);
	$c->forward('ExcelLeaveMailing', \@args);
	#ExcelLeaveMailing( $contenttype,'ExcelLeave@exceleron.com', $c->req->params->{email}, $esubject, $content);

    my @totalleaves = $c->model('Leave::SystemConfig')->search({ConfigKey => 'TotalPersonalLeaves'});
    foreach my $var (@totalleaves) {
        $c->stash->{TotalPersonalLeaves} = $var->ConfigValue;
    }

    my $ltime = localtime();
    my @larr = split(" ", $ltime);

    my @employeelist = $c->model('Leave::Employee')->search({Email => $c->req->params->{email}});

    foreach (@employeelist) {
	my $pl;
        my @doj = split("-", $_->DateOfJoining);
	my $current_year = DateTime->now(time_zone => 'Asia/Kolkata')->year();
	if ($doj[0] < $current_year)
	{
		$pl = 18;
	}
	else
	{
        	$pl = $c->stash->{TotalPersonalLeaves} / 12;
        	$pl = int($pl * (12 - $doj[1]));
	}

        $c->model('Leave::EmployeeLeave')->create(
            {
                EmployeeId              => $_->EmployeeId,
                AvailablePersonalLeaves => $pl,
                UpdatedBy               => $employeeid,
                UpdatedOn               => CurrentDate(),
                CreatedBy               => $employeeid,
                CreatedOn               => CurrentDate(),
            }
        );
    }

    $c->forward('View::JSON');

}

sub addemployee : Local
{
    my ($self, $c) = @_;
    my @collected = $c->model('Leave::Role')->search({});

    push(
        @{$c->stash->{roles}},
        {
            RoleName => $_->RoleName,
        }
    ) foreach @collected;

    my $mang = $c->forward('managerlist');
    $c->stash->{managerslist} = $mang;
    $c->forward('View::TT');
}

sub updatedetailsform : Local
{
    my ($self, $c) = @_;
    my @collected = $c->model('Leave::Role')->search({});

    push(
        @{$c->stash->{roles}},
        {
            RoleName => $_->RoleName,
        }
    ) foreach @collected;

    my @empcollection = $c->model('Leave::Employee')->search(
        {
            'me.EmployeeId' => $c->req->params->{employeeid}
        },
        {
            join      => [qw/role employee_manager_employees/],
            '+select' => [qw/role.RoleName employee_manager_employees.ManagerEmployeeId/],
            '+as'     => [qw/RoleName ManagerEmployeeId/],
        }
    );

    push(
        @{$c->stash->{empdetails}},
        {
            EmployeeId    => $_->EmployeeId,
            FirstName     => $_->FirstName,
            Email         => $_->Email,
            LastName      => $_->LastName,
            DateOfJoining => $_->DateOfJoining,
            Status        => $_->Status,
            RoleName      => $_->get_column('RoleName'),
            ManagerId     => $_->get_column('ManagerEmployeeId'),
        }
    ) foreach @empcollection;
    my $mang = $c->forward('managerlist');
    $c->stash->{managerslist} = $mang;
    $c->forward('View::TT');
}

sub managerlist : Local
{
    my ($self, $c) = @_;
    my @managers = $c->model('Leave::Employee')->search(
        {
            'role.RoleName' => {'in', [qw/Manager Adminstrator/]},
        },
        {
            join      => [qw/role/],
            '+select' => [qw/role.RoleName/],
            '+as'     => [qw/RoleName/],
        }
    );

    my $managerslist;
    push(
        @{$managerslist},
        {
            EmployeeId => $_->EmployeeId,
            FirstName  => $_->FirstName,
            LastName   => $_->LastName,
        }
    ) foreach @managers;

    return $managerslist;

}

sub employeeupdate : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;

    my $user = $c->model('Leave::Employee')->search({EmployeeId => $c->req->params->{employeeid}});
    my @roleid = $c->model('Leave::Role')->search({RoleName => $c->req->params->{role}});
    my $id;

    foreach my $var (@roleid) {
        $id = $var->RoleId;
    }
    $user->update(
        {
            FirstName     => $c->req->params->{fname},
            LastName      => $c->req->params->{lname},
            Email         => $c->req->params->{email},
            DateOfJoining => $c->req->params->{dateofjoining},
            RoleId        => $id,
            Status        => $c->req->params->{status},
            UpdatedBy     => $employeeid,
            UpdatedOn     => CurrentDate(),
        }
    );

    my $empl = $c->model('Leave::EmployeeManager')->search({EmployeeId => $c->req->params->{employeeid}});
    $empl->update(
        {
            ManagerEmployeeId => $c->req->params->{managerid},
            UpdatedBy         => $employeeid,
            UpdatedOn         => CurrentDate(),
        }
    );
    $c->forward('View::JSON');
}

sub leavelist : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;

    my @empcollection = $c->model('Leave::LeaveRequest')->search(
        {EmployeeId => $employeeid},
        {
            join      => 'batch',
            '+select' => ["batch.Message"],
            '+as'     => ["Message"],
            order_by  => {-desc => 'LeaveId'},
        }
    );

    my $counter = 1;
    push(
        @{$c->stash->{leavelist}},
        {
            Counter     => $counter++,
            LeaveDate   => $_->LeaveDate,
            LeaveStatus => $_->LeaveStatus,
            Message     => $_->get_column('Message'),
        }
    ) foreach @empcollection;

    $c->forward('View::JSON');
}

sub leavesleft : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;
    my @totalleaves = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
    foreach my $var (@totalleaves) {
        $c->stash->{TotalPersonalLeaves} = $var->AvailablePersonalLeaves;
    }
    $c->forward('View::JSON');
}

sub leavestatus : Local
{
    my ($self, $c) = @_;
    my $count      = 1;
    my $numdays    = 0;
    my $employeeid = $c->user->EmployeeId;

    if ($c->req->params->{"cancelrequest[]"}) {
        if (ref($c->req->params->{"cancelrequest[]"}) eq 'ARRAY') {
            foreach (@{$c->req->params->{"cancelrequest[]"}}) {
                $numdays++;
                my $leave = $c->model('Leave::LeaveRequest')->search({LeaveId => $_});
                $leave->update(
                    {
                        LeaveStatus => 'Cancelled',
                        UpdatedBy   => $employeeid,
                        UpdatedOn   => CurrentDate(),
                    }
                );
            }
        }
        else {
            $numdays++;
            my $leave = $c->model('Leave::LeaveRequest')->search({LeaveId => $c->req->params->{"cancelrequest[]"}});
            $leave->update(
                {
                    LeaveStatus => 'Cancelled',
                    UpdatedBy   => $employeeid,
                    UpdatedOn   => CurrentDate(),
                }
            );
        }

        my $leavesleft = $c->model('Leave::EmployeeLeave')->search(
            {
                EmployeeId => $employeeid,
            },
            {
                columns => [qw/AvailablePersonalLeaves/],
            }
        );

        my $myleaves       = $leavesleft->next;
        my $numberofleaves = $myleaves->AvailablePersonalLeaves;
        $numberofleaves += $numdays;
        $c->stash->{AvailablePL} = $numberofleaves;

        $leavesleft->update(
            {
                AvailablePersonalLeaves => $numberofleaves,
                UpdatedBy               => $employeeid,
                UpdatedOn               => CurrentDate(),
            }
        );
        my $BatchUpdateDetails = $c->model('Leave::LeaveRequestBatch')->search(
            {
                BatchId => $c->req->params->{bid},
            }
        );
        $BatchUpdateDetails->update(
            {
                UpdatedBy => $c->user->EmployeeId,
                UpdatedOn => CurrentDate(),
            }
        );
        $c->forward('View::JSON');
    }
    else {
        my @batchcollection = $c->model('Leave::LeaveRequestBatch')->search(
            {
                'leave_requests.EmployeeId' => $employeeid,
            },
            {
                join      => 'leave_requests',
                columns   => [qw/me.BatchId me.Message me.FromDate me.ToDate/],
                '+select' => 'leave_requests.EmployeeId',
                '+as'     => 'EmployeeId BatchId Message FromDate ToDate',
                distinct  => 1,
                order_by  => {-desc => 'me.FromDate'},
            }
        );
        push(
            @{$c->stash->{batchcollection}},
            {
                Count    => $count++,
                BatchId  => $_->BatchId,
                Message  => $_->Message,
                FromDate => $_->FromDate,
                ToDate   => $_->ToDate,
            }
        ) foreach @batchcollection;

        $c->forward('View::TT');
    }
}

sub viewrequest : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;

    if (defined $c->req->params->{batchid}) {
        my @leavecollection = $c->model('Leave::LeaveRequest')->search(
            {
                'me.BatchId' => $c->req->params->{batchid},
            },
            {
                join      => ['batch',              'employee'],
                '+select' => ['employee.FirstName', 'employee.LastName', 'batch.Message'],
                '+as'     => ['FirstName',          'LastName', 'Message'],
                order_by => {-desc => 'LeaveDate'},
            }
        );
        push(
            @{$c->stash->{leavecollection}},
            {
                LeaveId     => $_->LeaveId,
                EmployeeId  => $_->EmployeeId,
                FirstName   => $_->get_column('FirstName'),
                LastName    => $_->get_column('LastName'),
                LeaveDate   => $_->LeaveDate,
                LeaveStatus => $_->LeaveStatus,
                Message     => $_->get_column('Message'),
            }
        ) foreach @leavecollection;

        $c->forward('View::JSON');
    }
    else {
        my @batchcollection = $c->model('Leave::LeaveRequest')->search(
            {
                -and => [
                    'employee_manager_employees.ManagerEmployeeId' => $employeeid,
                    'me.LeaveStatus'                               => 'Pending'
                ],
            },
            {
                join => ['batch', {'employee' => 'employee_manager_employees'}],
                '+select' =>
                  ['employee.FirstName', 'employee.LastName', 'batch.FromDate', 'batch.ToDate', 'batch.Message'],
                '+as'   => ['FirstName', 'LastName', 'FromDate', 'ToDate', 'Message'],
                columns => [
                    'me.BatchId',   'employee.FirstName', 'employee.LastName', 'batch.FromDate',
                    'batch.ToDate', 'batch.Message'
                ],
                distinct => 1,
                order_by => {-asc => 'FromDate'},
            }
        );

        my $counter = 1;
        push(
            @{$c->stash->{requests}},
            {
                Counter   => $counter++,
                BatchId   => $_->BatchId,
                FromDate  => $_->get_column('FromDate'),
                ToDate    => $_->get_column('ToDate'),
                Message   => $_->get_column('Message'),
                FirstName => $_->get_column('FirstName'),
                LastName  => $_->get_column('LastName'),
            }
        ) foreach @batchcollection;

        $c->forward('View::TT');
    }

}

sub requestview : Local
{
    my ($self, $c) = @_;
    my $employeeid = $c->user->EmployeeId;
    my $leaves     = 0;

    if (exists $c->req->params->{"acceptreq[]"}) {
        if (ref($c->req->params->{"acceptreq[]"}) eq 'ARRAY') {
            print "hello acceptreq ARRAY\n";
            foreach (@{$c->req->params->{"acceptreq[]"}}) {
                my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId => $_});
                $updateleave->update(
                    {
                        LeaveStatus => 'Approved',
                        UpdatedBy   => $employeeid,
                        UpdatedOn   => CurrentDate(),
                    }
                );
            }
        }
        else {
            print "hello acceptreq\n";
            my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId => $c->req->params->{"acceptreq[]"}});
            $updateleave->update(
                {
                    LeaveStatus => 'Approved',
                    UpdatedBy   => $employeeid,
                    UpdatedOn   => CurrentDate(),
                }
            );
        }
    }
    else {
        if (ref($c->req->params->{"denyreq[]"}) eq 'ARRAY') {

            print "hello denyreq ARRAY\n";
            foreach (@{$c->req->params->{"denyreq[]"}}) {
                $leaves++;
                my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId => $_});
                $updateleave->update(
                    {
                        LeaveStatus => 'Denied',
                        UpdatedBy   => $employeeid,
                        UpdatedOn   => CurrentDate(),
                    }
                );
            }
        }
        else {
            print "hello denyreq \n";
            $leaves++;
            my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId => $c->req->params->{"denyreq[]"}});
            $updateleave->update(
                {
                    LeaveStatus => 'Denied',
                    UpdatedBy   => $employeeid,
                    UpdatedOn   => CurrentDate(),
                }
            );
        }
    }
    my $leavesleft = $c->model('Leave::EmployeeLeave')->search(
        {
            EmployeeId => $c->req->params->{employeeid},
        },
        {
            columns => [qw/AvailablePersonalLeaves/],
        }
    );

    my $mypl        = $leavesleft->next;
    my $availablepl = $mypl->AvailablePersonalLeaves;

    $availablepl += $leaves;
    $leavesleft->update(
        {
            AvailablePersonalLeaves => $availablepl,
            UpdatedBy               => $employeeid,
            UpdatedOn               => CurrentDate(),
        }
    );
    my $to_mailid;
    my $esubject    = "Your leave request status !!";
    my $MailContent = "Hi,\n\nYour Leave request status is as follows\n";
    my @batchtomail = $c->model('Leave::LeaveRequest')->search(
        {
            BatchId => $c->req->params->{batch_id},
        },
        {
            join      => 'employee',
            '+select' => ['employee.Email'],
            '+as'     => ['Email']
        },
    );

    foreach (@batchtomail) {
        $to_mailid = $_->get_column('Email');
        if (($_->LeaveStatus eq 'Denied') or ($_->LeaveStatus eq 'Approved')) {
            $MailContent .= "\n\t" . $_->LeaveDate . "\t" . $_->LeaveStatus . "\n";
        }
    }

    $MailContent .= "\nRegards,\n..................\nExcelLeave System \nExceleron Software(India).";
    ExcelLeaveMailing('ExcelLeave@exceleron.com', $to_mailid, $esubject, $MailContent);
    my $BatchUpdateDetails = $c->model('Leave::LeaveRequestBatch')->search(
        {
            BatchId => $c->req->params->{batch_id},
        }
    );
    $BatchUpdateDetails->update(
        {
            UpdatedBy => $c->user->EmployeeId,
            UpdatedOn => CurrentDate(),
        }
    );
    $c->stash->{response} = 'Success';
    $c->forward('View::JSON');
}

sub LeaveStatusHandle : Local
{
    my ($self, $c) = @_;
    my $employeeid      = $c->user->EmployeeId;
    my @leavecollection = $c->model('Leave::LeaveRequest')->search(
        {
            'me.BatchId' => $c->req->params->{batchid},
        },
        {
            join      => ['batch',              'employee'],
            '+select' => ['employee.FirstName', 'employee.LastName', 'batch.Message'],
            '+as'     => ['FirstName',          'LastName', 'Message'],
        }
    );
    foreach (@leavecollection) {
        my @leavedate = split('-', $_->LeaveDate);
        my $ldate = DateTime->new(year => $leavedate[0], month => $leavedate[1], day => $leavedate[2]);
        my $todaydate = DateTime->today();
        $todaydate->add(days => 2);
        my $status = DateTime->compare($ldate, $todaydate);

        push(
            @{$c->stash->{leavecollection}},
            {
                LeaveId     => $_->LeaveId,
                FirstName   => $_->get_column('FirstName'),
                LastName    => $_->get_column('LastName'),
                LeaveDate   => $_->LeaveDate,
                LeaveStatus => $_->LeaveStatus,
                Message     => $_->get_column('Message'),
                Status      => $status,
            }
        );
    }

    print Dumper $c->stash->{leavecollection};
    $c->forward('View::JSON');

}

sub logout : Local
{
    my ($self, $c) = @_;
    $c->logout();
}

=encoding utf8
=encoding utf8

=head1 AUTHOR

Dharmu,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
