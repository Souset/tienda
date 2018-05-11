<!DOCTYPE html>
<!--
Esta es una página de plantilla inicial. Use esta página para comenzar su nuevo proyecto
rasguño. Esta página elimina todos los enlaces y proporciona solo el marcado necesario.
-->
<html>
<?php include_once("head.php")?>
<?php include_once("header.php")?>

<?php
    if (isset($_GET["id"])) {
        $id = $_GET["id"];
        $sql = "SELECT *
                FROM productos
                WHERE id = '$id'";
        $producto = Query($sql);
        
        $familia_producto = $producto[0]["familia"];
        $subfamilia_producto = $producto[0]["subfamilia"];
        
        $sql = "SELECT id
                FROM productos
                WHERE familia = '$familia_producto'";
        $familia_rel = Query($sql);
        
        if (is_array($familia_rel)) {
            $total_productos_familia_rel = count($familia_rel);
            $productos_pagina = 5;
            $inicio = 0;
            if ($total_productos_familia_rel > $productos_pagina) {
                $inicio = mt_rand(0, $total_productos_familia_rel-$productos_pagina);
            }

            $sql = "SELECT titulo, imagen, PVP, id
                    FROM productos
                    WHERE familia = '$familia_producto'
                    LIMIT $inicio, $productos_pagina";
            $familia_rel = Query($sql);

        }
        
        $sql = "SELECT familia, id
                FROM familia
                WHERE id = '$familia_producto'";
        $familia = Query($sql);
        
        $sql = "SELECT familia.id as familia_id, familia.familia, subfamilia.id as subfamilia_id, subfamilia.subfamilia
                FROM productos, familia, subfamilia
                WHERE productos.familia = familia.id AND productos.subfamilia = subfamilia.id AND productos.id = '$id'";
        $familia_subfamilia = Query($sql);
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

    <!-- INICIO CONTENEDOR DEL CONTENIDO -->
            <div class="content-wrapper">
               
        <!--  INICIO FAMILIA Y SUBFAMILIA (MIGA DE PAN) -->
                <section class="content-header">
                    <h1>
                        <a href="pagina_familia.php?familia=<?php echo $familia_subfamilia[0]["familia_id"] ?>">
                            <?php echo $familia_subfamilia[0]["familia"] ?>
                        </a>
                        <small><a href="pagina_subfamilia.php?subfamilia=<?php echo $familia_subfamilia[0]["subfamilia_id"] ?>"><?php echo $familia_subfamilia[0]["subfamilia"] ?></a></small>
                    </h1>
                    <ol class="breadcrumb">
                        <li><a href="#"><i class="fa fa-dashboard"></i> Level</a></li>
                        <li class="active">Here</li>
                    </ol>
                </section>
        <!--  FIN FAMILIA Y SUBFAMILIA (MIGA DE PAN) -->

        <!-- INICIO CONTENIDO PRINCIPAL -->
                <section class="content container-fluid">

            <!-- INICIO ZONA SUPERIOR -->
                    <div class="row">
                    
                <!-- INICIO IMÁGENES -->
                        <div class="col-md-6">
                            <div class="thumbnail">
                                <div id="myCarousel" class="carousel slide" data-ride="carousel">
                                    
                            <!-- INICIO IMÁGENES GRANDES -->
                                    <div class="carousel-inner">
                                        <div class="item active">
                                            <img src="<?php echo $producto[0]["imagen"]; ?>" class="imagen100">
                                        </div>
                                        <?php if ($producto[0]["imagenGaleria1"] != "") { ?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]["imagenGaleria1"]; ?>" class="imagen100">
                                        </div>
                                        <?php } ?>
                                        <?php if ($producto[0]["imagenGaleria2"] != "") { ?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]["imagenGaleria2"]; ?>" class="imagen100">
                                        </div>
                                        <?php } ?>
                                        <?php if ($producto[0]["imagenGaleria3"] != "") { ?>
                                        <div class="item">
                                            <img src="<?php echo $producto[0]["imagenGaleria3"]; ?>" class="imagen100">
                                        </div>
                                        <?php } ?>
                                    </div>
                            <!-- FIN IMÁGENES GRANDES -->
                                   
                                    <br>
                                    
                            <!-- INICIO IMÁGENES PEQUEÑAS -->
                                    <div class="row miniaturas">
                                        <ul class="nav nav-pills nav-justified">
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="0" class="active"><a href="#"><img src="<?php echo $producto[0]["imagen"]; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php if ($producto[0]["imagenGaleria1"] != "") { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="1"><a href="#"><img src="<?php echo $producto[0]["imagenGaleria1"]; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                            <?php if ($producto[0]["imagenGaleria2"] != "") { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="2"><a href="#"><img src="<?php echo $producto[0]["imagenGaleria2"]; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                            <?php if ($producto[0]["imagenGaleria3"] != "") { ?>
                                            <div class="col-xs-3">
                                                <li data-target="#myCarousel" data-slide-to="3"><a href="#"><img src="<?php echo $producto[0]["imagenGaleria3"]; ?>"  class="imagen100"></a></li>
                                            </div>
                                            <?php } ?>
                                        </ul>
                                    </div>
                            <!-- FIN IMÁGENES PEQUEÑAS -->
                                </div>
                            </div>
                        </div>
                <!-- FIN IMAGENES holaaaaaaaaooooeeeeee-->
                
                <!-- INICIO TÍTULO, PRECIO, TABLA... -->
                        <div class="col-md-6">
                           
                    <!-- INICIO TÍTULO Y PRECIO  Comentario cesar 2-->
                            <div class="thumbnail margen_interno_20">
                                <?php
                                    if (strpos($producto[0]["titulo"], ", regulable")) {
                                        $titulo_tonalidad = substr($producto[0]["titulo"], 0, strpos($producto[0]["titulo"], ", regulable"));
                                    } else {
                                        $titulo_tonalidad = $producto[0]["titulo"];
                                    }
                                    if (strpos($titulo_tonalidad, ", Blanco ")) {
                                        $titulo = substr($titulo_tonalidad, 0, strpos($titulo_tonalidad, ", Blanco "));
                                        $tonalidad = substr($titulo_tonalidad, strpos($titulo_tonalidad, ", Blanco "));
                                    } elseif (strpos($titulo_tonalidad, " + Blanco ")) {
                                        $titulo = substr($titulo_tonalidad, 0, strpos($titulo_tonalidad, " + Blanco "));
                                        $tonalidad = substr($titulo_tonalidad, strpos($titulo_tonalidad, " + Blanco "));
                                    } else {
                                        $titulo = $titulo_tonalidad;
                                        $tonalidad = "";
                                    }
                                    switch ($tonalidad) {
                                        case ", Blanco neutro":
                                        case " + Blanco neutro":
                                            $color_texto = "blanco_neutro";
                                            $tonalidad = "Blanco neutro";
                                            break;
                                        case ", Blanco frío":
                                        case " + Blanco frío":
                                            $color_texto = "blanco_frio";
                                            $tonalidad = "Blanco frío";
                                            break;
                                        case ", Blanco cálido":
                                        case " + Blanco cálido":
                                            $color_texto = "blanco_calido";
                                            $tonalidad = "Blanco cálido";
                                            break;
                                    }
                                ?>
                                <div class="row">
                                    <h2 class="producto_titulo">
                                        <strong>
                                        <div class="col-md-7">
                                            <p><?php echo $titulo ?></p>
                                        </div>
                                        <div class="col-md-5">
                                            <p><span class="<?php echo $color_texto ?>"><?php echo $tonalidad; ?></span></p>
                                        </div>
                                    </strong>
                                    </h2>
                                </div>
                                <div class="row">
                                    <div class="col-xs-6 col-md-3">
                                        <h1 class="producto_precio">
                                            <?php echo $producto[0]["PVP"]; ?> €</h1>
                                    </div>
                                    <div class="col-xs-6 col-md-4 texto_gris">
                                        <h3 class="producto_precio_sin_IVA">
                                            <?php echo round($producto[0]["PVP"]/1.21, 2); ?> €
                                        </h3><span>sin iva</span>
                                    </div>
                                </div>
                            </div>
                    <!-- FIN TÍTULO Y PRECIO -->
                           
                            <div class="thumbnail margen_interno_20">
                                <?php
                                    if ($producto[0]["stock"] == 0) {
                                        $hay_stock = "<span class='texto_rojo'><i class='fas fa-times-circle'></i> sin stock</span>";
                                    } else {
                                        $hay_stock = "<span class='texto_verde'><i class='fas fa-check-circle'></i> Envío en 24 horas</span>";
                                    }
                                ?>
                                
                        <!-- INICIO REF Y STOCK -->
                                <div class="row">
                                    <div class="col-xs-3 texto_gris">REF:
                                        <?php echo $producto[0]["codigo"]; ?>
                                    </div>
                                    <div class="col-xs-5">Hay en stock <b><?php echo $producto[0]["stock"]; ?></b> unidades</div>
                                    <div class="col-xs-4"><b> <?php echo $hay_stock ?></b></div>
                                </div>
                        <!-- FIN REF Y STOCK -->
                               
                                <hr class="estilo_hr">

                        <!-- INICIO SELECCIÓN DE CANTIDAD -->
                                <div class="row margen_interno_20 sin_padding mas_menos margen_bajo_0">
                                    <div class="col-xs-4">
                                        <label for="cantidad">Cantidad</label>
                                    </div>
                                    <div class="col-xs-1">
                                        <button type="button" class="btn btn-secondary" onclick="restar1(<?php echo $producto[0]["PVP"] . ", " . $producto[0]["stock"]; ?>)">-</button>
                                    </div>
                                    <div class="col-xs-2">
                                        <input id="cantidad" class="form-control" type="text" value="<?php if ($producto[0]["stock"] == 0) { echo "0"; } else { echo "1"; } ?>" min="<?php if ($producto[0]["stock"] == 0) { echo "0"; } else { echo "1"; } ?>" max="<?php echo $producto[0]["stock"]; ?>" onblur="calcular(<?php echo $producto[0]["PVP"] . ", " . $producto[0]["stock"]; ?>)"></input>
                                    </div>
                                    <div class="col-xs-1">
                                        <button type="button" class="btn btn-secondary" onclick="sumar1(<?php echo $producto[0]["PVP"] . ", " . $producto[0]["stock"]; ?>)">+</button>
                                    </div>
                                    <div class="col-xs-4">
                                        <h4 id="precio_total"><!-- SE GENERA CON JAVASCRIPT --></h4>
                                    </div>
                                </div>
                                <div>
                                    <button type="button" class="btn btn-lg btn-block btn-primary">Añadir al carrito</button>
                                </div>
                        <!-- FIN SELECCIÓN DE CANTIDAD -->
                                
                                <hr class="estilo_hr">
                                
                        <!-- INICIO TABLA CARACTERÍSTICAS -->
                                <div class="margen_interno_20 margen_bajo_0">
                                    <h3 class="estilo_h3">CARACTERÍSTICAS</h3>
                                    <table class="table table-striped table-condensed">
                                        <tbody>
                                            <tr>
                                                <td>Referencia</td>
                                                <th><?php echo $producto[0]["codigo"]; ?></th>
                                            </tr>
                                            <?php if ($producto[0]["horas"] != "") { ?>
                                                <tr>
                                                    <td>Autonomía</td>
                                                    <th><?php echo $producto[0]["horas"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["potencia"] != "") { ?>
                                                <tr>
                                                    <td>Potencia</td>
                                                    <th><?php echo $producto[0]["potencia"] . " W"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["flujo_luminoso"] != "") { ?>
                                                <tr>
                                                    <td>Flujo luminoso</td>
                                                    <th><?php echo $producto[0]["flujo_luminoso"] . "lm"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["angulo_apertura"] != "") { ?>
                                                <tr>
                                                    <td>Ángulo de apertura</td>
                                                    <th><?php echo $producto[0]["angulo_apertura"] . "º"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["alimentacion"] != "") { ?>
                                                <tr>
                                                    <td>Alimentación</td>
                                                    <th><?php echo $producto[0]["alimentacion"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["temperatura"] != "") { ?>
                                                <tr>
                                                    <td>Temperatura de calor</td>
                                                    <th><?php echo $producto[0]["temperatura"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["num_leds"] != "") { ?>
                                                <tr>
                                                    <td>Número de leds</td>
                                                    <th><?php echo $producto[0]["num_leds"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["interior_exteior"] != "") { ?>
                                                <tr>
                                                    <td>Interior-exterior</td>
                                                    <th><?php echo $producto[0]["interior_exteior"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["proteccion_ip"] != "") { ?>
                                                <tr>
                                                    <td>Protección IP</td>
                                                    <th><?php echo $producto[0]["proteccion_ip"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["proteccion_ik"] != "") { ?>
                                                   <tr>
                                                    <td>Protección IK</td>
                                                    <th><?php echo $producto[0]["proteccion_ik"]; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["ancho_mm"] != "" && $producto[0]["largo_mm"] != "" && $producto[0]["alto_mm"] != "") { ?>
                                                <tr>
                                                    <td>Dimensiones del producto</td>
                                                    <th><?php echo $producto[0]["ancho_mm"] . "x".$producto[0]["largo_mm"] . "x" . $producto[0]["alto_mm"] . " mm"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["ancho_cm"] != "" && $producto[0]["largo_cm"] != "" && $producto[0]["alto_cm"] != "") { ?>
                                                <tr>
                                                    <td>Dimensiones del paquete</td>
                                                    <th><?php echo $producto[0]["ancho_cm"] . "x" . $producto[0]["largo_cm"] . "x" . $producto[0]["alto_cm"] . " cm"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["peso_kg"] != "") { ?>
                                                <tr>
                                                    <td>Peso del paquete</td>
                                                    <th><?php echo $producto[0]["peso_kg"] . "Kg"; ?></th>
                                                </tr>
                                            <?php } ?>
                                            <?php if ($producto[0]["certificados"] != "") { ?>
                                                <tr>
                                                    <td>Certificados</td>
                                                    <?php $certificados = explode(", ", $producto[0]["certificados"]); ?>
                                                    <th>
                                                        <?php for ($i=0; $i<count($certificados); $i++) {
                                                            echo "<p class='margen_bajo_0'>$certificados[$i]</p>" ;
                                                        } ?>
                                                    </th>
                                                </tr>
                                            <?php } ?>
                                        </tbody>
                                    </table>
                                </div>
                        <!-- FIN TABLA CARACTERÍSTICAS -->
                           
                            </div>
                        </div>
                <!-- FIN TÍTULO, PRECIO, TABLA... -->
                   
                    </div>
            <!-- FIN ZONA SUPERIOR -->
                  
                      
                   
            <!-- INICIO ZONA INFERIOR -->
                    <div class="row">
                       
                <!-- INICIO DESCRIPCIÓN -->
                        <div class="col-md-8">
                            <div class="thumbnail margen_interno_20">
                                <h3 class="estilo_h3">DESCRIPCIÓN</h3>
                                <br>
                                <p><?php echo $producto[0]["subtitulo"]; ?></p>
                            </div>
                        </div>
                <!-- FIN DESCRIPCIÓN -->
                       
                <!-- INICIO ARTÍCULOS RELACIONADOS -->
                        <div class="col-md-4">
                            <h3 class="estilo_h3">TE PUEDE INTERESAR...</h3>
                            <?php
                                for($i=0; $i<count($familia_rel); $i++) {
                                    if (strpos($familia_rel[$i]["titulo"], ", regulable")) {
                                        $titulo_tonalidad = substr($familia_rel[$i]["titulo"], 0, strpos($familia_rel[$i]["titulo"], ", regulable"));
                                    } else {
                                        $titulo_tonalidad = $familia_rel[$i]["titulo"];
                                    }
                                    if (strpos($titulo_tonalidad, ", Blanco ")) {
                                        $titulo = substr($titulo_tonalidad, 0, strpos($titulo_tonalidad, ", Blanco "));
                                        $tonalidad = substr($titulo_tonalidad, strpos($titulo_tonalidad, ", Blanco "));
                                    } elseif (strpos($titulo_tonalidad, " + Blanco ")) {
                                        $titulo = substr($titulo_tonalidad, 0, strpos($titulo_tonalidad, " + Blanco "));
                                        $tonalidad = substr($titulo_tonalidad, strpos($titulo_tonalidad, " + Blanco "));
                                    } else {
                                        $titulo = $titulo_tonalidad;
                                        $tonalidad = "";
                                    }
                                    switch ($tonalidad) {
                                        case " + Blanco neutro":
                                            $tonalidad = ", Blanco neutro";
                                            break;
                                        case " + Blanco frío":
                                            $tonalidad = ", Blanco frío";
                                            break;
                                        case " + Blanco cálido":
                                            $tonalidad = ", Blanco cálido";
                                            break;
                                    }
                            ?>
                                <a href="pagina_producto.php?id=<?php echo $familia_rel[$i]["id"]; ?>">
                                    <div class="thumbnail targeta_peq">
                                        <div class="row">
                                            <div class="col-xs-4"><img src="<?php echo $familia_rel[$i]["imagen"]; ?>" class="imagen100"></div>
                                            <div class="col-xs-8">
                                                <div class="familia_titulo">
                                                    <p><?php echo $titulo ?><small><?php echo $tonalidad ?></small></p>
                                                </div>
                                                <div>
                                                    <h3 class="familia_precio">
                                                        <?php echo $familia_rel[$i]["PVP"]; ?> €</h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </a>
                            <?php } ?>
                            <div class="ver_mas">
                                <a href="pagina_familia.php?familia=<?php echo $familia_subfamilia[0]["familia_id"] ?>" class="btn btn-lg btn-block btn-default">Ver más...</a>
                            </div>
                        </div>
                <!-- FIN ARTÍCULOS RELACIONADOS -->
                   
                    </div>
            <!-- FIN ZONA INFERIOR -->

                </section>
        <!-- FIN CONTENIDO PRINCIPAL -->
           
            </div>
    <!-- FIN CONTENEDOR DEL CONTENIDO -->

            <?php include_once("footer.php")?>

        </div>

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
            
            function restar1(precio, stock) {
                var cantidad = document.getElementById("cantidad");
                var precio_total = document.getElementById("precio_total");
                if (cantidad.value > 1) {
                    cantidad.value--;
                    precio_total.innerHTML = precio * cantidad.value + " €";
                }
            }
            
            function sumar1(precio, stock) {
                var cantidad = document.getElementById("cantidad");
                var precio_total = document.getElementById("precio_total");
                if (cantidad.value < stock) {
                    cantidad.value++;
                    precio_total.innerHTML = precio * cantidad.value + " €";
                }
            }
            
            function calcular(precio, stock) {
                var cantidad = document.getElementById("cantidad");
                var precio_total = document.getElementById("precio_total");
                if (cantidad.value > stock) {
                    cantidad.value = stock;
                }
                if (cantidad.value < 1) {
                    cantidad.value = 1;
                }
                if (stock == 0) {
                    cantidad.value = 0;
                }
                precio_total.innerHTML = precio * cantidad.value + " €";
            }
            
            window.onload=function() {
                var cantidad = document.getElementById("cantidad");
                var precio_total = document.getElementById("precio_total");
                var precio = <?php echo $producto[0]["PVP"]; ?>;
                precio_total.innerHTML = precio * cantidad.value + " €";
        
        //  CAMBIAR LA URL DEL NAVEGADOR CON JAVASCRIPT
                //history.replaceState(null, "", "url_nueva.php");
            }
        </script>
    </body>

</html>
