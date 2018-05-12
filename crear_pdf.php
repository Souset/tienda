<?php
    include("bd.php");
    if (isset($_GET["id"])) {
        $id = $_GET["id"];
        $sql = "SELECT *
                FROM productos
                WHERE id = '$id'";
        $producto = Query($sql);
    }

    require('components/fpdf/fpdf.php');

    $pdf = new FPDF();
    $pdf->AddPage();
    $pdf->SetFont('Arial','B',16);
    $pdf->Image($producto[0]["imagen"],15,10,30);
    $pdf->Ln(7);
    $pdf->Cell(40);
    $pdf->Cell(10,10, $producto[0]["titulo"]);
    $pdf->Ln(10);
    $pdf->Cell(40);
    $pdf->SetFont('Arial','',12);
    $pdf->Cell(10,10, "Precio: " . $producto[0]["PVP"] . " €");
    $pdf->Ln(20);
    $pdf->Cell(10);
    $pdf->SetFont('Arial','',10);
    $pdf->Cell(10,10, "Precio: " . $producto[0]["PVP"] . " €");
    $pdf->Ln(10);
    $pdf->Cell(10);
    $pdf->Cell(10,10, "Referencia: " . $producto[0]["codigo"]);
    $pdf->Ln(10);
    $pdf->Cell(10);
    if ($producto[0]["horas"] != "") {
        $pdf->Cell(10,10, "Autonomía: " . $producto[0]["horas"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["potencia"] != "") {
        $pdf->Cell(10,10, "Potencia: " . $producto[0]["potencia"] . " W");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["flujo_luminoso"] != "") {
        $pdf->Cell(10,10, "Flujo luminoso: " . $producto[0]["flujo_luminoso"] . "lm");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["angulo_apertura"] != "") {
        $pdf->Cell(10,10, "Ángulo de apertura: " . $producto[0]["angulo_apertura"] . "º");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["alimentacion"] != "") {
        $pdf->Cell(10,10, "Alimentación: " . $producto[0]["alimentacion"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["temperatura"] != "") {
        $pdf->Cell(10,10, "Temperatura de calor: " . $producto[0]["temperatura"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["num_leds"] != "") {
        $pdf->Cell(10,10, "Número de leds: " . $producto[0]["num_leds"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["interior_exteior"] != "") {
        $pdf->Cell(10,10, "Interior-exterior: " . $producto[0]["interior_exteior"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["proteccion_ip"] != "") {
        $pdf->Cell(10,10, "Protección IP: " . $producto[0]["proteccion_ip"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["proteccion_ik"] != "") {
        $pdf->Cell(10,10, "Protección IK: " . $producto[0]["proteccion_ik"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["ancho_mm"] != "") {
        $pdf->Cell(10,10, "Dimensiones del producto: " . $producto[0]["ancho_mm"] . "x".$producto[0]["largo_mm"] . "x" . $producto[0]["alto_mm"] . " mm");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["ancho_cm"] != "") {
        $pdf->Cell(10,10, "Dimensiones del paquete: " . $producto[0]["ancho_cm"] . "x" . $producto[0]["largo_cm"] . "x" . $producto[0]["alto_cm"] . " cm");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["peso_kg"] != "") {
        $pdf->Cell(10,10, "Peso del paquete: " . $producto[0]["peso_kg"] . "Kg");
        $pdf->Ln(10);
        $pdf->Cell(10);
    }
    if ($producto[0]["certificados"] != "") {
        $pdf->Cell(10,10, "Certificados: " . $producto[0]["certificados"]);
        $pdf->Ln(10);
        $pdf->Cell(10);
    }

    $pdf->Output();
?>
