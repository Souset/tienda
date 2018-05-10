<?php




function Conectarse()
{
	$servidor = "localhost";
    $usuario = "root";
    $clave="";
    $baseDatos="ledbox";

	if (!($link=mysqli_connect($servidor, $usuario, $clave, $baseDatos)))

    {
       echo "Error conectando a la base de datos.";
       exit();
    }

	//Nombre de la base de datos
	
	if (!(mysqli_select_db($link ,$baseDatos )))
    {
       echo "Error seleccionando la base de datos.";
       exit();
    }
	
	mysqli_set_charset($link,"utf8");
    //$link->set_charset("utf8");
    
	return $link;
}

/*Utilizala para consultas*/
function Query($query)
{
     $devolver = NULL;
     $link=Conectarse();
     $result=mysqli_query($link, $query);
     $cont=0;
     while ($row=mysqli_fetch_array($result))
     {
         $devolver[$cont]=$row;
         $cont++;
     }
     mysqli_free_result($result);
     mysqli_close($link);
     return $devolver;
}

/*Utilizala para inserciones, Actualizaciones y Borrados*/
function QueryAccion($query)
{
     $link=Conectarse();
     mysqli_query($link, $query);
	 $id = mysqli_insert_id($link);
     mysqli_close($link);
	 
	 return $id;
}

?>