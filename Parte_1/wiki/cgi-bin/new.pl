#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $title = param('title');
my $text = param('text');

my $sth = $dbh->prepare("DELETE FROM articles WHERE title = ?");
$sth->execute($title);

my $sth = $dbh->prepare("INSERT INTO articles (title, text) VALUES (?, ?)");
$sth->execute($title, $text);

$dbh->disconnect;

$text =~ s/\n/<br>/g;

print header,
start_html(-title=>$title),
h1 ($title),
$text,
hr,
h3 ("Pagina grabada", a({-href => 'list.pl'}, 'Listado de Paginas')),
end_html;