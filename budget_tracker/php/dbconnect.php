<?php
$servername = "localhost";
$username = "shababit_ihsan";
$password = "Ihsanakif1994";
$dbname = "shababit_budgettracker";

//Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

//Check connection
if ($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}
//echo "Connected Successfully";
?>