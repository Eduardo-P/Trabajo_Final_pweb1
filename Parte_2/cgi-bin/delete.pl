#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $owner = param('owner');
my $title = param('title');

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("DELETE FROM articles WHERE title = ? AND owner = ?");

my $estructura = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<article>\n";

if ($sth->execute($title, $owner)) {
    $estructura .= "  <owner>$owner</owner>\n".
                   "  <title>$title</title>\n";
}

$estructura .= "</article>\n";

$dbh->disconnect;

print $cgi->header('text/xml');
print $estructura;