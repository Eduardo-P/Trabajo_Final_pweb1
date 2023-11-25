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

# Encabezados
$text =~ s/^(#+)\s+(.*)$/"<h" . length($1) . ">$2<\/h" . length($1) . ">"/meg;

# Texto en negrita y cursiva
$text =~ s/\*\*\*(.*?)\*\*\*/<strong><em>$1<\/em><\/strong>/gs;

# Texto en negrita
$text =~ s/\*\*(.*?)\*\*/<strong>$1<\/strong>/gs;

# Texto en cursiva
$text =~ s/\*(.*?)\*/<em>$1<\/em>/gs;

# Texto en cursiva
$text =~ s/_([^_]+)_/<em>$1<\/em>/gs;

# Texto tachado
$text =~ s/~~(.*?)~~/<s>$1<\/s>/gs;

# Código
#$text =~ s/```(.*?)```/<p><code>$1<\/code><\/p>/gs;
$text =~ s/```(.*?)```/<code>$1<\/code>/gs;

# Enlaces
$text =~ s/\[(.*?)\]\((.*?)\)/<a href="$2">$1<\/a>/gs;

# Párrafos
#$text =~ s/(.*)/<p>$1<\/p>/gm;
$text =~ s/(^\s*.+\n)/<p>$1<\/p>/mg;

print header,
start_html(-title=>$title),
a({-href => 'list.pl'}, 'Retroceder'),
$text,
br,
textarea(-id => 'cont', -name => 'text', -rows => '10', -cols => '50', -value => $text),
end_html;