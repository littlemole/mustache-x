package Mole::REST::Attrs::Before;

sub attr_handler {

   my ($package, $subref, $attr) = @_;

      if ( $attr =~ /(Before)\((["][^"]*["]|['][^']*['])\)/ ) {
        my $m = $1;
        my $p = substr($2,1,length($2)-2);
        Mole::REST::Interceptors::register_before($p,$subref);
      }
}

sub import {

	Mole::Attrs::register_attr_handler(\&attr_handler);
}

1;



