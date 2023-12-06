#!"c:\xampp\perl\bin\perl.exe"
use CGI::Carp 'fatalsToBrowser';
use strict;
use warnings;
use CGI;
use DBI;

my $cgi = CGI->new;
my $userName = $cgi->param('userName');
my $password = $cgi->param('password');

my $estructura = "<?xml version='1.0' encoding='utf-8'?>\n".
                 "<user>\n";

  my $user = 'root';
  my $password_BD = '369789';
  my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
  my $dbh = DBI->connect($dsn, $user, $password_BD) or die("No se pudo conectar!");
  
  my $sth = $dbh->prepare("SELECT * FROM users WHERE userName = ?");
  $sth->execute($userName);

  $dbh->disconnect;

  my @data = $sth->fetchrow_array;
  
  my $ingreso;
  if ($ingreso = ($data[1] eq $password)){
    my $lastName = $data[2];
    my $firstName = $data[3];

    $estructura .= "  <owner>$userName</owner>\n".
                   "  <firstName>$firstName</firstName>\n".
                   "  <lastName>$lastName</lastName>\n";
  }

$estructura .= "</user>\n";

# Crear el archivo XML
open my $archivo, '>', "../htdocs/usuario.xml" or die "No se pudo abrir el archivo usuario.xml: $!";
print $archivo $estructura;
close $archivo;

if ($ingreso){
  print $cgi->redirect("http://localhost/list.html");
} else {
  print $cgi->redirect('http://localhost/accesoprueba.html');
}


#print $cgi->header('text/xml');
#print $estructura;