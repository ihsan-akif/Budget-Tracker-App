<?php
error_reporting(0);
include_once ("dbconnect.php");
$orderid = $_POST['orderid'];

$sql = "SELECT CATALOGUE.ProdID, CATALOGUE.Name, CATALOGUE.Price, CATALOGUE.Type, CARTHISTORY.CQuantity FROM CATALOGUE INNER JOIN CARTHISTORY ON CARTHISTORY.ProdID = CATALOGUE.ProdID WHERE CARTHISTORY.OrderID = '$orderid'";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["carthistory"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["prodid"] = $row["ProdID"];
        $cartlist["name"] = $row["Name"];
        $cartlist["price"] = $row["Price"];
        $cartlist["type"] = $row["Type"];
        $cartlist["cquantity"] = $row["CQuantity"];
        array_push($response["carthistory"], $cartlist);
    }
    echo json_encode($response);
}
else 
{
    echo "nodata";
}
?>