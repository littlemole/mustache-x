package Contacts;

use Dancer2;
use DBI;
use Contact;

sub connect_db {
    my $dbh = DBI->connect(
        setting("dbi"),
        setting("user"),
        setting("pwd") 
    )
    or die $DBI::errstr;
 
    return $dbh;
}

sub all {

    my $dbh = connect_db();
    my @contacts;

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts ');
    $sth->execute();

    while (my ($id, $email, $first, $last, $phone) = $sth->fetchrow()) 
    {
        my $contact = Contact->new($id,$email,$first,$last,$phone);
        push(@contacts, $contact);
    }
    $dbh->disconnect();
    return @contacts;
}

sub search {

    my $search = shift;

    my $dbh = connect_db();
    my @contacts;

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE first LIKE ? OR last LIKE ? ');
    $sth->bind_param( 1, $search."%" ); 
    $sth->bind_param( 2, $search."%" ); 
    
    $sth->execute();

    while (my ($id, $email, $first, $last, $phone) = $sth->fetchrow()) 
    {
        my $contact = Contact->new($id,$email,$first,$last,$phone);
        push(@contacts, $contact);
    }
    $dbh->disconnect();
    return @contacts;
}

sub find {

    my $sid = shift;

    my $dbh = connect_db();

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE id = ? ');
    $sth->bind_param( 1, $sid); 
    
    $sth->execute();

    my ($id, $email, $first, $last, $phone) = $sth->fetchrow();
    my $contact = Contact->new($id,$email,$first,$last,$phone);

    $dbh->disconnect();
    return $contact;
}

sub find_by_email {

    my $semail = shift;

    my $dbh = connect_db();

    my $sth = $dbh->prepare('SELECT id,email,first,last,phone FROM contacts WHERE email = ? ');
    $sth->bind_param( 1, $semail); 
    
    $sth->execute();

    my ($id, $email, $first, $last, $phone) = $sth->fetchrow();

    $dbh->disconnect();

    if(!$id) { return undef };

    my $contact = Contact->new($id,$email,$first,$last,$phone);

    return $contact;
}

sub count {

    my $dbh = connect_db();

    my $sth = $dbh->prepare('SELECT COUNT(id) FROM contacts ');
    
    $sth->execute();

    my ($count) = $sth->fetchrow();

    $dbh->disconnect();
    return $count;
}

sub insert {

    my $contact = shift;

    my $dbh = connect_db();

    my $sth = $dbh->prepare(' INSERT INTO contacts (email,first,last,phone) VALUES ( ?, ?, ?, ? ) ');
    $sth->bind_param( 1, $contact->email()); 
    $sth->bind_param( 2, $contact->first()); 
    $sth->bind_param( 3, $contact->last()); 
    $sth->bind_param( 4, $contact->phone()); 
    
    $sth->execute();
    $dbh->disconnect();
}

sub update {

    my $contact = shift;

    my $dbh = connect_db();

    my $sth = $dbh->prepare(' UPDATE contacts set email = ?, first = ?, last = ?, phone = ? WHERE id = ? ');
    $sth->bind_param( 1, $contact->email()); 
    $sth->bind_param( 2, $contact->first()); 
    $sth->bind_param( 3, $contact->last()); 
    $sth->bind_param( 4, $contact->phone()); 
    $sth->bind_param( 5, $contact->id()); 
    
    $sth->execute();
    $dbh->disconnect();
}

sub remove {

    my $id = shift;

    my $dbh = connect_db();

    my $sth = $dbh->prepare(' DELETE FROM contacts WHERE id = ? ');
    $sth->bind_param( 1, $id); 
    
    $sth->execute();
    $dbh->disconnect();
}

sub validate {

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

    my $existing = Contacts::find_by_email($contact->email());
    if($existing && $existing->id() != $contact->id()) {
        $contact->{errors}->{email} = "Email must be unique.";
        $result = 0;
    }

    return $result;
}


1;
