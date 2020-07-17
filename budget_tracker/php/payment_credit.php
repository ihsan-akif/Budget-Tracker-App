<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_POST['userid'];
$amount = $_POST['amount'];
$orderid = $_POST['orderid'];
$newcr = $_POST['newcr'];
$receiptid ="storecr";

 $sqlcart ="SELECT CART.ProdID, CART.CQuantity, CATALOGUE.Price FROM CART INNER JOIN CATALOGUE ON CART.ProdID = CATALOGUE.ProdID WHERE CART.Email = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $prodid = $row["ProdID"];
            $cq = $row["CQuantity"]; //cart qty
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(Email,OrderID,BillID,ProdID,CQuantity) VALUES ('$userid','$orderid','$receiptid','$prodid','$cq')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM CATALOGUE WHERE ProdID = '$prodid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["Quantity"];
                    $prevsold = $rowp["Sold"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE CATALOGUE SET Quantity = '$newquantity', Sold = '$newsold' WHERE ProdID = '$prodid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE Email = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(OrderID,BillID,UserID,Total) VALUES ('$orderid','$receiptid','$userid','$amount')";
        $sqlupdatecredit = "UPDATE USER SET Credit = '$newcr' WHERE Email = '$userid'";
        
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
       $conn->query($sqlupdatecredit);
       echo "success";
        }else{
            echo "failed";
        }

?>