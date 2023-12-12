#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $cgi = CGI->new;

my $owner = $cgi->param('owner');

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT title FROM articles WHERE owner = ?");
$sth->execute($owner);

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
          "<articles>\n";

while (my $title = $sth->fetchrow_array) {
    $xml .= "  <article>\n".
            "    <owner>$owner</owner>\n".
            "    <title>$title</title>\n".
            "  </article>\n";
}

$xml .= "</articles>\n";

$dbh->disconnect;

# Crear el archivo XML
open my $archivo, '>', "../htdocs/listaArticulos.xml" or die "No se pudo abrir el archivo listaArticulos.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;