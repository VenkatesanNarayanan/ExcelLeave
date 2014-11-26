package ExcelLeave::Controller::Dashboard;
use Moose;
use Data::Dumper;
use DateTime;
use Digest::MD5;
use JSON;
use Session::Token;
use Email::MIME;
use Email::Sender::Simple qw(sendmail);

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

ExcelLeave::Controller::dashboard - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path
{
    my ($self, $c) = @_;
    my $employeeid = 1;
    my $username   = "Dharmu";
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

    print Dumper $c->stash->{Role};

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
    $c->forward('View::TT');

}

sub leaverequest : Local
{
    my ($self, $c) = @_;
    my @priorleaves = $c->model('Leave::SystemConfig')->search({ConfigKey => 'LeaveRequestPrior'});
    foreach my $var (@priorleaves) {
        $c->stash->{LeaveRequestPrior} = $var->ConfigValue;
    }
    print Dumper $c->stash->{LeaveRequestPrior};
    $c->forward('View::TT');
}

sub leaverequesthandler : Local
{
    my ($self, $c) = @_;
    my $user       = "Dharmu";
    my $employeeid = 1;
    my @fromdate   = split('-', $c->req->params->{fromdate});
    my @todate     = split('-', $c->req->params->{todate});
    my $start      = DateTime->new(year => $fromdate[0], month => $fromdate[1], day => $fromdate[2]);
    my $end        = DateTime->new(year => $todate[0], month => $todate[1], day => $todate[2]);
    my %offcialsholidays;
    my @collected = $c->model('Leave::OfficialHolidays')->search({});

    foreach my $var (@collected) {
        $offcialsholidays{$var->HolidayDate} = "";
    }

    my @batchcollection = $c->model('Leave::LeaveRequestBatch')->search({});

    my @arr = qw/a b c d e f g h i j k l m n o p q r s t u v w x y z/;

    my $flag         = 0;
    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $requestdate  = $current_date->ymd();
    my $batchid      = "";
    my $numberofdays = 0;
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
                    UpdatedBy => $employeeid,
                    CreatedOn => $requestdate,
                    UpdatedOn => $requestdate,
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
                        UpdatedBy => $employeeid,
                        CreatedOn  => $requestdate,
                        UpdatedOn  => $requestdate,
                    }
                );
                $numberofdays += 1;
            }
        }
        $start->add(days => 1);
    }

    my @empl = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
    my $apl;
    foreach (@empl) {
        $apl = $_->AvailablePersonalLeaves;
    }
    $apl = $apl - $numberofdays;

    my $empleave = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
    $empleave->update(
        {
            AvailablePersonalLeaves => $apl,
        }
    );
    $c->forward('View::JSON');
}

sub home : Local
{
    my ($self, $c) = @_;
    my $employeeid   = 1;
    my @leavelist    = $c->model('Leave::LeaveRequest')->search(
        {
            EmployeeId => $employeeid,
        },
        {
            rows     => 6,
            order_by => {-desc => 'LeaveDate'},
        }
    );
    my $Counter = 1;
    push(
        @{$c->stash->{leaveslist}},
        {
            Counter     => $Counter++,
            LeaveId     => $_->LeaveId,
            LeaveDate   => $_->LeaveDate,
            LeaveStatus => $_->LeaveStatus,
        }
    ) foreach @leavelist;
    $c->forward('View::TT');
}

