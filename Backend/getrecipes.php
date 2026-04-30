<?php
$host = "localhost";
$user = "root";
$pass = "";
$db = "recipe_db";

$conn = new mysqli($host, $user, $pass, $db);

if($conn->connect_error){
    die("Connection failed: " . $conn->connect_error);
}

$sql = "SELECT * FROM recipes";
$result = $conn->query($sql);

$recipes = [];
while($row=$result->fetch_assoc()){
    $recipes[] = $row;
}

header('Content-Type: application/json');
echo json_encode($recipes);

$conn->close();
?>