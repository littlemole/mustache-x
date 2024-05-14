package Mole::REST;

use v5.20;
use strict;
use warnings;
use utf8;

use Apache2::URI;
use Apache2::Log();
use Apache2::Cookie;
use Apache2::Request;
use Apache2::RequestRec ();
use Apache2::RequestIO ();
use Apache2::SubRequest ();
use Apache2::RequestUtil ();
use Apache2::Const -compile => qw(DECLINED OK REDIRECT HTTP_INTERNAL_SERVER_ERROR HTTP_BAD_REQUEST HTTP_NOT_FOUND);

use APR::Request::Cookie;

use Mole::Attrs;
use Mole::REST::Resources;
use Mole::REST::Interceptors;
use Mole::REST::Factories;
use Mole::REST::Attrs::HTTP;
use Mole::REST::Attrs::Factory;
use Mole::REST::Attrs::Before;
use Mole::REST::Attrs::After;

use Scalar::Util qw(refaddr looks_like_number);

use Template::Mustache;
use File::Basename;
use JSON qw(-convert_blessed_universally);
use Encode;

# force export of "handler" sub needed by mod_perl2
# into the REST controller module
use Exporter 'import';
our @EXPORT = qw(handler);


# main Apache2 mod_perl2 HTTP Handler - this
# acts as front controller dispatching to 
# method handlers
sub handler {

	my $r = shift;

	my $method = $r->method;
	my $path = $r->uri;

	my $handler = Mole::REST::Resources::handler($method,$path);
	if(!$handler) {
		return Apache2::Const::DECLINED;  
	}

	my $result = Mole::REST::Interceptors::interceptors_before($r,$path);
	if ( $result != Apache2::Const::OK) {
		return $result;
	}

	my @args = Mole::REST::Factories::factorize($r,$handler->{code});
	foreach my $a ( @{$handler->{args}} ) {
		push(@args, $a);
	}

	my @retval = $handler->{code}->(@args);

	$result = Mole::REST::Interceptors::interceptors_after($r,$path);
	if ( $result != Apache2::Const::OK) {
		return $result;
	}

	my $content_type = $r->content_type();

	my $type = ref $retval[0];
	if ( !$type || $type eq "" ) {
		if(!$content_type || $content_type eq "") {
			$r->content_type("text/html;charset=utf-8");
		}

		if ( looks_like_number($retval[0]) ) {
			return $retval[0];
		}
		print Encode::encode_utf8( $retval[0] );
		return Apache2::Const::OK;
	}

	if($content_type eq "") {
		$r->content_type("application/json;;charset=utf-8");
	}

	print to_json($retval[0], { utf8  => 0, allow_blessed => 1, convert_blessed => 1 });
	return Apache2::Const::OK;
}

###############################################
# helpers
###############################################


sub add_cookie {
	my $r = shift;
    my $c = shift;

    my $values = {};
	foreach my $key ( keys %{$c} )	{
		$values->{$key} = Encode::encode_utf8($c->{$key});
	}

    my $cookie = APR::Request::Cookie->new( $r->pool(), %{$values} );     
    $r->err_headers_out->add('Set-Cookie' => $cookie->as_string);
}

sub fetch_cookies {
	my $r = shift;
	my %cookies = Apache2::Cookie->fetch($r);

	foreach my $key ( keys %cookies ) {
		my $cookie = $cookies{$key};
		$cookie->value( Encode::decode_utf8( $cookie->value()) );
	}
	return \%cookies;
}

sub redirect {
	my $r = shift;
	my $l = shift;
	my $s = shift || 303;

	if($l =~ /^http.*/) {

		$r->headers_out->set(Location => $l);
	}
	else {
		my $location = $r->construct_url($l);
		$r->headers_out->set(Location => $location);
	}
  
    return $s;
}

sub fetch_locale_from_query {
	my $r = shift;
	my $param_name = shift || "lang";

	my $params = params($r);
	if( exists $params->{$param_name} ) {

		my $lang = $params->{$param_name};
		if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
			return $lang;
		}
	}
	return undef;
}

sub fetch_locale_from_cookie {
	my $r = shift;
	my $cookie_name = shift || "language";

	my $cookies = Mole::REST::fetch_cookies($r);
	if( exists $cookies->{$cookie_name} ) {

		my $lang = $cookies->{$cookie_name}->value();
		if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
			return $lang;
		}
	}
	return undef;
}

sub fetch_locale_from_headers {
	my $r = shift;

	my $headers = $r->headers_in();
    my $lang = $headers->{"Accept-Language"};
	$lang =~ s/[,;].*$//;
	if( $lang =~ /^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$/ ) {
		return $lang;
	}
	return undef;
}

sub fetch_locale {

	my $r = shift;

	my $result = fetch_locale_from_query($r);
	if(defined $result) {
		return $result;
	}

	$result = fetch_locale_from_cookie($r);
	if(defined $result) {
		return $result;
	}

	$result = fetch_locale_from_headers($r);
	if(defined $result) {
		return $result;
	}
	
	return "en";
}

###############################################
# default factories
###############################################

sub req :Factory(req) {
	my $r = shift;
	my $req = Apache2::Request->new($r);
	return $req;
}

sub params :Factory(params) {
	my $r = shift;
	my $req = Apache2::Request->new($r);
	my $params 	= $req->param;

	my $result = {};
	foreach my $key ( keys %{$params} )	{
		$result->{$key} = Encode::decode_utf8($params->{$key});
	}
	return $result;
}


sub formData :Factory(data) {
	my $r = shift;
	my $req = Apache2::Request->new($r);
	my $params 	=  $req->body();

	my $result = {};
	foreach my $key ( keys %{$params} )	{
		$result->{$key} = Encode::decode_utf8($params->{$key});
	}
	return $result;
}

sub rawBody : Factory(body) {

	my $r = shift;
	my $result = "";

	if ( $r->method() eq "POST" || $r->method() eq "PUT") { 

			my $data = ''; 

			while($r->read($data, 1024)) { 

					$result .= $data;
			} 
	} 
	return Encode::decode_utf8($result);
}

sub jsonBody : Factory(json) {

	my $r = shift;
	my $result = "";

	if ( $r->method() eq "POST" || $r->method() eq "PUT") { 

			my $data = ''; 

			while($r->read($data, 1024)) { 

					$result .= $data;
			} 
	} 
	return from_json($result);
}

1;

