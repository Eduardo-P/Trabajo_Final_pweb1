#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $cgi = CGI->new;

my $owner = $cgi->param('owner');
my $title = $cgi->param('title');
my $text = $cgi->param('text');

$text =~ s/\n/<br>/g;

print header,
start_html(-title=>$title),
h1 ($title),
$text,
hr,
h3 ("Pagina grabada", a({-href => "http://localhost/list.html?owner=$owner"}, 'Listado de Paginas')),
end_html;