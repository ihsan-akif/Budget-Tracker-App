<?php
error_reporting(0);
include_once ("dbconnect.php");
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

$sqlinsert = "INSERT INTO CATALOGUE(ProdID,Name,Price,State,Latitude,Longitude,Contact,Address,Quantity,Website,Type,Sold) VALUES ('$id','$name','$price','$state','$latitude','$longitude','$contact','$address','$quantity','$website','Consultant','0')";

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