package Mole::REST::Attrs::After;


sub attr_handler {

   my ($package, $subref, $attr) = @_;

      if ( $attr =~ /(After)\((["][^"]*["]|['][^']*['])\)/ ) {
        my $m = $1;
        my $p = substr($2,1,length($2)-2);
        Mole::REST::Interceptors::register_after($p,$subref);
      }
}

sub import {

	Mole::Attrs::register_attr_handler(\&attr_handler);
}

1;



