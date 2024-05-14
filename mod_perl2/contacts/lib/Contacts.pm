package Contacts;

use v5.20;
use utf8;
use strict;
use warnings;

use DBI;

use Contact;
use Mole::Query;

sub new {
    my $class = shift;
    my $dbh   = shift;

    my $self  = {
        dbh => $dbh
    };

    bless $self, $class;
}

sub sql {

    my $self  = shift;
    my $dbh   = $self->{dbh};

	return Mole::Query->new($dbh);
}


sub all {

    my $self = shift;

	return $self->sql
		->prepare( Contact => 'SELECT id,email,first,last,phone FROM contacts ')
		->queryAll();
}

sub search {

    my $self   = shift;
    my $search = shift;

	return $self->sql
		->prepare( Contact => 'SELECT id,email,first,last,phone FROM contacts WHERE first LIKE ? OR last LIKE ? ')
		->param($search."%" )
		->param($search."%" )
		->queryAll();
}

sub find {

    my $self = shift;
    my $id  = shift;

	return $self->sql
		->prepare( Contact => 'SELECT id,email,first,last,phone FROM contacts WHERE id = ? ')
		->queryOne($id);
}

sub find_by_email {

    my $self  = shift;
    my $email = shift;

	return $self->sql
		->prepare( Contact => 'SELECT id,email,first,last,phone FROM contacts WHERE email = ? ' )
		->queryOne( $email );
}

sub count {
    my $self = shift;

	return $self->sql
		->prepare('SELECT COUNT(id) FROM contacts ')
		->fetch();
}

sub insert {
    my $self    = shift;
    my $contact = shift;

	$self->sql
		->prepare(' INSERT INTO contacts (email,first,last,phone) VALUES ( ?, ?, ?, ? ) ')
		->param($contact->email())
		->param($contact->first())
		->param($contact->last())
		->param($contact->phone())
		->execute();
}

sub update {

    my $self    = shift;
    my $contact = shift;

	$self->sql
		->prepare(' UPDATE contacts set email = ?, first = ?, last = ?, phone = ? WHERE id = ? ')
		->param($contact->email())
		->param($contact->first())
		->param($contact->last())
		->param($contact->phone())
		->param($contact->id())
		->execute();
}

sub remove {

    my $self = shift;
    my $id   = shift;

	$self->sql
		->prepare(' DELETE FROM contacts WHERE id = ? ')
		->execute($id);
}

sub validate {

    my $self    = shift;
    my $contact = shift;
	my $i18n    = shift;

    $contact->{errors} = {
        email => "",
        first => "",
        last => "",
        phone => ""
    };

    my $result = 1;

    if($contact->{email} eq "") {
        $contact->{errors}->{email} = $i18n->key("contact.error.email.empty");
		$result = 0;
    }
    if($contact->{last} eq "") {
        $contact->{errors}->{last} = $i18n->key("contact.error.empty.empty");
		$result = 0;
    }

    my $existing = $self->find_by_email($contact->email());

    if($existing && $existing->id() != $contact->id()) {
        $contact->{errors}->{email} = $i18n->key("contact.error.email.unique");
		$result = 0;
    }

    return $result;
}


1;
