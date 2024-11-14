#!/usr/bin/perl
use strict;
use warnings;
use CGI;

my $query = CGI->new;
print $query->header('text/html; charset=UTF-8');

# Leer parámetros del formulario
my $nombre_universidad = $query->param('nombre_universidad') // '';
my $periodo_licenciamiento = $query->param('periodo_licenciamiento') // '';
my $departamento_local = $query->param('departamento_local') // '';
my $denominacion_programa = $query->param('denominacion_programa') // '';

# Variables de regex para cada parámetro
$nombre_universidad = qr/\Q$nombre_universidad\E/i if $nombre_universidad;
$periodo_licenciamiento = qr/\Q$periodo_licenciamiento\E/i if $periodo_licenciamiento;
$departamento_local = qr/\Q$departamento_local\E/i if $departamento_local;
$denominacion_programa = qr/\Q$denominacion_programa\E/i if $denominacion_programa;

# Leer y procesar el archivo universidades.csv
my $file = '/usr/lib/cgi-bin/universidades.csv';
open my $fh, '<', $file or die "No se pudo abrir el archivo: $!";

print "<html><body><h1>Resultados de la Búsqueda</h1><ul>";

# Procesar cada línea del archivo
while (my $line = <$fh>) {
    chomp $line;
    my @fields = split /\|/, $line;

    # Mapear los campos relevantes
    my $nombre = $fields[1];
    my $periodo = $fields[6];
    my $departamento = $fields[12];
    my $programa = $fields[18];

    # Filtrar por expresiones regulares si se han especificado
    if ((!$nombre_universidad || $nombre =~ $nombre_universidad) &&
        (!$periodo_licenciamiento || $periodo =~ $periodo_licenciamiento) &&
        (!$departamento_local || $departamento =~ $departamento_local) &&
        (!$denominacion_programa || $programa =~ $denominacion_programa)) {
        
        # Imprimir los resultados coincidentes
        print "<li><b>Nombre:</b> $nombre<br>";
        print "<b>Periodo Licenciamiento:</b> $periodo<br>";
        print "<b>Departamento Local:</b> $departamento<br>";
        print "<b>Denominación Programa:</b> $programa<br><br></li>";
    }
}
print "</ul></body></html>";
close $fh;