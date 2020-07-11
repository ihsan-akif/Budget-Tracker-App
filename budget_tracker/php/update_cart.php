<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$prodid = $_POST['prodid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET CQuantity = '$quantity' WHERE Email = '$email' AND ProdID = '$prodid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>