#!"c:\xampp\perl\bin\perl.exe"
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;

my $userName = $cgi->param('userName');
my $password = $cgi->param('password');
my $lastName = $cgi->param('lastName');
my $firstName = $cgi->param('firstName');

my $estructura = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<user>\n";

if ($userName && $password && $firstName && $lastName){
  my $user = 'root';
  my $password_BD = '369789';
  my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $password_BD) or die("No se pudo conectar!");
  
  my $sth = $dbh->prepare("INSERT INTO users (userName, password, lastName, firstName) VALUES (?, ?, ?, ?)");
  $sth->execute($userName, $password, $lastName, $firstName);

  $dbh->disconnect;

  $estructura .= "  <owner>$userName</owner>\n".
                 "  <firstName>$firstName</firstName>\n".
                 "  <lastName>$lastName</lastName>\n";
}

$estructura .= "</user>\n";

# Crear el archivo XML
open my $archivo, '>', "../htdocs/usuario.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $estructura;
close $archivo;

print $cgi->redirect("http://localhost/list.pl?owner=$userName");