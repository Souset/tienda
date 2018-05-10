<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once("head.php")?>
<?php include_once("header.php")?>

<?php
    $subfamilia_id = $_GET["subfamilia"];
    $sql = "SELECT id, titulo, imagen, PVP
            FROM productos
            WHERE subfamilia = '$subfamilia_id'";
    $productos = Query($sql);
    
    $sql = "SELECT subfamilia, familia_fk
            FROM subfamilia
            WHERE id = '$subfamilia_id'";
    $subfamilia = Query($sql);
    
    $familia_fk = $subfamilia[0]["familia_fk"];
    
     $sql = "SELECT id, familia
             FROM familia
             WHERE id = '$familia_fk'";
    $familia = Query($sql);
?>

<?php include_once("barra_lateral_izq.php")?>
<?php include_once("barra_lateral_derecha.php")?>


<!--
BODY TAG OPTIONS:
=================
Aplicar una o más de las siguientes clases para obtener el
efecto deseado
|---------------------------------------------------------|
| SKINS         | skin-blue                               |
|               | skin-black                              |
|               | skin-purple                             |
|               | skin-yellow                             |
|               | skin-red                                |
|               | skin-green                              |
|---------------------------------------------------------|
|LAYOUT OPTIONS | fixed                                   |
|               | layout-boxed                            |
|               | layout-top-nav                          |
|               | sidebar-collapse                        |
|               | sidebar-mini                            |
|---------------------------------------------------------|
-->

<body class="hold-transition skin-blue sidebar-mini">
    <div class="wrapper">


        <!-- Contenedor del contenido. Contiene el contenido de la página -->
        <div class="content-wrapper">
            <!--  Contiene el encabezado y el contenido de la página. -->
            <section class="content-header">
                <h1>
                    <a href="pagina_familia.php?familia=<?php echo $familia[0]["id"] ?>"><?php echo $familia[0]["familia"] ?></a>
                    <small><?php echo $subfamilia[0]["subfamilia"] ?></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                    <li class="active">Here</li>
                </ol>
            </section>

            <!-- Contenido Principal -->
            <section class="content container-fluid">

                    <div class="row">
                        <?php $contador=0; ?>
                        <?php for($i=0; $i<count($productos); $i++) { ?>
                            <?php $contador++; ?>
                            <div class="col-xs-6 col-md-3">
                                <div class="mas_detalles">
                                    <a href="pagina_producto.php?id=<?php echo $productos[$i]["id"] ?>">
                                        <div class="thumbnail">
                                            <img src="<?php echo $productos[$i]["imagen"] ?>">
                                            <div class="caption">
                                                <center><h5 class="targeta_titulo"><?php echo $productos[$i]["titulo"] ?></h5>
                                                <br>
                                                <p class="targeta_precio"><b><?php echo $productos[$i]["PVP"] ?> €</b></p>
                                                </center>
                                                <br>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <?php if ($contador == 4) {echo "<div style='clear:both'></div>"; $contador = 0;} ?>
                        <?php } ?>
                   </div>
                   
            </section>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->


        <?php include_once("footer.php")?>
  
    </div>
    <!-- ./wrapper -->

    <!-- REQUIRED JS SCRIPTS -->

    <!-- jQuery 3 -->
    <script src="components/jquery/dist/jquery.min.js"></script>
    <!-- Bootstrap 3.3.7 -->
    <script src="components/bootstrap/dist/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/adminlte.min.js"></script>

    <!-- Opcionalmente, puede agregar complementos Slimscroll y FastClick.
      Se recomiendan estos dos complementos para mejorar el
      experiencia de usuario. -->
</body>

</html>
