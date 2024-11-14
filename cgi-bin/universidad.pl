
Memoria actualizada
Voy a guiarte en la implementación de este proyecto. Aquí te proporciono los pasos y el código necesario para crear los archivos:

Formulario HTML - Este archivo permitirá al usuario seleccionar el criterio de búsqueda y proporcionar el término de búsqueda.

Script CGI en Perl - Procesará la entrada del usuario, buscará en el archivo universidades.csv y devolverá los resultados en una página HTML.

CSS - Opcionalmente, un archivo CSS para estilizar el formulario y los resultados.

1. Formulario HTML (index.html)
Este archivo debería estar en la carpeta raíz (/var/www/html/index.html).

html
Copiar código
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Búsqueda de Universidades</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <h1>Búsqueda de Universidades Licenciadas</h1>
    <form action="/cgi-bin/universidad.pl" method="post">
        <label for="criterio">Criterio de búsqueda:</label>
        <select name="criterio" id="criterio">
            <option value="nombre">Nombre Universidad</option>
            <option value="periodo">Periodo Licenciamiento</option>
            <option value="departamento">Departamento Local</option>
            <option value="programa">Denominación Programa</option>
        </select>
        <br><br>
        <label for="valor">Valor de búsqueda:</label>
        <input type="text" name="valor" id="valor" required>
        <br><br>
        <button type="submit">Buscar</button>
    </form>
</body>
</html>
2. Script CGI en Perl (universidad.pl)
Este script leerá el archivo universidades.csv, filtrará los resultados en función del criterio y valor ingresados, y generará una respuesta en HTML.

Crea este archivo en la carpeta /cgi-bin/ (especificado en tu Dockerfile).

perl
Copiar código
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
    my ($nombre, $periodo, $departamento, $programa) = split /,/, $line;

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