<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
//$status = "notpaid";

if (isset($email)){
   $sql = "SELECT CATALOGUE.ProdID, CATALOGUE.Name, CATALOGUE.Price, CATALOGUE.Quantity, CART.CQuantity, CART.Type FROM CATALOGUE INNER JOIN CART ON CART.ProdID = CATALOGUE.ProdID WHERE CART.Email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["prodid"] = $row["ProdID"];
        $cartlist["name"] = $row["Name"];
        $cartlist["price"] = $row["Price"];
        $cartlist["quantity"] = $row["Quantity"];
        $cartlist["cquantity"] = $row["CQuantity"];
        $cartlist["type"] = $row["Type"];
        $cartlist["yourprice"] = round(doubleval($row["Price"])*(doubleval($row["CQuantity"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>
