
   

   
<div class="col-sm-6 col-md-4">
    <div class="thumbnail">
      <img src="<?php echo $producto[0]["imagen"] ?>">
      <div class="caption">
        <center><h5 style="height: 20px;"><?php echo $producto[0]["titulo"] ?></h5>
        <br>
        <p style="font-size: 1.5em;"><b><?php echo $producto[0]["PVP"] ?> €</b></p>
        </center>
        <br>
        <form action="index.php" method="post">
            <input name="id" type="hidden" value="<?php echo $producto[0]["id"] ?>">
            <p>HOLA</p>
        </form>
    </div>
    </div>
  </div>