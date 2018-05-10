   <!-- Editor productos CK Editor -->
  
      <div class="row">
        <div class="col-md-12">
            
            <form name="editor" method="POST" action="pagina_producto.php?id=<?php echo $producto[0]['id'] ?>">
                    <textarea id="editor1" name="editor1" rows="10" cols="75">
                            <?php echo $producto[0]['subtitulo']; ?>
                           
                    </textarea>
                    <br>
                    
                    <input type="submit" name="btnGuardar" value="Guardar">
            </form>
                   
        </div>
        <!-- /.col-->
      </div>
      <!-- ./row -->
