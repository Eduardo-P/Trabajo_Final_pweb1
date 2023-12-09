#!"c:\xampp\perl\bin\perl.exe"
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $owner = $cgi->param('owner');
my $password = $cgi->param('password');

my $xml = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<user>\n";
if ($owner && $password){
  my $user = 'root';
  my $password_BD = '369789';
  my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $password_BD) or die("No se pudo conectar!");
  
  my $sth = $dbh->prepare("SELECT * FROM users WHERE userName = ?");
  $sth->execute($owner);

  $dbh->disconnect;

  my @data = $sth->fetchrow_array;
  
  if ($data[1] eq $password){
    my $lastName = $data[2];
    my $firstName = $data[3];

    $xml .= "  <owner>$owner</owner>\n".
            "  <firstName>$firstName</firstName>\n".
            "  <lastName>$lastName</lastName>\n";
  }
}

$xml .= "</user>\n";

# Crear el archivo XML
open my $archivo, '>', "../htdocs/usuario.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $xml;
close $archivo;

print $cgi->header('text/xml');
print $xml;