package Mole::I18N;

use v5.20;
use utf8;

use Config::Properties; 
use File::Basename;

sub new {

	my $class  = shift;
	my $locale = shift;
	my $path   = shift;

	my $self = {};
	bless $self, $class;

	my @files = glob($path."/*.properties");

	my $short_locale = $locale;
	$short_locale =~ s/_.*$//;

	my $candidate;

	foreach my $file ( @files) {

		my $file_locale = "en";
		my $filename = basename($file);
		if( $filename =~ /[^_]*_([^\.]*).properties/ ) {
			$file_locale = $1;
		}

		if($locale eq $file_locale) {
			$self->{properties} = $self->load($file);
			return $self;
		}
		if($short_locale eq $file_locale) {
			$candidate = $file;			
		}
	}

	if($candidate) {
		$self->{properties} = $self->load($candidate);
		return $self;
	}

	$self->{properties} = $self->load($path."/locale.properties");
	return $self;
}

sub key {
	my $self = shift;
	my $key  = shift;

    return $self->{properties}->getProperty($key);
}

sub load {	    

	my $self = shift;
	my $file = shift;
	
	open( my $fh, '<:encoding(UTF-8)', $file)
	    or die "unable to open configuration file";
 
	my $properties = Config::Properties->new();
	$properties->load($fh);

	return $properties;
}


1;
