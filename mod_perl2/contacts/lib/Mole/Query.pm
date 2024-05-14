package Mole::Query;

use v5.20;

use utf8;
use strict;
use warnings;

use DBI;

my $mapOne  = sub {

    my ($clazz,$sth) = @_;
    
	my $obj = $clazz->new();

	my $hash = $sth->fetchrow_hashref();
	if( !defined $hash) { return undef; }

	my @keys = keys %$hash;
	for my $key (@keys) {
		$obj->{$key} = $hash->{$key};
	}

	return $obj;
};

my $mapAll  = sub {

    my ($clazz,$sth) = @_;
	my @result;

	my $r;
	do {
		$r = $mapOne->($clazz,$sth);
		if($r) {
			push(@result,$r);
		}
	} while($r);

	return \@result;
};


sub new {
    my $class = shift;
    my $dbh   = shift;

    my $self  = {
        dbh => $dbh,
		sth => undef,
		class => undef,
		sql => undef,
		params => 0
    };

    bless $self, $class;
}

sub prepare {
	my $self = shift;
	my $class = undef;

	my $nargs = @_;
	if($nargs > 1)  { 
		$class = shift;
	}

	my $sql = shift;
    my $dbh = $self->{dbh};

	my $sth = $dbh->prepare($sql);
	$self->{sth} = $sth;
	$self->{class} = $class;

	return $self;
}

sub queryAll {
	my $self = shift;
	my $class = $self->{class};
	my $sth = $self->{sth};

	foreach my $param ( @_) {
		$self->param($param);
	}

    $sth->execute();

	return $mapAll->( $class => $sth);
}

sub queryOne {
	my $self = shift;
	my $class = $self->{class};
	my $sth = $self->{sth};

	foreach my $param ( @_) {
		$self->param($param);
	}

    $sth->execute();

	return $mapOne->( $class => $sth);
}

sub fetch {
	my $self = shift;
	my $sth = $self->{sth};

	foreach my $param ( @_) {
		$self->param($param);
	}

    $sth->execute();

	my ($result) = $sth->fetchrow();
	return $result;
}

sub last_insert_id {
	my $self = shift;
    my $dbh = $self->{dbh};

	return $dbh->last_insert_id();
}

sub execute {
	my $self = shift;
	my $sth = $self->{sth};
    my $dbh = $self->{dbh};

	foreach my $param ( @_) {
		$self->param($param);
	}

    $sth->execute();

	return $sth->rows();
}

sub param {
	my $self = shift;
	my $value = shift;
	my $sth = $self->{sth};
	my $param = $self->{param} +1;
	$self->{param} = $param;

	$sth->bind_param($param,$value);
	return $self;
}

1;

