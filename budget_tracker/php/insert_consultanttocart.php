<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$prodid = $_POST['proid'];
//$prodisbn = $_POST['proisbn'];
$userquantity = $_POST['quantity'];

$sqlsearch = "SELECT * FROM CART WHERE Email = '$email' AND ProdID= '$prodid'";

$result = $conn->query($sqlsearch);
if ($result->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
        $prquantity = $row["CQuantity"];
    }
    $prquantity = $prquantity + $userquantity;
    $sqlinsert = "UPDATE CART SET CQuantity = '$prquantity' WHERE ProdID = '$prodid' AND Email = '$email'";
    
}else{
    $sqlinsert = "INSERT INTO CART(Email,ProdID,CQuantity,Type) VALUES ('$email','$prodid',$userquantity,'Consultant')";
}

if ($conn->query($sqlinsert) === true)
{
    $sqlquantity = "SELECT * FROM CART WHERE Email = '$email'";

    $resultq = $conn->query($sqlquantity);
    if ($resultq->num_rows > 0) {
        $quantity = 0;
        while ($row = $resultq ->fetch_assoc()){
            $quantity = $row["CQuantity"] + $quantity;
        }
    }

    $quantity = $quantity;
    echo "success,".$quantity;
}
else
{
    echo "failed";
}

?>