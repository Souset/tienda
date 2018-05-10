<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once("head.php")?>
<?php include_once("header.php")?>
<?php include_once("barra_lateral_izq.php")?>
<?php include_once("barra_lateral_derecha.php")?>



<?php

    if(isset($_GET["buscar"])){
        $termino_buscar = $_GET["buscar"];

        /*$sql = "SELECT * FROM productos WHERE titulo LIKE '%termino_buscar%'";
        $resultados = Query($sql);*/

        $sql = "SELECT * FROM productos WHERE titulo LIKE '%$termino_buscar%' OR subtitulo LIKE '%$termino_buscar%' LIMIT 45";
        $resultados = Query($sql);

    }


?>

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
                    <b>DESTACADOS</b> DE LA SEMANA
                    <small><?php echo date("d-m-Y"); ?></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                    <li class="active">Here</li>
                </ol>
            </section>

            <!-- Contenido Principal -->
            <section class="content container-fluid">

                    <div class="row">
                       <?php if (is_array($resultados)) { ?>
                        <?php $contador=0; ?>
                        <?php for($i=0; $i<count($resultados); $i++) { ?>
                        <?php $contador++; ?>
                            <div class="col-xs-6 col-md-3">
                                <div class="mas_detalles">
                                    <a href="pagina_producto.php?id=<?php echo $resultados[$i]["id"] ?>">
                                        <div class="thumbnail">
                                            <img src="<?php echo $resultados[$i]["imagen"] ?>">
                                            <div class="caption">
                                                <center><h5 class="targeta_titulo"><?php echo $resultados[$i]["titulo"] ?></h5>
                                                <br><br>
                                                <p class="targeta_precio"><b><?php echo $resultados[$i]["PVP"] ?> €</b></p>
                                                </center>
                                                <br>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                            <?php if ($contador == 4) {echo "<div style='clear:both'></div>"; $contador = 0;} ?>
                        <?php } ?>
                        <?php } else { ?>
                            <div class="container">
                                <div class="alert alert-warning" role="alert">
                                    <h2><i class="fas fa-exclamation-triangle"></i>  No se han encontrado resultados</h2>
                                </div>
                            </div>
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
