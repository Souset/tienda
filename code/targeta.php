<div class="col-sm-6 col-md-4">
    <div class="thumbnail">
      <img src="<?php echo $productos[$i]["imagen"] ?>">
      <div class="caption">
        <center><h5 style="height: 20px;"><?php echo $productos[$i]["titulo"] ?></h5>
        <br>
        <p style="font-size: 1.5em;"><b><?php echo $productos[$i]["PVP"] ?> €</b></p>
        </center>
        <br>
        <form action="code/pagina_producto.php" method="post">
            <input name="id" type="hidden" value="<?php echo $productos[$i]["id"] ?>">
            <p><button type="submit" class="btn btn-primary btn-block" role="button">Más detalles</button></p>
        </form>
    </div>
    </div>
  </div>