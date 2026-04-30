<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "recipe_db";

$conn = new mysqli($host, $user, $pass, $db);

// 1. Handle the Image Upload
$img_path = "uploads/default.jpg"; // Default if no image uploaded
if (isset($_FILES['recipe_image'])) {
    $target_dir = "uploads/";
    $target_file = $target_dir . basename($_FILES["recipe_image"]["name"]);
    if (move_uploaded_file($_FILES["recipe_image"]["tmp_name"], $target_file)) {
        $img_path = $target_file;
    }
}

// 2. Get Text Data
$title = $_POST['title'];
$desc = $_POST['description'];
$instr = $_POST['instructions'];

// 3. Insert into Database (Using Prepared Statements for security)
$stmt = $conn->prepare("INSERT INTO recipes (title, category, image_url) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $title, $desc, $img_path);

if ($stmt->execute()) {
    echo "Recipe shared successfully!";
} else {
    echo "Error: " . $conn->error;
}

$stmt->close();
$conn->close();
?>