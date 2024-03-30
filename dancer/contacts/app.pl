#!/usr/bin/env perl

use FindBin 1.51 qw( $RealBin );
use lib $RealBin;

use Dancer2;
use Contacts;
use Contact;

 
get '/contacts' => sub {

    my $search = query_parameters->get('q');
    my @contacts;
    
    if(!$search || $search eq "") {
        @contacts = Contacts::all();
    } else {
        @contacts = Contacts::search($search);
    }

    return template 'index', {
        contacts => \@contacts,
        q => $search
    };
};

get '/contacts/count' => sub {

    my $count = Contacts::count();

    return $count;
};

get '/contacts/new' => sub {

    my $contact = Contact->new();

    return template 'new', {
        contact => $contact,
        errors => {}
    };
};

post '/contacts/new' => sub {

    my $contact = Contact->new(
        body_parameters->get('email'),
        body_parameters->get('first_name'),
        body_parameters->get('last_name'),
        body_parameters->get('phone')
    );

    my $valid = Contacts::validate($contact);
    if($valid) {
        Contacts::insert($contact);
        redirect "/contacts", 303;
    }

    return template 'new', {
        contact => $contact,
        errors => $contact->{errors}
    };
};

get '/contacts/:id/edit' => sub {

    my $id = route_parameters->get('id');

    my $contact = Contacts::find($id);

    return template 'edit', {
        contact => $contact,
        errors => {}
    };
};

post '/contacts/:id/edit' => sub {

    my $id = route_parameters->get('id');

    my $contact = Contact->new(
        $id,
        body_parameters->get('email'),
        body_parameters->get('first_name'),
        body_parameters->get('last_name'),
        body_parameters->get('phone')
    );

    my $valid = Contacts::validate($contact);
    if($valid) {
        Contacts::update($contact);
        redirect "/contacts", 303;
    }

    return template 'edit', {
        contact => $contact,
        errors => $contact->{errors}
    };
};

get '/contacts/:id/email' => sub {

    my $id = route_parameters->get('id');
    my $email = query_parameters->get('email');

    my $contact = Contacts::find_by_email($email);

    if($contact && $contact->id() != $id) {
        return "Email not unique.";
    }
    
    return "";
};

get '/contacts/:id' => sub {

    my $id = route_parameters->get('id');

    my $contact = Contacts::find($id);

    return template 'show', {
        contact => $contact,
        errors => {}
    };
};

del '/contacts/:id' => sub {

    my $id = route_parameters->get('id');

    Contacts::remove($id);

    my $trigger = request->header('HX-Trigger') || "";

    if( $trigger eq 'delete-btn') {
        redirect "/contacts", 303;
    }

    response_header( 'HX-Trigger' =>'recountEvent' );
    return "";
};

start;
