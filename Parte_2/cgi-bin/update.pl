#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $title = param('title');
my $text  = param('text');
my $owner = param('owner');

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("UPDATE Articles SET text = ? WHERE title = ? AND owner = ?");

my $estructura = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<article>\n";

if ($sth->execute($text, $title, $owner)) {
    $estructura .= "  <title>$title</title>\n".
                   "  <text>$text</text>\n";
}

$estructura .= "</article>\n";

$dbh->disconnect;

print $cgi->header('text/xml');
print $estructura;