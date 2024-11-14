#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $cgi = CGI->new;
print $cgi->header(-type => "text/html", -charset => "UTF-8");

# Obtiene los parámetros del formulario
my $criterio = $cgi->param("criterio");
my $valor = $cgi->param("valor");

# Lee el archivo CSV
open my $fh, "<", "/usr/lib/cgi-bin/universidades.csv" or die "No se pudo abrir el archivo CSV: $!";

# Imprime encabezado HTML
print "<html><head><title>Resultados de la búsqueda</title></head><body>";
print "<h1>Resultados de la búsqueda</h1>";
print "<table border='1'><tr><th>Nombre Universidad</th><th>Periodo Licenciamiento</th><th>Departamento Local</th><th>Denominación Programa</th></tr>";

# Lee y procesa cada línea del archivo CSV
while (my $line = <$fh>) {
    chomp $line;
    my ($nombre, $periodo, $departamento, $programa) = split /|/, $line;

    # Filtra de acuerdo al criterio seleccionado
    if (($criterio eq "nombre" && $nombre =~ /\Q$valor\E/i) ||
        ($criterio eq "periodo" && $periodo =~ /\Q$valor\E/i) ||
        ($criterio eq "departamento" && $departamento =~ /\Q$valor\E/i) ||
        ($criterio eq "programa" && $programa =~ /\Q$valor\E/i)) {

        # Imprime los resultados en una tabla
        print "<tr><td>$nombre</td><td>$periodo</td><td>$departamento</td><td>$programa</td></tr>";
    }
}

print "</table>";
print "</body></html>";

close $fh;