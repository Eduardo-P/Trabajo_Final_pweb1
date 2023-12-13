#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $cgi = CGI->new;

my $title = $cgi->param('title');
my $text  = $cgi->param('text');
my $owner = $cgi->param('owner');
my $id = $title.$owner;

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("UPDATE Articles SET text = ? WHERE id = ?");

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
          "<article>\n";

if ($sth->execute($text, $id)) {
    $xml .= "  <title>$title</title>\n".
            "  <text>$text</text>\n";
}

$xml .= "</article>\n";

$dbh->disconnect;

# Crear el archivo XML
open my $archivo, '>', "../htdocs/update.xml" or die "No se pudo abrir el archivo update.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;