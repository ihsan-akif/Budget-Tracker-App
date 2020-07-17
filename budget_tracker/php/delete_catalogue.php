<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['prodid'];

$sqldelete = "DELETE FROM CATALOGUE WHERE ProdID = '$prodid'";
    
if ($conn->query($sqldelete) === TRUE){
   echo "success";
}else {
    echo "failed";
}
?>