sub changepassword : Local
{

    my ($self, $c) = @_;
    my $employeeid = 1;
    my $user;
    if ($c->req->params->{status} eq "new") {
        $user = $c->model('Leave::Employee')->search({Token => $c->req->params->{token}});
        $user->update({Status => 'Active'});
    }
    else {
        $user = $c->model('Leave::Employee')->search({EmployeeId => $employeeid});
    }
    my $data = $c->req->params->{newpassword};
    my $ctx  = Digest::MD5->new;
    $ctx->add($data);
    my $mypassword = $ctx->hexdigest;
    my $tokencheck = $user->update({Password => $mypassword});
    $c->stash->{PasswordStatus} = "Success";
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
    my $employeeid = 1;

    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $CreatedOn = $current_date->ymd('-');

    my $Token = Session::Token->new->get;
    print Dumper $Token;

    my @chars = ("A" .. "Z", "a" .. "z", '1' .. '9');
    my $RandomPassword;
    $RandomPassword .= $chars[rand @chars] for 1 .. 6;
    print $RandomPassword. "\n";

    my $ctx = Digest::MD5->new;
    $ctx->add($RandomPassword);
    my $EncryptedPassword = $ctx->hexdigest;
    print Dumper $EncryptedPassword;

    my @roles = $c->model('Leave::Role')->search({RoleName => $c->req->params->{role}});
    my $RoleId;
    foreach (@roles) {
        $RoleId = $_->RoleId;
    }
    print Dumper $RoleId;

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
            CreatedOn     => $CreatedOn,

        }
    );
    my @totalleaves = $c->model('Leave::SystemConfig')->search({ConfigKey => 'TotalPersonalLeaves'});
    foreach my $var (@totalleaves) {
        $c->stash->{TotalPersonalLeaves} = $var->ConfigValue;
    }

    my $ltime = localtime();
    my @larr = split(" ", $ltime);

    my @employeelist = $c->model('Leave::Employee')->search({Email => $c->req->params->{email}});

    foreach (@employeelist) {
        my @doj = split("-", $_->DateOfJoining);
        my $pl = $c->stash->{TotalPersonalLeaves} / 12;
        $pl = int($pl * (12 - $doj[1]));

        $c->model('Leave::EmployeeLeave')->create(
            {
                EmployeeId              => $_->EmployeeId,
                AvailablePersonalLeaves => $pl,
                UpdatedBy               => $employeeid,
                UpdatedOn               => $CreatedOn,
                CreatedBy               => $employeeid,
                CreatedOn               => $CreatedOn,
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
        {EmployeeId => $c->req->params->{employeeid}},
        {
            join      => 'role',
            '+select' => ["role.RoleName"],
            '+as'     => ["RoleName"],
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
        }
    ) foreach @empcollection;

    $c->forward('View::TT');
}

sub employeeupdate : Local
{
    my ($self, $c) = @_;
	my $employeeid=1;

    my $user = $c->model('Leave::Employee')->search({EmployeeId => $c->req->params->{employeeid}});
    my @roleid = $c->model('Leave::Role')->search({RoleName => $c->req->params->{role}});
    my $id;

    my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $requestdate = $current_date->ymd('-');

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
            UpdatedOn     => $requestdate,
        }
    );
    $c->forward('View::JSON');
}

sub leavelist : Local
{
    my ($self, $c) = @_;
    my $employeeid = 1;

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
    my $employeeid = 1;
    my @totalleaves = $c->model('Leave::EmployeeLeave')->search({EmployeeId => $employeeid});
    foreach my $var (@totalleaves) {
        $c->stash->{TotalPersonalLeaves} = $var->AvailablePersonalLeaves;
    }
    $c->forward('View::JSON');
}

