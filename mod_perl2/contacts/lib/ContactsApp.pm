package ContactsApp;

use v5.20;
use strict;
use warnings;
use utf8;

use File::Basename;

use Mole::Attrs; # necessary 
use Mole::REST;
use Mole::I18N;
 
use Contacts;

my @available_languages = qw(en de);

#####################################
# REST handlers
#####################################

sub contacts :Inject(tpl,repo,params) :GET("/contacts") {

  my ($r,$tpl,$repo,$params) = @_;

  my $q = $params->{q};
  my $context;

  if($q && $q ne "") {
    $context = {
      "contacts" => $repo->search($q)
    };
  }
  else {
    $context = {
      "contacts" => $repo->all()
    };
  }

  return $tpl->("index",$context);
}


sub contact_new :Inject(tpl) :GET("/contacts/new") {

  my ($r,$tpl) = @_;

  my $contact = Contact->new();
  
  return $tpl->("new",{ contact => $contact, errors => {} } );
}


sub contact_insert :Inject(tpl,repo,data,i18n) :POST("/contacts/new") {

  my ($r,$tpl,$repo,$data,$i18n) = @_;

  my $contact = Contact->new(
    $data->{'email'},
    $data->{'first_name'},
    $data->{'last_name'},
    $data->{'phone'}
  );

  my $valid = $repo->validate($contact,$i18n);
  if($valid) {
    $repo->insert($contact);
    return Mole::REST::redirect($r,"/contacts",303);
  }

  return $tpl->("new",{ contact => $contact, errors => $contact->{errors} } );
}


sub contact_edit :Inject(tpl,repo) :GET("/contacts/{$id}/edit") {

  my ($r,$tpl,$repo,$id) = @_;
  my $contact = $repo->find($id);

  return $tpl->("edit",{ contact => $contact, errors => {} } );
}


sub contact_update :Inject(tpl,repo,data,i18n) :POST("/contacts/{$id}/edit") {

  my ($r,$tpl,$repo,$data,$i18n,$id) = @_;

  my $contact = Contact->new(
    $id,
    $data->{'email'},
    $data->{'first_name'},
    $data->{'last_name'},
    $data->{'phone'}
  );

  my $valid = $repo->validate($contact,$i18n);
  if($valid) {
    $repo->update($contact);
    return Mole::REST::redirect($r,"/contacts",303);
  }

  return $tpl->("edit",{ contact => $contact, errors => $contact->{errors} } );
}


sub contact_email :Inject(repo,params,i18n) :GET("/contacts/{$id/email") {

  my ($r,$repo,$params,$i18n,$id) = @_;
  my $email = $params->{email};

  my $contact = $repo->find_by_email($email);

  if($contact && $contact->id() != $id) {
      return $i18n->key("contact.error.email.taken"); 
  }
  return Apache2::Const::OK;    
}


sub contact_count :Inject(repo) :GET("/contacts/count") {

  my ($r,$repo) = @_;

  my $count = $repo->count();

  print $count;
  return Apache2::Const::OK;
}


sub contact_delete :Inject(repo) :DELETE("/contacts/{$id}") {

  my ($r,$repo,$id) = @_;

  my $headers = $r->headers_in();
  my $trigger = $headers->{"HX-Trigger"};

  $repo->remove($id);

  if($trigger && $trigger eq "delete-btn") {
    return Mole::REST::redirect($r,"/contacts",303);
  }

  $r->headers_out->set("HX-Trigger" => "recountEvent");
  return Apache2::Const::OK;
}


sub contact_show :Inject(tpl,repo) :GET("/contacts/{$id}") {

  my ($r,$tpl,$repo,$id) = @_;
  my $contact = $repo->find($id);

  return $tpl->("show",{ contact => $contact, errors => {} } );
}

########################################
# interceptors
########################################

sub beforeContacts :Before("/contacts") {

    my $r = shift;

    my $dbh = DBI->connect(
        "dbi:MariaDB:dbname=contacts;host=mariadb",
        "contacts",
        "contact"
    )
    or die $DBI::errstr;

    $r->pnotes( "dbh" => $dbh );

    my $repo = Contacts->new($dbh);
    $r->pnotes( "repo" => $repo );

	my $locale = Mole::REST::fetch_locale($r); 
	$r->pnotes( "locale" => $locale);

	my $i18n = Mole::I18N->new($locale, "/".dirname(__FILE__)."/../locale/");
	$r->pnotes( "i18n" => $i18n);

	Mole::REST::add_cookie($r,{
		name => "language",
		value => $locale,
		path => "/"
	});

    return Apache2::Const::OK;
}


sub afterContacts :After("/contacts") {

    my $r = shift;

    my $dbh = $r->pnotes( "dbh" );
    $dbh->disconnect();

    return Apache2::Const::OK;
}


########################################
# factories
########################################


sub mustache :Factory(tpl) {

	my $r = shift;
	my $i18n = $r->pnotes("i18n");
	my $locale = $r->pnotes("locale");

	# return a sub ref with a simple tpl
	# renderer taking two arguments:
	# - tmpl: the mustache template name to use
	# - ctx: hashref to be used as mustache ctx

	my $sub = sub {

		my ($tmpl, $ctx) = @_;

		# add an i18n mustache lambda
		$ctx->{i18n} = sub {
			my $key = shift;
			my $renderer = shift;

			return $renderer->( $i18n->key($key));
		};

		# add available languages to ctx
		my @languages;
		foreach my $lang ( @available_languages ) {

			push @languages, { 
				locale => $lang,
				active => $lang eq $locale
			  };
		}
		$ctx->{languages} = \@languages;

		# actually render the template
		my $mustache = Template::Mustache->new(
			template_path => dirname(__FILE__)."/../views/".$tmpl.".mustache",
		);

		return $mustache->render( $ctx ) ;
	};

	return $sub;
}


sub repository :Factory(repo) {

	my $r = shift;

	my $repo = $r->pnotes("repo");
  	return $repo;
}

sub resources :Factory(i18n) {

	my $r = shift;

	my $resources = $r->pnotes("i18n");
  	return $resources;
}


####################################################
# helpers
####################################################

# sub fetch_locale {

# 	my $r = shift;

# 	my $params = Mole::REST::params($r);
# 	if( exists $params->{"lang"} ) {

# 		my $lang = $params->{"lang"};
# 		if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
# 			return $lang;
# 		}
# 	}

# 	my $cookies = Mole::REST::fetch_cookies($r);
# 	if( exists $cookies->{"language"} ) {

# 		my $lang = $cookies->{"language"}->value();
# 		if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
# 			return $lang;
# 		}
# 	}

# 	my $headers = $r->headers_in();
#     my $lang = $headers->{"Accept-Language"};
# 	$lang =~ s/[,;].*$//;
# 	if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
# 		return $lang;
# 	}

# 	return "en";
# }



1;
