#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $title = param('title');

my $sth = $dbh->prepare("DELETE FROM articles WHERE title = ?");
$sth->execute($title);

$dbh->disconnect;

my $cgi = CGI->new;
print $cgi->redirect('list.pl');