sub leavestatus : Local
{
	my ($self, $c) = @_;
	my $count = 1;
	my $numdays=0;
	my $employeeid=1;
	my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $requestdate  = $current_date->ymd();

	if($c->req->params->{"cancelrequest[]"})
	{
		if(ref($c->req->params->{"cancelrequest[]"}) eq 'ARRAY')
		{
			foreach(@{$c->req->params->{"cancelrequest[]"}})
			{
				$numdays++;
				my $leave=$c->model('Leave::LeaveRequest')->search({LeaveId	=> $_});
				   $leave->update({
									LeaveStatus => 'Cancelled',
									UpdatedBy	=> $employeeid,
									UpdatedOn	=> $requestdate,
								});
			}
		}
		else
		{
			$numdays++;
			my $leave=$c->model('Leave::LeaveRequest')->search({LeaveId => $c->req->params->{"cancelrequest[]"}});
			$leave->update({
					LeaveStatus => 'Cancelled',
					UpdatedBy	=> $employeeid,
					UpdatedOn	=> $requestdate,
				});
		}

		my $leavesleft=$c->model('Leave::EmployeeLeave')->search(
			{
				EmployeeId => $employeeid,
			},
			{
			columns => [qw/AvailablePersonalLeaves/],
			});
			
		my $myleaves		=	$leavesleft->next;
		my $numberofleaves	=	$myleaves->AvailablePersonalLeaves;

		$numberofleaves += $numdays;
		$c->stash->{AvailablePL}=$numberofleaves;

		$leavesleft->update({
			AvailablePersonalLeaves => $numberofleaves,
			UpdatedBy				=> $employeeid,
			UpdatedOn				=> $requestdate, 
			});	

		$c->forward('View::JSON');
	}
	else
	{
		my @batchcollection = $c->model('Leave::LeaveRequestBatch')->search({});
		push(
			@{$c->stash->{batchcollection}},
			{
				Count => $count++,
				BatchId => $_->BatchId,
				Message => $_->Message,
				FromDate => $_->FromDate,
				ToDate => $_->ToDate,
			}
		) foreach @batchcollection;
		
		$c->forward('View::TT');
	}
}
sub viewrequest : Local
{
    my ($self, $c) = @_;
	my $employeeid=1;
	
 	if(defined $c->req->params->{batchid})	
	{
		my @leavecollection = $c->model('Leave::LeaveRequest')->search(
			{
				'me.BatchId' =>$c->req->params->{batchid},
			},
			{
				join => ['batch','employee'],
				'+select' =>['employee.FirstName','employee.LastName','batch.Message'],
				'+as' =>['FirstName','LastName','Message'],
			}
			);
		push(
			@{$c->stash->{leavecollection}},
			{
				LeaveId		=> $_->LeaveId,
				FirstName   => $_->get_column('FirstName'),
				LastName 	=> $_->get_column('LastName'),
				LeaveDate 	=> $_->LeaveDate,
				LeaveStatus => $_->LeaveStatus,
				Message		=> $_->get_column('Message'),
			}
		) foreach @leavecollection;

    	$c->forward('View::JSON');
	}
	else
	{
		my @batchcollection = $c->model('Leave::LeaveRequest')->search(
			{
				-and =>[
						'me.EmployeeId'=>$employeeid,
						'me.UpdatedBy' =>{'!=',$employeeid},
					],
			},
			{
				join      => ['batch','employee'],
				'+select' =>['employee.FirstName','employee.LastName','batch.FromDate','batch.ToDate','batch.Message'],
				'+as' =>['FirstName','LastName','FromDate','ToDate','Message'],
				columns => ['me.BatchId','employee.FirstName','employee.LastName','batch.FromDate','batch.ToDate','batch.Message'],
				distinct => 1,
			}
		);

		my $counter=1;
		push(
			@{$c->stash->{requests}},
			{
				Counter		=> $counter++,
				BatchId     => $_->BatchId,
				FromDate    => $_->get_column('FromDate'),
				ToDate 	    => $_->get_column('ToDate'),
				Message		=> $_->get_column('Message'),
				FirstName	=> $_->get_column('FirstName'),
				LastName	=> $_->get_column('LastName'),
			}
		) foreach @batchcollection;
    	$c->forward('View::TT');
	}
}

sub requestview:Local
{
	my($self,$c)=@_;


	my $current_date = DateTime->now(time_zone => 'Asia/Kolkata');
    my $requestdate  = $current_date->ymd();
	my $employeeid	=1;

	if(ref($c->req->params->{"acceptreq[]"}) eq 'ARRAY')
	{
		foreach(@{$c->req->params->{"acceptreq[]"}})
		{
			print "hello ARRAY acceptreq\n";
			my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId=>$_});
			$updateleave->update(
				{
					LeaveStatus => 'Approved',
					UpdatedBy 	=> $employeeid,
					UpdatedOn	=> $requestdate,
				}
			);
		}
	}
	else
	{
		
			print "hello Simple acceptreq\n";
			my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId=>$c->req->params->{"acceptreq[]"}});
			$updateleave->update(
				{
					LeaveStatus => 'Approved',
					UpdatedBy 	=> $employeeid,
					UpdatedOn	=> $requestdate,
				}
			);
	}

	if(ref($c->req->params->{"denyreq[]"}) eq 'ARRAY')
	{
		foreach(@{$c->req->params->{"denyreq[]"}})
		{
			my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId=>$_});
			$updateleave->update(
				{
					LeaveStatus => 'Denied',
					UpdatedBy 	=> $employeeid,
					UpdatedOn	=> $requestdate,
				}
			);
		}
	}
	else
	{
			my $updateleave = $c->model('Leave::LeaveRequest')->search({LeaveId=>$c->req->params->{"denyreq[]"}});
			$updateleave->update(
				{
					LeaveStatus => 'Denied',
					UpdatedBy 	=> $employeeid,
					UpdatedOn	=> $requestdate,
				}
			);
	}
	
	$c->stash->{response}='Success';
	$c->forward('View::JSON');
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
