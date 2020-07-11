<?php
error_reporting(0);
include_once ("dbconnect.php");

$name = $_POST['name'];
$email = $_POST['email'];
$phoneNum = $_POST['phoneNum'];
$password = sha1($_POST['password']);

$sqlinsert = "INSERT INTO USER (Name,Email,PhoneNum,Password,Verify,Credit) VALUES ('$name','$email','$phoneNum','$password', '0', '0')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($email);
    echo "success";
}
else
{
    echo "failed";
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Budget Tracker'; 
    $message = 'http://shabab-it.com/budget_tracker/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@budgettracker.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

// $result = mysql_query($conn, $sqlinsert);
// if ($result) {
//     echo "Name added";
//     echo $name;
// }
// else{
//     echo "Name not added!!!";
// }

// if(mysqli_query($conn, $sqlinsert)){
//     echo "Records added successfully.";
// } else{
//     echo "ERROR: Could not able to execute $sql. " . mysqli_error($conn);
// }
?>