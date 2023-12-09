#!"c:\xampp\perl\bin\perl.exe"
use CGI qw(:standard);
use DBI;

my $cgi = CGI->new;

my $title = $cgi->param('title');
my $text = $cgi->param('text');
my $owner = $cgi->param('owner');

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("INSERT INTO articles (title, owner, text) VALUES (?, ?, ?)");

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<article>\n";

if ($sth->execute($title, $owner, $text)) {
    $xml .= "  <title>$title</title>\n".
            "  <text>$text</text>\n";
}

$xml .= "</article>\n";

$dbh->disconnect;

# Crear el archivo XML
open my $archivo, '>', "../htdocs/new.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;