<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$prodid = $_POST['prodid'];
$price  = $_POST['price'];
$author  = $_POST['author'];
$publisher  = $_POST['publisher'];
$quantity  = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$path = '../catalogue_images/'.$prodid.'.jpg';

$sqlinsert = "INSERT INTO CATALOGUE(ProdID,Name,Price,Author,Publisher,Quantity,Type,Sold) VALUES ('$prodid','$name','$price','$author','$publisher','$quantity','Ebook','0')";

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