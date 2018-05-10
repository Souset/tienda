<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once 'head.php'; ?>
<?php include_once 'header.php'; ?>

<?php
    $sql = 'SELECT id, titulo, imagen, PVP
            FROM productos
            WHERE id % 100 = 0';
    $productos = Query($sql);
    $total_productos = count($productos);

    if ($total_productos > 0) {
        $productos_pagina = 16;
    
        if(isset($_GET["pagina"])){
            $pagina=$_GET["pagina"];
            $inicio = ($pagina - 1) * $productos_pagina;
        } else {
            $inicio = 0;
            $pagina = 1;
        }

        $sql = "SELECT id, titulo, imagen, PVP
                FROM productos
                LIMIT $inicio, $productos_pagina";
        $productos = Query($sql);

        $total_paginas = ceil($total_productos / $productos_pagina);
    }

?>

<?php include_once 'barra_lateral_izq.php'; ?>
<?php include_once 'barra_lateral_derecha.php'; ?>


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
                    <small><?php echo date('d-m-Y'); ?></small>
                </h1>
                <ol class="breadcrumb">
                    <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                    <li class="active">Here</li>
                </ol>
            </section>

            <!-- Contenido Principal -->
            <section class="content container-fluid">

                    <div class="row">
                        <?php $contador = 0; ?>
                        <?php for ($i = 0; $i < count($productos); ++$i) { ?>
                        <?php ++$contador; ?>
                        <!-- Vista de targeta producto -->
                            <div class="col-xs-6 col-md-3">
                                <div class="mas_detalles">
                                    <a href="pagina_producto.php?id=<?php echo $productos[$i]['id']; ?>">
                                        <div class="thumbnail">
                                            <img src="<?php echo $productos[$i]['imagen']; ?>">
                                            <div class="caption">
                                                <center><h5 class="targeta_titulo"><?php echo $productos[$i]['titulo']; ?></h5>
                                                <br><br>
                                                <p class="targeta_precio"><b><?php echo $productos[$i]['PVP']; ?> €</b></p>
                                                </center>
                                                <br>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </div>
                             <!-- Fin Vista de targeta producto -->
                            <?php if ($contador == 4) {
                                echo "<div style='clear:both'></div>";
                                $contador = 0;
                            } ?>
                        <?php } ?>
                   </div>

                    <div class="row">
                                <div class="col-xs-12">
                                <nav aria-label="Page navigation">
                                <center>
                                    <ul class="pagination">
                                        <li  class="<?php if ($pagina == 1){echo "disabled";} ?>">
                                        <a href="<?php if ($pagina > 1) { echo "index.php?pagina=" . ($pagina - 1); } else { echo "#"; } ?>" aria-label="Anterior">
                                            <span aria-hidden="true">&laquo;</span>
                                        </a>
                                        </li>

                                        <?php $resto = $total_paginas % 10; ?>
                                        <?php if($resto == 0) { ?>
                                            <?php for($j=1; $j<=$total_paginas/10; $j++){ ?>
                                                <?php if($pagina>=$j*10-9 and $pagina<=$j*10){ ?>
                                                    <?php for($i=$j*10-9; $i<=$j*10; $i++){ ?>
                                                        <li class="<?php if ($pagina == $i) { echo "active"; } ?>">
                                                            <a href="<?php if ($pagina != $i) { echo "index.php?pagina=" . $i; } else { echo "#"; } ?>">
                                                                <?php echo $i?>
                                                            </a>
                                                        </li>
                                                    <?php } ?>
                                                <?php } ?>
                                            <?php } ?>
                                        <?php } else { ?>
                                            <?php for($j=1; $j<=$total_paginas/10+1; $j++){ ?>
                                                <?php if($pagina>=$j*10-9 and $pagina<=$j*10){ ?>
                                                    <?php for($i=$j*10-9; $i<=$j*10; $i++){ ?>
                                                        <?php if($i<=$total_paginas){ ?>
                                                            <li class="<?php if ($pagina == $i) { echo "active"; } ?>">
                                                                <a href="<?php if ($pagina != $i) { echo "index.php?pagina=" . $i; } else { echo "#"; } ?>">
                                                                    <?php echo $i?>
                                                                </a>
                                                            </li>
                                                        <?php } ?>
                                                    <?php } ?>
                                                <?php } ?>
                                            <?php } ?>
                                        <?php } ?>
                                        <li class="<?php if ($pagina == $total_paginas){echo "disabled";} ?>">
                                        <a href="<?php if ($pagina < $total_paginas) { echo "index.php?pagina=" . ($pagina + 1); } else { echo "#"; } ?>" aria-label="Siguiente">
                                            <span aria-hidden="true">&raquo;</span>
                                        </a>
                                        </li>
                                    </ul>
                                </center>
                                    
                                </nav>
                                </div>
                            </div>

            </section>
            
            <!-- /.content -->
       </div>
        <!-- /.content-wrapper -->


        <?php include_once 'footer.php';?>
  
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


