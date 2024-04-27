package Mole::REST::Attrs::HTTP;

sub attr_handler {

   my ($package, $subref, $attr) = @_;

   if ( $attr =~ /(GET|POST|PUT|DELETE|HEAD)\((["][^"]*["]|['][^']*['])\)/ ) {
        my $m = $1;
        my $p = substr($2,1,length($2)-2);

        Mole::REST::Resources::register($m,$p,$subref);
	}
}

sub import {

	Mole::Attrs::register_attr_handler(\&attr_handler);
}

1;



