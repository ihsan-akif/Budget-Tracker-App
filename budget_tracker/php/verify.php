<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];

$sqlupdate = "UPDATE USER SET Verify = '1' WHERE Email = '$email'";

if ($conn->query($sqlupdate) === TRUE){
    echo "Congratulation! Your email has been verified, you can now login to the application.";
}
else{
    echo "We are sorry to inform you that your email has not been verified, please contact the support team.";
}

$conn->close();
?>