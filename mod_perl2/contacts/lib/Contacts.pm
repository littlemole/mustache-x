package Contacts;

use v5.20;
use utf8;
use strict;
use warnings;

use DBI;

use Contact;


sub new {
    my $class = shift;
    my $dbh   = shift;

    my $self  = {
        dbh => $dbh
    };

    bless $self, $class;
}


sub all {

    my $self = shift;
    
    my $dbh = $self->{dbh};

    my @contacts;

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts ');
    $sth->execute();

    while (my ($id, $email, $first, $last, $phone) = $sth->fetchrow()) 
    {
        my $contact = Contact->new(
            $id,
            $email,
            $first,
            $last,
            $phone
        );
        push(@contacts, $contact);
    }
    return \@contacts;
}

sub search {

    my $self   = shift;
    my $search = shift;

    my $dbh = $self->{dbh};

    my @contacts;

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE first LIKE ? OR last LIKE ? ');
    $sth->bind_param( 1, $search."%" ); 
    $sth->bind_param( 2, $search."%" ); 
    
    $sth->execute();

    while (my ($id, $email, $first, $last, $phone) = $sth->fetchrow()) 
    {
        my $contact = Contact->new(
            $id,
            $email,
            $first,
            $last,
            $phone
        );
        push(@contacts, $contact);
    }
    return \@contacts;
}

sub find {

    my $self = shift;
    my $sid  = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE id = ? ');
    $sth->bind_param( 1, $sid); 
    
    $sth->execute();

    my ($id, $email, $first, $last, $phone) = $sth->fetchrow();
    my $contact = Contact->new(
        $id,
        $email,
        $first,
        $last,
        $phone
    );

    return $contact;
}

sub find_by_email {

    my $self   = shift;
    my $semail = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE email = ? ');
    $sth->bind_param( 1, $semail); 
    
    $sth->execute();

    my ($id, $email, $first, $last, $phone) = $sth->fetchrow();

    if(!$id) { return undef };

    my $contact = Contact->new(
        $id,
        $email,
        $first,
        $last,
        $phone
    );

    return $contact;
}

sub count {
    my $self = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare('SELECT COUNT(id) FROM contacts ');
    
    $sth->execute();

    my ($count) = $sth->fetchrow();

    return $count;
}

sub insert {
    my $self    = shift;
    my $contact = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare(' INSERT INTO contacts (email,first,last,phone) VALUES ( ?, ?, ?, ? ) ');

    $sth->bind_param( 1, $contact->email() ); 
    $sth->bind_param( 2, $contact->first() ); 
    $sth->bind_param( 3, $contact->last() ); 
    $sth->bind_param( 4, $contact->phone() ); 

    $sth->execute();
}

sub update {

    my $self    = shift;
    my $contact = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare(' UPDATE contacts set email = ?, first = ?, last = ?, phone = ? WHERE id = ? ');
    $sth->bind_param( 1, $contact->email() ); 
    $sth->bind_param( 2, $contact->first() ); 
    $sth->bind_param( 3, $contact->last() ); 
    $sth->bind_param( 4, $contact->phone() ); 
    $sth->bind_param( 5, $contact->id()); 
    
    $sth->execute();
}

sub remove {

    my $self = shift;
    my $id   = shift;

    my $dbh = $self->{dbh};

    my $sth = $dbh->prepare(' DELETE FROM contacts WHERE id = ? ');
    $sth->bind_param( 1, $id); 
    
    $sth->execute();
}

sub validate {

    my $self    = shift;
    my $contact = shift;

    $contact->{errors} = {
        email => "",
        first => "",
        last => "",
        phone => ""
    };

    my $result = 1;

    if($contact->{email} eq "") {
        $contact->{errors}->{email} = "Email must not be empty.";
        $result = 0;
    }
    if($contact->{last} eq "") {
        $contact->{errors}->{last} = "Last name must not be empty.";
        $result = 0;
    }

    my $existing = $self->find_by_email($contact->email());

    if($existing && $existing->id() != $contact->id()) {
        $contact->{errors}->{email} = "Email must be unique.";
        $result = 0;
    }

    return $result;
}


1;
