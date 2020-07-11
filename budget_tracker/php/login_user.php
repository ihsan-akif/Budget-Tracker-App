<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqlquantity = "SELECT * FROM CART WHERE Email = '$email'";

$resultq = $conn->query($sqlquantity);
$quantity = 0;
if ($resultq->num_rows > 0) {
    while ($rowq = $resultq ->fetch_assoc()){
        $quantity = $rowq["CQuantity"] + $quantity;
    }
}

$sql = "SELECT * FROM USER WHERE Email = '$email' AND Password = '$password'";
$result = $conn->query($sql);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        echo $data = "success,".$row["Name"].",".$row["Email"].",".$row["PhoneNum"].",".$row["DateReg"].",".$quantity.",".$row["Credit"];
    }
}else{
    echo "failed";
}