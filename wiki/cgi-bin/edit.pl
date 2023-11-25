#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $title = param('title');

my $sth = $dbh->prepare("SELECT text FROM articles WHERE title = ?");
$sth->execute($title);

$dbh->disconnect;
my $text = $sth->fetchrow_array;
#$text =~ s/\n/<br>/g;

print header,
start_html(-title=>$title),
h1 ($title);
print start_form(-action => 'new.pl', -method => 'get'),
    hidden(-name => 'title', -value => $title),
    label({-for => 'cont'}, 'Texto: '),
    textarea(-id => 'cont', -name => 'text', -rows => '10', -cols => '50', -value => $text),
    br,
    submit(-type => 'submit', -value => 'Enviar'),
    end_form;
print a({-href => 'list.pl'}, 'Cancelar'),
end_html;