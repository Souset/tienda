<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once 'head.php'; ?>
<?php include_once 'header.php'; ?>

<?php
    if (isset($_GET['id'])) {
        $id = $_GET['id'];
        $sql = "SELECT *
                FROM productos
                WHERE id = '$id'";
        $producto = Query($sql);

        $familia_producto = $producto[0]['familia'];
        $subfamilia_producto = $producto[0]['subfamilia'];

        $sql = "SELECT titulo, imagen, PVP, id
                FROM productos
                WHERE familia = '$familia_producto' AND id % 50 = 0";
        $familia_rel = Query($sql);

        $sql = "SELECT familia, id
                FROM familia
                WHERE id = '$familia_producto'";
        $familia = Query($sql);

        $sql = "SELECT familia.id as familia_id, familia.familia, subfamilia.id as subfamilia_id, subfamilia.subfamilia
                FROM productos, familia, subfamilia
                WHERE productos.familia = familia.id AND productos.subfamilia = subfamilia.id AND productos.id = '$id'";
        $familia_subfamilia = Query($sql);
    }

    //Recoge el texto del CK Editor
    $texto="";
    if(isset($_POST['editor1'])){
        
        $texto=$_POST['editor1'];

        $sql = "UPDATE productos SET subtitulo = '$texto' WHERE id = '$id'";
        $resultado = QueryAccion($sql);
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


            <!-- Contenedor. Contenido de toda la página -->
            <div class="content-wrapper">
                <!--  Contiene el encabezado y el contenido de la página. -->
                <section class="content-header">
                    <h1>
                        <a href="pagina_familia.php?familia=<?php echo $familia_subfamilia[0]['familia_id']; ?>">
                            <?php echo $familia_subfamilia[0]['familia']; ?>
                        </a>
                        <small><a href="pagina_subfamilia.php?subfamilia=<?php echo $familia_subfamilia[0]['subfamilia_id']; ?>"><?php echo $familia_subfamilia[0]['subfamilia']; ?></a></small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                        <li class="active">Here</li>
                    </ol>
                </section>

                <!-- Contenido Principal -->
                <section class="content container-fluid">

                    <div class="row">
                        <!-- ZONA SUPERIOR (IMAGEN + PRECIO) -->
                        <div class="col-md-6">
                            <div class="thumbnail">
                                <div id="myCarousel" class="carousel slide" data-ride="carousel">
                                    <!-- Wrapper for slides -->
                                    <div class="carousel-inner">
                                        <div class="item active">
                                            <img src="<?php echo $producto[0]['imagen']; ?>" class="imagen100">
                                        </div>
                                        <!-- End Item -->
                                        <?php if ($producto[0]['imagenGaleria1'] != '') {?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]['imagenGaleria1']; ?>" class="imagen100">
                                        </div>
                                        <!-- End Item -->
                                        <?php } ?>
                                        <?php if ($producto[0]['imagenGaleria2'] != '') {?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]['imagenGaleria2']; ?>" class="imagen100">
                                        </div>
                                        <!-- End Item -->
                                        <?php } ?>
                                        <?php if ($producto[0]['imagenGaleria3'] != '') {?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]['imagenGaleria3']; ?>" class="imagen100">
                                        </div>
                                        <!-- End Item -->
                                        <?php } ?>
                                    </div>
                                    <!-- End Carousel Inner -->
                                    <br>
                                    <div class="row miniaturas">
                                        <ul class="nav nav-pills nav-justified">
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="0" class="active"><a href="#"><img src="<?php echo $producto[0]['imagen']; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php if ($producto[0]['imagenGaleria1'] != '') { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="1"><a href="#"><img src="<?php echo $producto[0]['imagenGaleria1']; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                            <?php if ($producto[0]['imagenGaleria2'] != '') { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="2"><a href="#"><img src="<?php echo $producto[0]['imagenGaleria2']; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                            <?php if ($producto[0]['imagenGaleria3'] != '') { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="3"><a href="#"><img src="<?php echo $producto[0]['imagenGaleria3']; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="thumbnail margen_interno_20">
                                <?php
                                    if (strpos($producto[0]['titulo'], 'Blanco ')) {
                                        $titulo = substr($producto[0]['titulo'], 0, strpos($producto[0]['titulo'], 'Blanco '));
                                        $tonalidad = substr($producto[0]['titulo'], strpos($producto[0]['titulo'], 'Blanco '));
                                    } else {
                                        $titulo = $producto[0]['titulo'];
                                        $tonalidad = '';
                                    }
                                    switch ($tonalidad) {
                                        case 'Blanco neutro':
                                            $color_texto = 'blanco_neutro';
                                            break;
                                        case 'Blanco frío':
                                            $color_texto = 'blanco_frio';
                                            break;
                                        case 'Blanco cálido':
                                            $color_texto = 'blanco_calido';
                                            break;
                                    }
                                ?>
                                    <div class="row">
                                        <h4 class="producto_titulo">
                                            <strong>
                                            <div class="col-md-7">
                                                <p><?php echo $titulo; ?></p>
                                            </div>
                                            <div class="col-md-5">
                                                <p><span class="<?php echo $color_texto; ?>"><?php echo $tonalidad; ?></span></p>
                                            </div>
                                        </strong>
                                        </h4>
                                    </div>
                                    <div class="row">
                                        <div class="col-xs-6 col-md-3">
                                            <h1 class="producto_precio">
                                                <?php echo $producto[0]['PVP']; ?> €</h1>
                                        </div>
                                        <div class="col-xs-6 col-md-4 texto_gris">
                                            <h3 class="producto_precio_sin_IVA">
                                                <?php echo round($producto[0]['PVP'] / 1.21, 2); ?> €</h3><span>sin iva</span></div>
                                    </div>
                            </div>
                            <div class="thumbnail margen_interno_20">
                                <?php
                                    if ($producto[0]['stock'] == 0) {
                                        $hay_stock = "<span class='texto_rojo'><i class='fas fa-times-circle'></i> sin stock</span>";
                                    } else {
                                        $hay_stock = "<span class='texto_verde'><i class='fas fa-check-circle'></i> Envío en 24 horas</span>";
                                    }
                                ?>
                                    <div class="row">
                                        <div class="col-xs-3 texto_gris">REF:
                                            <?php echo $producto[0]['codigo']; ?>
                                        </div>
                                        <div class="col-xs-5">Hay en stock <b><?php echo $producto[0]['stock']; ?></b> unidades</div>
                                        <div class="col-xs-4"><b> <?php echo $hay_stock; ?></b></div>
                                    </div>
                                    <hr>
                                    <div class="row margen_interno_20">
                                        <table class="table table-striped table-condensed">
                                            <tbody>
                                                <tr>
                                                    <td>Referencia</td>
                                                    <th><?php echo $producto[0]['codigo']; ?></th>
                                                </tr>
                                                <?php if ($producto[0]['horas'] != '') { ?>
                                                    <tr>
                                                        <td>Autonomía</td>
                                                        <th><?php echo $producto[0]['horas']; ?></th>
                                                    </tr>
                                                <?php  } ?>
                                                <?php if ($producto[0]['potencia'] != '') { ?>
                                                    <tr>
                                                        <td>Potencia</td>
                                                        <th><?php echo $producto[0]['potencia']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['flujo_luminoso'] != '') { ?>
                                                    <tr>
                                                        <td>Flujo luminoso</td>
                                                        <th><?php echo $producto[0]['flujo_luminoso']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['angulo_apertura'] != '') { ?>
                                                    <tr>
                                                        <td>Ángulo de apertura</td>
                                                        <th><?php echo $producto[0]['angulo_apertura']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['alimentacion'] != '') { ?>
                                                    <tr>
                                                        <td>Alimentación</td>
                                                        <th><?php echo $producto[0]['alimentacion']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['temperatura'] != '') { ?>
                                                    <tr>
                                                        <td>Temperatura de calor</td>
                                                        <th><?php echo $producto[0]['temperatura']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['num_leds'] != '') { ?>
                                                    <tr>
                                                        <td>Número de leds</td>
                                                        <th><?php echo $producto[0]['num_leds']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['interior_exteior'] != '') { ?>
                                                    <tr>
                                                        <td>Interior-exterior</td>
                                                        <th><?php echo $producto[0]['interior_exteior']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['proteccion_ip'] != '') { ?>
                                                    <tr>
                                                        <td>Protección IP</td>
                                                        <th><?php echo $producto[0]['proteccion_ip']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['codigo'] != '') { ?>
                                                       <tr>
                                                        <td>Aislamiento eléctrico</td>
                                                        <th><?php echo $producto[0]['codigo']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['ancho_mm'] != '' && $producto[0]['largo_mm'] != '' && $producto[0]['alto_mm'] != '') { ?>
                                                    <tr>
                                                        <td>Dimensiones del producto</td>
                                                        <th><?php echo $producto[0]['ancho_mm'].'x'.$producto[0]['largo_mm'].'x'.$producto[0]['alto_mm'].'mm'; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['ancho_cm'] != '' && $producto[0]['largo_cm'] != '' && $producto[0]['alto_cm'] != '') { ?>
                                                    <tr>
                                                        <td>Dimensiones del paquete</td>
                                                        <th><?php echo $producto[0]['ancho_cm'].'x'.$producto[0]['largo_cm'].'x'.$producto[0]['alto_cm'].'cm'; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['peso_kg'] != '') { ?>
                                                    <tr>
                                                        <td>Peso del paquete</td>
                                                        <th><?php echo $producto[0]['peso_kg'].'Kg'; ?></th>
                                                    </tr>
                                                <?php } ?>
                                                <?php if ($producto[0]['certificados'] != '') { ?>
                                                    <tr>
                                                        <td>Certificados</td>
                                                        <th><?php echo $producto[0]['certificados']; ?></th>
                                                    </tr>
                                                <?php } ?>
                                            </tbody>
                                        </table>
                                    </div>
                            </div>
                        </div>
                    </div>
                    <br>
                    <!-- Descripción del producto -->
                    <div class="row">
                        <div class="col-md-8">
                            <div class="thumbnail margen_interno_20">
                                <?php echo $producto[0]['subtitulo']; ?>
                                <?php //echo $texto;?>
                            </div>
                        </div>
                        
                    <!-- Fin Descripción del producto 
                    <!-- CK Editor 
                    <div class="row">
                        <div class="col-md-8">
                            <div class="thumbnail">
                                <?php //include("editor.php"); ?>
                            </div>
                        </div>
                     -->    
                    <!-- Fin Fin CK Editor -->      
                        <div class="col-md-4">
                            <h3>PRODUCTOS MISMA CATEGORÍA</h3>
                            <?php for ($i = 0; $i < count($familia_rel); ++$i) {
                                    ?>
                            <a href="pagina_producto.php?id=<?php echo $familia_rel[$i]['id']; ?>">
                                <div class="thumbnail targeta_peq">
                                    <div class="row">
                                        <div class="col-xs-4"><img src="<?php echo $familia_rel[$i]['imagen']; ?>" class="imagen100"></div>
                                        <div class="col-xs-8">
                                            <div class="familia_titulo">
                                                <?php echo $familia_rel[$i]['titulo']; ?>
                                            </div>
                                            <div>
                                                <h3 class="familia_precio">
                                                    <?php echo $familia_rel[$i]['PVP']; ?> €</h3>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </a>
                            <?php } ?>
                        </div>
                    </div>

                </section>
                <!-- /.content -->
            </div>
            <!-- /.content-wrapper -->


            <?php include_once 'footer.php'; ?>

        </div>
        <!-- ./wrapper -->

        <!-- REQUIRED JS SCRIPTS -->

        <!-- jQuery 3 -->
        <script src="components/jquery/dist/jquery.min.js"></script>
        <!-- Bootstrap 3.3.7 -->
        <script src="components/bootstrap/dist/js/bootstrap.min.js"></script>
        <!-- AdminLTE App -->
        <script src="dist/js/adminlte.min.js"></script>
        
        <!-- CK Editor -->
        <script src="components/ckeditor/ckeditor.js"></script>
        <!-- FastClick Botones de CK Editor-->
        <script src="components/fastclick/lib/fastclick.js"></script>
            <script>
            $(function () {
                // Replace the <textarea id="editor1"> with a CKEditor
                // instance, using default configuration.
                CKEDITOR.replace('editor1')
                
            })
            </script>

        <!-- Opcionalmente, puede agregar complementos Slimscroll y FastClick.
      Se recomiendan estos dos complementos para mejorar el
      experiencia de usuario. -->
    
        <script>
            $(document).ready(function() {
                $('#myCarousel').carousel({
                    interval: null
                });

                var clickEvent = false;
                $('#myCarousel').on('click', '.nav div li a', function() {
                    clickEvent = true;
                    $('.nav div li').removeClass('active');
                    $(this).parent().addClass('active');
                }).on('slid.bs.carousel', function(e) {
                    if (!clickEvent) {
                        var count = $('.nav div').children().length - 1;
                        var current = $('.nav div li .active');
                        current.removeClass('active').next().addClass('active');
                        var id = parseInt(current.data('slide-to'));
                        if (count == id) {
                            $('.nav div li').first().addClass('active');
                        }
                    }
                    clickEvent = false;
                });
            });

        </script>
    </body>

</html>
