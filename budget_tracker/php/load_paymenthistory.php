<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
    $sql = "SELECT * FROM PAYMENT WHERE UserID = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["payment"] = array();
    while ($row = $result->fetch_assoc())
    {
        $paymentlist = array();
        $paymentlist["orderid"] = $row["OrderID"];
        $paymentlist["billid"] = $row["BillID"];
        $paymentlist["total"] = $row["Total"];
        $paymentlist["date"] = $row["Date"];
        array_push($response["payment"], $paymentlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>