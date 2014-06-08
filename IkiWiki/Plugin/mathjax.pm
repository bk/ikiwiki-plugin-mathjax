package IkiWiki::Plugin::mathjax;

use warnings;
use strict;
use IkiWiki 3.00;
use MIME::Base64;

# Strategy:
## - filter replaces normal TeX delimiters with imath and dmath directives
##   (perhaps while considering a mathconf directive); also, it adds a script
##   block if there is any math on the page relevant.
## - preprocess handles the directives themselves.
##
## Later: config hooks for mathjax script tag and mathjax config block
##

sub import {
    hook(type => "filter", id => "mathjax", call => \&filter);
    hook(type => "format", id=>"mathjax", call=> \&format);
}

sub format {
    my %params = @_;
    my $content = $params{content};
    return $content unless $content =~ /\!\!mathjaxbegin/; #]/{{
    $content =~ s{\!\!mathjaxbegin-i!! (.*?)\s\!\!mathjaxend-i\!\!}{'\('.decode_base64($1).'\)'}ges; #{
    $content =~ s{\!\!mathjaxbegin-d!! (.*?)\s\!\!mathjaxend-d\!\!}{'\['.decode_base64($1).'\]'}ges; #{
    my $scripttag = _scripttag();
    $content =~ s{(</body>)}{$scripttag\n$1}i; #}{
    return $content;
}

sub filter (@) {
    my %params=@_;
    my $content = $params{content};
    return $content unless $content =~ /\$[^\$]+\$|\\[\(\[][\s\S]+\\[\)\]]/;
    # first, handle display math...
    $content =~ s{(?<!\\)\\\[(.+?)(?<!\\)\\\]}{_escape_mathjax('d', $1)}ges; #};[}
    $content =~ s{(?<!\\)\$\$(.+?)(?<!\\)\$\$}{_escape_mathjax('d', $1)}ges; #};[}
    # then, the inline math -- note that it must stay on one line
    $content =~ s{(?<!\\)\\\((.+?)(?<!\\)\\\)}{_escape_mathjax('i', $1)}ge; #};[}
    # note that the 'parsing' of $..$ is extremely fragile
    $content =~ s{(?<!\\)\$(.+?)(?<!\\)\$}{_escape_mathjax('i', $1)}ge; #};[}
    return $content;
}

sub _escape_mathjax {
    my ($mode, $formula) = @_;
    my %modes = qw/i inline d display/;
    my $directive = "!!mathjaxbegin-$mode!! ";
    $formula =~ s/"/&quot;/g;
    $formula =~ s/&/&amp;/g; #"/}[{
    $formula =~ s/</&lt;/g;
    $formula =~ s/>/&gt;/g; #{"
    $directive .= encode_base64($formula);
    $directive .= " !!mathjaxend-$mode!!";
    return $directive;
}

sub _scripttag {
    my $config = 'TeX-AMS_HTML'; # another possibility: TeX-AMS-MML_HTMLorMML
    return '<script type="text/x-mathjax-config">'
      . 'MathJax.Hub.Config({ TeX: { equationNumbers: {autoNumber: "AMS"} } });'
      . '</script>'
      . '<script async="async" type="text/javascript" '
      . 'src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config='
      . $config
      . '"></script>';
}

1;
