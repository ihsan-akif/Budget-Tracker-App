<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$credit = 0;

$sql = "SELECT * FROM USER WHERE Email = '$email'";    
 
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    while ($row = $result->fetch_assoc())
    {
        $credit = $credit + $row["Credit"];
    }
    echo $credit;
}
else
{
    echo "No Credit";
}
?>