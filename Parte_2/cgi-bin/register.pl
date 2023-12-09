#!"c:\xampp\perl\bin\perl.exe"
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;

my $owner = $cgi->param('owner');
my $password = $cgi->param('password');
my $lastName = $cgi->param('lastName');
my $firstName = $cgi->param('firstName');

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
          "<user>\n";

if ($owner && $password && $firstName && $lastName){
  my $user = 'root';
  my $password_BD = '369789';
  my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $password_BD) or die("No se pudo conectar!");
  
  my $sth = $dbh->prepare("INSERT INTO users (userName, password, lastName, firstName) VALUES (?, ?, ?, ?)");
  $sth->execute($owner, $password, $lastName, $firstName);

  $dbh->disconnect;

  $xml .= "  <owner>$owner</owner>\n".
                 "  <firstName>$firstName</firstName>\n".
                 "  <lastName>$lastName</lastName>\n";
}

$xml .= "</user>\n";

# Crear el archivo XML
open my $archivo, '>', "../htdocs/usuario.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;