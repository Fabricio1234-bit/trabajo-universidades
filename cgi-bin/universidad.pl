#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use utf8;
use Text::CSV;

my $cgi = CGI->new;
$cgi->charset('UTF-8');
print $cgi->header('text/html; charset=UTF-8');

print <<HTML;
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" type="text/css" href="../css/style.css">
    <title>Consulta de Universidades Licenciadas</title>
</head>
<body>
    <div class ="wrapper">
        <div class ="mytitle">
            <h1>Resultados de la búsqueda</h1>
        </div>
        <div class ="answer">
            <div class="table-container">
HTML

my $parametro = $cgi->param('parametro');
my $buscar = $cgi->param('buscar');
if(!($parametro eq "period")){
    $buscar = uc($buscar);
}

my $flag;
open(IN, "Programas_de_Universidades.csv") or die "<h2>ERROR: no se pudo abrir el archivo</h2>";

if(<IN>){
    print<<BLOCK;
    <table>
    <tr>
        <th>Código</th><th>Nombre</th><th>Tipo de Gestión</th><th>Estado de Licenciamiento</th><th>Periodo de Licenciamiento</th><th>Departamento Filial</th><th>Provincia Filial</th><th>Departamento Local</th><th>Provincia Local</th><th>Distrito Local</th><th>Tipo de Autorización</th><th>Programa</th><th>Tipo de Nivel Académico</th><th>Nivel Académico</th><th>Tipo de Autorización del Programa</th>
    </tr>
BLOCK
}

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

while(my $line = <IN>){
    my %dict = encontrarLinea($line);
    my $value = $dict{$parametro};
    if(defined($value) && $value =~ /.*$buscar.*/){
        if($line =~ m/(.+?)\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|(.+?)\|.+?\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|(.+?)\|(.+?)\|(.+?)\|.+?\|.+?\|(.+?)\|.+/){
            print "<tr>\n";
            print "<td>$1</td>\n";
            print "<td>$2</td>\n";
            print "<td>$3</td>\n";
            print "<td>$4</td>\n";
            print "<td>$5</td>\n";
            print "<td>$6</td>\n";
            print "<td>$7</td>\n";
            print "<td>$8</td>\n";
            print "<td>$9</td>\n";
            print "<td>$10</td>\n";
            print "<td>$11</td>\n";
            print "<td>$12</td>\n";
            print "<td>$13</td>\n";
            print "<td>$14</td>\n";
            print "<td>$15</td>\n";
            $flag = 1;
            print "</tr>\n";
            next;
        }
    }
}

close(IN);
if(!defined($flag)){
    print "<p> No se han encontrado resultados</p>\n";
}
print <<HTML;
    </table>
        </div>
    </div>
    <a href="../index.html">Volver al menu</a>
</body>
</html>
HTML

sub encontrarLinea{
    my %dict = ();
    my $line = $_[0];
    if($line =~ m/.+?\|(.+?)\|.+?\|.+?\|(.+?)\|.+?\|.+?\|.+?\|.+?\|.+?\|(.+?)\|.+?\|.+?\|.+?\|.+?\|.+?\|(.+?)\|.+/){
        $dict{"name"} = $1;
        $dict{"period_L"} = $2;
        $dict{"region"} = $3;
        $dict{"program"} = $4;
    }
    return %dict;
}