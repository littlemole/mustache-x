package Contact;

use v5.20;
use utf8;
use strict;
use warnings;


# new Contact
#
# call with 4 parameters (email,first,last,phone) 
#   to create an object for a new contact
#
# call with 5 parameters (id,email,first,last,phone) 
#   to create a contact object for an existing contact

sub new {
    my $class = shift;
    my $self = {
		id     => undef,
		email  => undef,
		first  => undef,
		last   => undef,
		phone  => undef,
		errors => undef
	};

    if(@_ == 5)
    {
        $self->{id} = shift;
    }
    if(@_ == 4)
    {
        $self->{email} = shift;
        $self->{first} = shift;
        $self->{last}  = shift;
        $self->{phone} = shift;
    }

    bless $self, $class;
}

# accessors

sub id {
    my $self = shift;

    if(@_)
    {
        $self->{id} = shift;
    }
    else
    {
        return $self->{id};
    }
}


sub email {
    my $self = shift;

    if(@_)
    {
        $self->{email} = shift;
    }
    else
    {
        return $self->{email};
    }
}

sub first {
    my $self = shift;

    if(@_)
    {
        $self->{first} = shift;
    }
    else
    {
        return $self->{first};
    }
}

sub last {
    my $self = shift;

    if(@_)
    {
        $self->{last} = shift;
    }
    else
    {
        return $self->{last};
    }
}

sub phone {
    my $self = shift;

    if(@_)
    {
        $self->{phone} = shift;
    }
    else
    {
        return $self->{phone};
    }
}

sub errors {
    my $self = shift;

    if(@_)
    {
        $self->{errors} = shift;
    }
    else
    {
        return $self->{errors};
    }
}
1;

