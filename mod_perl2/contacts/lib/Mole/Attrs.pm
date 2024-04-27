package Mole::Attrs;

use v5.20;
use strict;
use warnings;

use Scalar::Util qw(refaddr);

# global handlers registry
my @attr_handlers;

# called on import of a specific attribute type
sub register_attr_handler {

  my $handler = shift;
  push(@attr_handlers,$handler);
}

# called during compile of attrbute decorated subs
sub register_attribute {

  foreach my $handler ( @attr_handlers ) {
    $handler->(@_);
  }
}


# global attr hash. allows introspection at runtime
my %attrs;

# register subroutine attribute support
# this will be called at compile time
sub MODIFY_CODE_ATTRIBUTES {

  my ($package, $subref, @attrs) = @_;

	if ( !defined $package ) {
		return 0;
	}

  $attrs{ refaddr $subref } = \@attrs;

  foreach my $a ( @attrs ) {
		register_attribute($package,$subref,$a);
	}

  my @bad;
	return @bad;
}

# introspection support - use attributes::get(\&method) 
# to fetch attributes at runtime

sub FETCH_CODE_ATTRIBUTES {

  my ($package, $subref) = @_;

  if ( ! $subref || !exists $attrs{refaddr $subref} ) {
    my @empty;
    return @empty;
  }
  my $attrs = $attrs{ refaddr $subref };
  return @$attrs;
}

# examine a specific user class
# any module that wants to use attributes
# MUST import Mole::Attrs itself
sub import {

  my $caller = caller();
  
  print STDERR "IMPORT Mol::Attrs -> ".$caller."\r\n";
  { 
    no strict; 
    
	  *{$caller."::MODIFY_CODE_ATTRIBUTES"} = \&MODIFY_CODE_ATTRIBUTES;
	  *{$caller."::FETCH_CODE_ATTRIBUTES"} = \&FETCH_CODE_ATTRIBUTES;
  }
}


1;

