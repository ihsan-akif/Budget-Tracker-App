<?php
error_reporting(0);
include_once ("dbconnect.php");

$sql = "SELECT * FROM CATALOGUE";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["catalogue"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cataloguelist = array();
        $cataloguelist["prodid"] = $row["ProdID"];
        $cataloguelist["name"] = $row["Name"];
        $cataloguelist["price"] = $row["Price"];
        $cataloguelist["author"] = $row["Author"];
        $cataloguelist["publisher"] = $row["Publisher"];
        $cataloguelist["daterelease"] = $row["DateRelease"];
        $cataloguelist["type"] = $row["Type"];
        $cataloguelist["state"] = $row["State"];
        $cataloguelist["latitude"] = $row["Latitude"];
        $cataloguelist["longitude"] = $row["Longitude"];
        $cataloguelist["contact"] = $row["Contact"];
        $cataloguelist["address"] = $row["Address"];
        $cataloguelist["quantity"] = $row["Quantity"];
        $cataloguelist["website"] = $row["Contact"];
        array_push($response["catalogue"], $cataloguelist);
    }
    echo json_encode($response);
}
else
{
    echo "Catalogue Empty";
}
?>
