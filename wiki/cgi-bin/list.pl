#!"c:\xampp\perl\bin\perl.exe"
use CGI ':standard';
use DBI;

my $user = 'root';
my $password = '369789';
my $dsn = "DBI:mysql:database=wikipedia;host=localhost";
my $dbh = DBI->connect($dsn, $user, $password) or die("No se pudo conectar!");


my $sth = $dbh->prepare("SELECT title FROM articles");
$sth->execute();

$dbh->disconnect;

print header,
start_html(-title=>"Lista Paginas Web"),
h1 ("Nuestras paginas de wiki"),
ul({-style => "margin-left: -20px;"});
#ul;
while (my $title = $sth->fetchrow_array) {
    print li({-style => "margin-bottom: 10px;"},
        a({-href => "view.pl?title=$title", -style => "display: inline-block;"}, "$title"),
        start_form(-action => 'delete.pl', -method => 'get', -style => "display: inline-block;"),
        hidden(-name => 'title', -value => $title),
        submit(-type => 'submit', -value => 'X'),
        end_form,
        start_form(-action => 'edit.pl', -method => 'get', -style => "display: inline-block;"),
        hidden(-name => 'title', -value => $title),
        submit(-type => 'submit', -value => 'E'),
        end_form);

        
}
print "</ul>",
hr,
a({-href => 'http://localhost/new.html'}, 'Nueva Pagina'),
br,
a({-href => 'http://localhost/index.html'}, 'Volver al Inicio'),
end_html;

    #print li(a({-href => "view.pl?title=$title"}, "$title"));

    #print start_form(-action => 'delete.pl', -method => 'get'),
    #    hidden(-name => 'title', -value => $title),
    #    submit(-type => 'submit', -value => 'X'),
    #    end_form,
    #    "&nbsp;",  # Espacio entre los botones,
    #    start_form(-action => 'edit.pl', -method => 'get'),
    #    hidden(-name => 'title', -value => $title),
    #    submit(-type => 'submit', -value => 'E'),
    #    end_form;

        #form({-action => 'delete.pl', -method => 'get'},
        #    hidden(-name => 'title', -value => $title),
        #    submit(-type => 'submit', -value => 'X')),
        #form({-action => 'edit.pl', -method => 'get'},
        #    hidden(-name => 'title', -value => $title),
        #    submit(-type => 'submit', -value => 'E')));