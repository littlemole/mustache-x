package Mole::REST::Resources;

############################################

my @GET;
my @POST;
my @DELETE;
my @PUT;

############################################

my %lookup = (
  GET => \@GET,
  POST => \@POST,
  PUT => \@PUT,
  DELETE => \@DELETE,
);

############################################


sub register {

  my $method = shift;
  my $path = shift;
  my $code = shift;
  
  print STDERR "REGISTER $method $path\r\n";

  if (!exists $lookup{$method}) {
    die("unknown method\n");
  }
  
  my $action = $lookup{$method};
  $path =~ s/^\/+//;
  my @p = split('/',$path);
  push( @$action, { path => \@p, code => $code } );
}


sub handler {

  my $method = shift;
  my $path = shift;
  
  if (!exists $lookup{$method}) {
    die("unknown method\n");
  }

  my $actions = $lookup{$method};
  foreach my $action ( @$actions ) {

	my $code = match_path($path, $action);
    if ( defined $code ) {
      return $code;
    }
  }
  return undef;
}

############################################

sub match_path {
  my $path = shift;
  my $action = shift;

  my @args;
  $path =~ s/^\/+//;
  my @items = split("/",$path);

  my $n = @{$action->{path}};

  if ( @items != $n ) {
	if ( $action->{path}->[@{$action->{path}}-1] !~ /\*$/ ) {
		return undef;
	}
	if ( @items < $n ) {
		return undef;
	}
  }

  for ( my $i = 0; $i < $n; $i++) {

	my $item = $items[$i];
	my $a = $action->{path}->[$i];

	if ( substr($a,0,2) eq '{$') {
		my $arg = substr($a,2);
		chop($arg);
		push(@args,$item);
	}
	elsif ( $a ne $item ) {
		if($a =~ /\*$/) {
			my $it = $a;
			chop($it);
			if ( $item !~ /$it/ ) {
				return undef;
			}
			next;
		}
		return undef;
	}
  }
  return {code => $action->{code}, args => \@args};
}



1;
