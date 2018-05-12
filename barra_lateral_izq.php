<?php
    $sql = "SELECT *
            FROM familia";
    $familias = Query($sql);
?>
<!-- Left side column. contains the logo and sidebar -->
<aside id="barra_lateral_izq" style="position: fixed; bottom: 0; top: 0;" class="main-sidebar">

    <!-- sidebar: style can be found in sidebar.less -->
    <section id="barra_lateral_izq_scroll" style="overflow-y: scroll; height: 100%;" class="sidebar">

        <!-- Sidebar user panel (optional) -->
        <div class="user-panel">
            <div class="pull-left image">
                <img src="dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
            </div>
            <div class="pull-left info">
                <p>Alexander Pierce</p>
                <!-- Status -->
                <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
            </div>
        </div>

        <!-- search form (Optional) -->
        <form action="pagina_busqueda.php" method="get" class="sidebar-form">
            <div class="input-group">
                <input style="<?php if (isset($termino_buscar)) { echo 'background-color: whitesmoke;'; } ?>" type="text" name="buscar" class="form-control" placeholder="Buscar..." value="<?php if (isset($termino_buscar)) { echo $termino_buscar; } ?>">
                <span class="input-group-btn">
              <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
              </button>
            </span>
            </div>
        </form>
        <!-- /.search form -->

        <!-- Sidebar Menu -->
        <ul id="lista_categorias" class="sidebar-menu" data-widget="tree">
            <li class="header"><h4 class="estilo_h4">CATÁLOGO</h4></li>
            <!-- Optionally, you can add icons to the links -->
            
            <?php for ($i=0; $i<count($familias); $i++) { ?>
               
               
               <?php
                    $menu_abierto = "";
                    $familia_abierta = "";
                    $id_familia = $familias[$i]["id"];
                    if (strpos($_SERVER["PHP_SELF"], "pagina_subfamilia.php") && $id_familia == $familia[0]["id"] || strpos($_SERVER["PHP_SELF"], "pagina_familia.php") && $id_familia == $familia[0]["id"] || strpos($_SERVER["PHP_SELF"], "pagina_producto.php") && $id_familia == $familia[0]["id"]) {
                        $familia_abierta = "style='display: block'";
                        $menu_abierto = "menu-open";
                    }
                ?>
                        
                        
                <li class="treeview <?php echo $menu_abierto ?>">
                    <a href="#"><i class="fa fa-link"></i> <span><?php echo $familias[$i]["familia"]; ?></span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a><ul class="treeview-menu" <?php echo $familia_abierta; ?>>
                       <li><a href="pagina_familia.php?familia=<?php echo $familias[$i]["id"]; ?>"><b class="mostrar_familia">MOSTRAR TODO</b></a></li>
                        <?php
                            $sql = "SELECT id, subfamilia
                                    FROM subfamilia
                                    WHERE subfamilia.familia_fk = '$id_familia'";
                            $subfamilias = Query($sql);
                        ?>
                        <?php for ($j=0; $j<count($subfamilias); $j++) { ?>
                            <?php
                                if (isset($subfamilia_id) && $subfamilia_id == $subfamilias[$j]["id"] || isset($familia_subfamilia[0]["subfamilia_id"]) && $familia_subfamilia[0]["subfamilia_id"] == $subfamilias[$j]["id"]) {
                                    $texto_blanco = "style='color: white'"; 
                                } else {
                                    $texto_blanco = "";
                                }
                            ?>
                            <li><a <?php echo $texto_blanco; ?> href="pagina_subfamilia.php?subfamilia=<?php echo $subfamilias[$j]["id"]; ?>"><?php echo $subfamilias[$j]["subfamilia"]; ?></a></li>
                        <?php } ?>
                    </ul>
                </li>
            <?php } ?>
            
        </ul>
        <!-- /.sidebar-menu -->

    </section>
    <!-- /.sidebar -->
</aside>


<script>
//  AL CARGAR EL DOCUMENTO CAMBIA ESTILOS SEGUN EL ANCHO DE LA VENTANA
    window.onload = function() {
        if (document.documentElement.clientWidth <= 767) {
            var barra_lateral_izq = document.getElementById("barra_lateral_izq");
            var barra_lateral_izq_scroll = document.getElementById("barra_lateral_izq_scroll");
            barra_lateral_izq.style = "";
            barra_lateral_izq_scroll.style = "";
        }
    }

//  AL HACER CLICK EN EL BOTON QUE OCULTA LA BARRA LATERAL IZQ CAMBIA CLASES DE LA LISTA DE CATEGORIAS
    function quitar_clases_barra_lateral_izq() {
        var lista_categorias = document.getElementById("lista_categorias");
        if (lista_categorias.style.position != "absolute") {
            lista_categorias.style.position = "absolute";
            lista_categorias.style.width = "100%";
        } else {
            lista_categorias.style.position = "";
        }
    }
</script>
