<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];

$sqldelete = "DELETE FROM DATA WHERE ID = '$id'";
    
if ($conn->query($sqldelete) === TRUE){
   echo "success";
}else {
    echo "failed";
}
?>