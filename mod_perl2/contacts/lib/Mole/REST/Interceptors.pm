package Mole::REST::Interceptors;

use Apache2::Const -compile => qw(OK);

############################################

my @BEFORE;
my @AFTER;

############################################

sub register_before {

  my $path = shift;
  my $code = shift;

  push( @BEFORE, { path => $path, code => $code } );
}

sub register_after {

  my $path = shift;
  my $code = shift;
    
  push( @AFTER, { path => $path, code => $code } );
}

############################################


sub interceptors_before {

  my $r = shift;
  my $path = shift;
  
  my @interceptors;
  foreach my $i ( @BEFORE ) {
	my $p = $i->{path};
	if ( $path =~ /$p/ ) {
		unshift( @interceptors, $i );
	}
  }

  foreach my $interceptor ( @interceptors ) {
	my $result = $interceptor->{code}->($r);
	if ( $result != Apache2::Const::OK) {
		return $result;
	}
  }
  return Apache2::Const::OK;
}

sub interceptors_after {

  my $r = shift;
  my $path = shift;
  
  my @interceptors;
  foreach my $i ( @AFTER ) {
	my $p = $i->{path};
	if ( $path =~ /$p/ ) {
		unshift( @interceptors, $i );
	}
  }

  foreach my $interceptor ( @interceptors ) {
	my $result = $interceptor->{code}->($r);
	if ( $result != Apache2::Const::OK) {
		return $result;
	}
  }
  return Apache2::Const::OK;
}


1;
