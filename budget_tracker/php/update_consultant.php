<?php
error_reporting(0);
include_once("dbconnect.php");
$name = $_POST['name'];
$id = $_POST['id'];
$price  = $_POST['price'];
$state  = $_POST['state'];
$latitude  = $_POST['latitude'];
$longitude  = $_POST['longitude'];
$contact  = $_POST['contact'];
$address  = $_POST['address'];
$website  = $_POST['website'];
$quantity  = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../catalogue_images/'.$id.'.jpg';

$sqlupdate = "UPDATE CATALOGUE SET ProdID = '$id', Name = '$name', Price = '$price', State = '$state', Latitude = '$latitude', Longitude = '$longitude', Contact = '$contact', Address = '$address', Quantity = '$quantity', Website = '$website' WHERE ProdID = '$id'";

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