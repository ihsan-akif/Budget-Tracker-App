<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$id = $_POST['id'];
$total  = $_POST['total'];
$category  = $_POST['category'];
$desc  = $_POST['desc'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../receipt_images/'.$id.'.jpg';

$sqlupdate = "UPDATE DATA SET Total = '$total', Category = '$category', Description = '$desc' WHERE ID = '$id'";

if ($conn->query($sqlupdate) === true)
{
    if (isset($encoded_string)){
        file_put_contents($path, $decoded_string);
    }
    echo "success";
}
else
{
    echo "failed";
}

?>