#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $cgi = CGI->new;

#my $owner = $cgi->param('owner');
#my $title = $cgi->param('title');
my $owner = 'Edward';
my $title = 'Mack';

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");

my $sth = $dbh->prepare("SELECT text FROM Articles WHERE title = ? AND owner = ?");
$sth->execute($title, $owner);

$dbh->disconnect;

my $text = $sth->fetchrow_array;

print $cgi->header('text/html');
print $text;
exit;

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
$text =~ s/```(.*?)```/<code>$1<\/code>/gs;

# Imagen local
$text =~ s/!\[(.*?)\]\(([^)]+)\)\{width=(\d+) height=(\d+)\}/<img src="$2" alt="$1" width="$3" height="$4">/gs;

# Imagenes con URL
$text =~ s/!\[(.*?)\]\((https?:\/\/.*?)\)\{width=(\d+) height=(\d+)\}/<img src="$2" alt="$1" width="$3" height="$4">/gs;

# Citas:
$text =~ s/^>\s+(.*)$/<blockquote>$1<\/blockquote>/mg;

# Listas desordenadas, reconocen 3 tipos de simbolos ( * , - y + )
$text =~ s/^\s*[-*+]\s+(.*)$/<ul><li>$1<\/li><\/ul>/mg;

# Listas ordenadas
$text =~ s/^\s*\d+\.\s+(.*)$/<ol><li>$1<\/li><\/ol>/mg;

# Enlaces
$text =~ s/\[(.*?)\]\((.*?)\)/<a href="$2">$1<\/a>/gs;

# Párrafos
$text =~ s/(^\s*.+\n)/<p>$1<\/p>/mg;

# Imprimir la salida HTML
#print $cgi->header('text/html');
print $text;