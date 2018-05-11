<!DOCTYPE html>
<html>
<?php include_once("head.php"); ?>

<body class="hold-transition login-page">
<div class="login-box ">
        <!-- Logo -->
        <div class="login-logo">
              <a href="index.php" class="logo">
                    
                    <!-- logo for regular state and mobile devices -->
                    <span class="logo-lg"><img src="img/logo.png" alt=""> caja<b>LUZ</b></span>
                </a>
        </div>
     
  <!-- /.login-logo -->
  <div class="login-box-body">
  
    <p class="login-box-msg">Inicia sesión para comenzar</p>

    <form action="index.php" method="post">
      <div class="form-group has-feedback">
        <input type="email" class="form-control" placeholder="Email o Usuario">
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" placeholder="Contraseña">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-xs-7">
          <div class="checkbox icheck">
            <label>
              <input type="checkbox"> Recuérdame
            </label>
          </div>
        </div>
        <!-- /.col -->
        <div class="col-xs-5">
          <button type="submit" class="btn btn-primary btn-block btn-flat">Iniciar Sesión</button>
        </div>
        <!-- /.col -->
      </div>
    </form>

    <div class="social-auth-links text-center">
      <p>- O -</p>
      <a href="#" class="btn btn-block btn-social btn-facebook btn-flat"><i class="fa fa-facebook"></i> Iniciar sesión usando
        Facebook</a>
      <a href="#" class="btn btn-block btn-social btn-google btn-flat"><i class="fa fa-google-plus"></i> Iniciar sesión usando
        Google+</a>
    </div>
    <!-- /.social-auth-links -->

    <a href="#">Olvidé mi contraseña</a><br>
    <a href="registro.php" class="text-center">Crear una nueva Cuenta</a>

  </div>
  <!-- /.login-box-body -->
</div>
<!-- /.login-box -->

<!-- jQuery 3 -->
<script src="components/jquery/dist/jquery.min.js"></script>
<!-- Bootstrap 3.3.7 -->
<script src="components/bootstrap/dist/js/bootstrap.min.js"></script>
<!-- iCheck -->
<script src="plugins/iCheck/icheck.min.js"></script>
<script>
  $(function () {
    $('input').iCheck({
      checkboxClass: 'icheckbox_square-blue',
      radioClass: 'iradio_square-blue',
      increaseArea: '20%' /* optional */
    });
  });
</script>
</body>
</html>


   
    