<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once("head.php")?>
<?php include_once("header.php")?>

<?php
    if (isset($_POST["id"])) {
        $id = $_POST["id"];
        $sql = "SELECT *
                FROM productos
                WHERE id = '$id'";
        $producto = Query($sql);
    }
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
                    Encabezado de página
                    <small>Descripción opcional</small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                    <li class="active">Here</li>
                </ol>
            </section>

            <!-- Contenido Principal -->
            <section class="content container-fluid">

                    <div class="row">
                    <?php 
                        echo $producto[0]["nombre"];
                    ?>
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
