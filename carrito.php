<?php
include_once("bd.php");
iniciarSesionSiNoExiste();

if (!isset($_SESSION["carrito"]) || !is_array($_SESSION["carrito"])) {
    $_SESSION["carrito"] = array();
}

$accion = isset($_GET["accion"]) ? $_GET["accion"] : "";

if ($accion === "add" && isset($_POST["producto_id"])) {
    $productoId = max(0, (int)$_POST["producto_id"]);
    $cantidad = isset($_POST["cantidad"]) ? max(1, (int)$_POST["cantidad"]) : 1;

    $producto = Query("SELECT id, stock FROM productos WHERE id = $productoId LIMIT 1");
    if (!empty($producto)) {
        $stock = (int)$producto[0]["stock"];
        $actual = isset($_SESSION["carrito"][$productoId]) ? (int)$_SESSION["carrito"][$productoId] : 0;
        $nuevaCantidad = min($stock, $actual + $cantidad);
        $_SESSION["carrito"][$productoId] = $nuevaCantidad;
    }

    header("Location: carrito.php");
    exit;
}

if ($accion === "update" && isset($_POST["cantidades"]) && is_array($_POST["cantidades"])) {
    foreach ($_POST["cantidades"] as $id => $cantidad) {
        $productoId = max(0, (int)$id);
        $nuevaCantidad = max(0, (int)$cantidad);
        if ($nuevaCantidad === 0) {
            unset($_SESSION["carrito"][$productoId]);
            continue;
        }

        $producto = Query("SELECT stock FROM productos WHERE id = $productoId LIMIT 1");
        if (!empty($producto)) {
            $stock = (int)$producto[0]["stock"];
            $_SESSION["carrito"][$productoId] = min($stock, $nuevaCantidad);
        }
    }

    header("Location: carrito.php");
    exit;
}

if ($accion === "remove" && isset($_GET["id"])) {
    $productoId = max(0, (int)$_GET["id"]);
    unset($_SESSION["carrito"][$productoId]);
    header("Location: carrito.php");
    exit;
}

$ids = array_keys($_SESSION["carrito"]);
$productos = array();
$total = 0.0;

if (!empty($ids)) {
    $idsSql = implode(",", array_map("intval", $ids));
    $productos = Query("SELECT id, titulo, PVP, stock FROM productos WHERE id IN ($idsSql)");
}
?>
<!DOCTYPE html>
<html>
<?php include_once("head.php") ?>
<?php include_once("header.php") ?>
<?php include_once("barra_lateral_izq.php") ?>
<?php include_once("barra_lateral_derecha.php") ?>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">
    <div class="content-wrapper">
        <section class="content-header">
            <h1>Carrito</h1>
        </section>

        <section class="content container-fluid">
            <?php if (empty($productos)) { ?>
                <div class="alert alert-info">Tu carrito está vacío.</div>
            <?php } else { ?>
                <form method="post" action="carrito.php?accion=update">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Producto</th>
                                <th>Precio</th>
                                <th>Cantidad</th>
                                <th>Subtotal</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php foreach ($productos as $producto) {
                                $id = (int)$producto["id"];
                                $cantidad = isset($_SESSION["carrito"][$id]) ? (int)$_SESSION["carrito"][$id] : 0;
                                $subtotal = ((float)$producto["PVP"]) * $cantidad;
                                $total += $subtotal;
                            ?>
                                <tr>
                                    <td><?php echo htmlspecialchars($producto["titulo"]); ?></td>
                                    <td><?php echo number_format((float)$producto["PVP"], 2, ",", "."); ?> €</td>
                                    <td>
                                        <input
                                            type="number"
                                            class="form-control"
                                            style="width:90px"
                                            min="0"
                                            max="<?php echo (int)$producto["stock"]; ?>"
                                            name="cantidades[<?php echo $id; ?>]"
                                            value="<?php echo $cantidad; ?>">
                                    </td>
                                    <td><?php echo number_format($subtotal, 2, ",", "."); ?> €</td>
                                    <td><a class="btn btn-danger btn-xs" href="carrito.php?accion=remove&id=<?php echo $id; ?>">Quitar</a></td>
                                </tr>
                            <?php } ?>
                        </tbody>
                    </table>

                    <div class="text-right">
                        <h3>Total: <?php echo number_format($total, 2, ",", "."); ?> €</h3>
                        <button class="btn btn-primary" type="submit">Actualizar carrito</button>
                        <a class="btn btn-default" href="carrito_pdf.php" target="_blank">Imprimir / Guardar PDF</a>
                    </div>
                </form>
            <?php } ?>
        </section>
    </div>

    <?php include_once("footer.php") ?>
</div>

<script src="components/jquery/dist/jquery.min.js"></script>
<script src="components/bootstrap/dist/js/bootstrap.min.js"></script>
<script src="dist/js/adminlte.min.js"></script>
</body>
</html>
