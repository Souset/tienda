<?php
include_once("bd.php");
iniciarSesionSiNoExiste();

$carrito = isset($_SESSION["carrito"]) && is_array($_SESSION["carrito"]) ? $_SESSION["carrito"] : array();
$productos = array();
$total = 0.0;

if (!empty($carrito)) {
    $idsSql = implode(",", array_map("intval", array_keys($carrito)));
    $productos = Query("SELECT id, titulo, PVP FROM productos WHERE id IN ($idsSql)");
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="utf-8">
    <title>Resumen de compra</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background: #f5f5f5; }
        .right { text-align: right; }
        .muted { color: #777; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>
    <h1>Resumen de compra</h1>
    <p class="muted">Usa “Imprimir” y selecciona “Guardar como PDF”.</p>

    <?php if (empty($productos)) { ?>
        <p>No hay productos en el carrito.</p>
    <?php } else { ?>
        <table>
            <thead>
                <tr>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th class="right">Precio</th>
                    <th class="right">Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($productos as $producto) {
                    $id = (int)$producto["id"];
                    $cantidad = isset($carrito[$id]) ? (int)$carrito[$id] : 0;
                    $precio = (float)$producto["PVP"];
                    $subtotal = $precio * $cantidad;
                    $total += $subtotal;
                ?>
                <tr>
                    <td><?php echo htmlspecialchars($producto["titulo"]); ?></td>
                    <td><?php echo $cantidad; ?></td>
                    <td class="right"><?php echo number_format($precio, 2, ",", "."); ?> €</td>
                    <td class="right"><?php echo number_format($subtotal, 2, ",", "."); ?> €</td>
                </tr>
                <?php } ?>
            </tbody>
            <tfoot>
                <tr>
                    <th colspan="3" class="right">Total</th>
                    <th class="right"><?php echo number_format($total, 2, ",", "."); ?> €</th>
                </tr>
            </tfoot>
        </table>
    <?php } ?>

    <p class="no-print" style="margin-top: 20px;">
        <button onclick="window.print()">Imprimir / Guardar PDF</button>
    </p>
</body>
</html>
