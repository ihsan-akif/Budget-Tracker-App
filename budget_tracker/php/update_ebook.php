<?php
error_reporting(0);
include_once("dbconnect.php");
$prodid = $_POST['prodid'];
$name  = $_POST['name'];
$quantity  = $_POST['quantity'];
$price  = $_POST['price'];
$publisher  = $_POST['publisher'];
$author  = $_POST['author'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../catalogue_images/'.$prodid.'.jpg';

$sqlupdate = "UPDATE CATALOGUE SET ProdID = '$prodid', Name = '$name', Price = '$price', Author = '$author', Publisher = '$publisher', Quantity = '$quantity' WHERE ProdID = '$prodid'";

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