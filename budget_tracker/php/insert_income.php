<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
$total  = $_POST['total'];
$category  = $_POST['category'];
$desc  = $_POST['desc'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../receipt_images/'.$id.'.jpg';

$sqlinsert = "INSERT INTO DATA(ID,Email,Total,Category,Description,Type) VALUES ('$id','$email','$total','$category','$desc','Income')";

if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    



?>