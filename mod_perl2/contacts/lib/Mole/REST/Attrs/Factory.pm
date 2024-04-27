package Mole::REST::Attrs::Factory;


sub attr_handler {

   my ($package, $subref, $attr) = @_;

      if ( $attr =~ /Factory\(([^)]*)\)/ ) {
		my $param = $1;
        Mole::REST::Factories::register_factory($package,$subref,$param);
      }
}

sub import {

	Mole::Attrs::register_attr_handler(\&attr_handler);
}

1;



