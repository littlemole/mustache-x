package Dancer2::Template::Mustache;
# ABSTRACT: Minimal Mustache Perl 5 template engine for Dancer2
$Dancer2::Template::Mustache::VERSION = '0.0.1';

use Moo;
use Dancer2::FileUtils 'read_file_content';
use Ref::Util qw<is_arrayref is_coderef is_plain_hashref>;
use Template::Mustache;

with 'Dancer2::Core::Role::Template';


sub BUILD {
    my $self     = shift;
    my $settings = $self->config;

    $self->{default_tmpl_ext} = "mustache";
}

sub render {
    my ( $self, $template, $tokens ) = @_;

    my $content = read_file_content($template);

    my $mustache = Template::Mustache->new({
        template => $content
    });
     
    return $mustache->render( $tokens );
}


1;

