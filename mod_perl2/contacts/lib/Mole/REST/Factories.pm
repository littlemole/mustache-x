package Mole::REST::Factories;

use attributes;

############################################

my %FACTORIES;

############################################


sub register_factory {

  my $class = shift;
  my $code = shift;
  my $param = shift;

  $FACTORIES{$param} = $code;
}


sub factory {
  my $id = shift;
  return $FACTORIES{$id};
}	

sub factorize {
    my $r    = shift;
    my $code = shift;

	my @args = ( $r );

	my @factories = injectors($code);
	foreach my $f (@factories) {
		my $injection = factory($f)->($r);
		push(@args, $injection );
	}
	return @args;
}

sub injectors {

	my $code = shift;

	my @atts = attributes::get($code);
	my @result;

	foreach my $att (@atts) {

		if(!$att) {
			next;
		}

		if ( $att =~ /Inject\(([^)]*)\)/ ) {
			my $key = $1;
			my @keys = split(",",$key);
			push(@result, @keys);
		}
	}

	return @result;
}

1;
