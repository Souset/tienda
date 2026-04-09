<?php

function Conectarse()
{
    $servidor = "localhost";
    $usuario = "root";
    $clave = "";
    $baseDatos = "ledbox";

    $link = mysqli_connect($servidor, $usuario, $clave, $baseDatos);
    if (!$link) {
        error_log("Error conectando a la base de datos: " . mysqli_connect_error());
        return null;
    }

    if (!mysqli_select_db($link, $baseDatos)) {
        error_log("Error seleccionando la base de datos: " . mysqli_error($link));
        mysqli_close($link);
        return null;
    }

    mysqli_set_charset($link, "utf8");
    return $link;
}

/* Utilízala para consultas */
function Query($query)
{
    $devolver = array();
    $link = Conectarse();
    if (!$link) {
        return $devolver;
    }

    $result = mysqli_query($link, $query);
    if ($result === false) {
        error_log("Error en Query: " . mysqli_error($link) . " | SQL: " . $query);
        mysqli_close($link);
        return $devolver;
    }

    while ($row = mysqli_fetch_assoc($result)) {
        $devolver[] = $row;
    }

    mysqli_free_result($result);
    mysqli_close($link);
    return $devolver;
}

/* Utilízala para inserciones, actualizaciones y borrados */
function QueryAccion($query)
{
    $link = Conectarse();
    if (!$link) {
        return 0;
    }

    $result = mysqli_query($link, $query);
    if ($result === false) {
        error_log("Error en QueryAccion: " . mysqli_error($link) . " | SQL: " . $query);
        mysqli_close($link);
        return 0;
    }

    $id = mysqli_insert_id($link);
    mysqli_close($link);
    return (int)$id;
}

function limpiarEnteroGet($clave, $valorPorDefecto = 0)
{
    if (!isset($_GET[$clave])) {
        return (int)$valorPorDefecto;
    }
    return max(0, (int)$_GET[$clave]);
}

function escapeTexto($texto)
{
    $link = Conectarse();
    if (!$link) {
        return "";
    }
    $limpio = mysqli_real_escape_string($link, (string)$texto);
    mysqli_close($link);
    return $limpio;
}

function iniciarSesionSiNoExiste()
{
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
}

?>
