<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$phone = $_POST['phone'];
$name = $_POST['name'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$oldpassword = $_POST["oldpassword"];
$newpassword = $_POST["newpassword"];

$oldpass = sha1($oldpassword);
$newpass = sha1($newpassword);

if (isset($encoded_string)){
    $path = '../profile/'.$phone.'.jpg';
    file_put_contents($path, $decoded_string);
    echo 'success';
}

if (isset($name)){
    $name = ucwords($name);
    $sqlupdatename = "UPDATE USER SET Name = '$name' WHERE Email = '$email'";
    if ($conn->query($sqlupdatename)){
        echo 'success';    
    }else{
        echo 'success';
    }
    
}

if (isset($oldpassword) && isset($newpassword)){
    $sql = "SELECT * FROM USER WHERE Email = '$email' AND Password = '$oldpass'";
    $result = $conn->query($sql);
    
    if ($result->num_rows > 0) {
        $sqlupdatepass = "UPDATE USER SET Password = '$newpass' WHERE Email = '$email'";
        $conn->query($sqlupdatepass);
        echo 'success';
        
    }else{
        echo 'failed';
    }
    
}


if (isset($phone)){
    $sqlupdatepass = "UPDATE USER SET PhoneNum = '$phone' WHERE Email = '$email'";
    if($conn->query($sqlupdatepass)){
        echo 'success';    
    }else{
        echo 'failed';
    }
    
}



$conn->close();
?>