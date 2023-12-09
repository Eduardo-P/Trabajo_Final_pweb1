#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

#my $title = $ARGV[0];
#my $owner = $ARGV[1];

my $cgi = CGI->new;

my $owner = $cgi->param('owner');
my $title = $cgi->param('title');

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT text FROM Articles WHERE title = ? AND owner = ?");
$sth->execute($title, $owner);

$dbh->disconnect;

my $text = $sth->fetchrow_array;

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
          "<article>\n".
          "  <owner>$owner</owner>\n".
          "  <title>$title</title>\n".
          "  <text>$text</text>\n".
          "</article>\n";

# Crear el archivo XML
open my $archivo, '>', "../htdocs/article.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;