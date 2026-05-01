<?php
require_once 'config.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    $title = $_POST['title'] ?? '';
    $instructions = $_POST['instructions'] ?? '';
    $difficulty = $_POST['difficulty'] ?? 'Easy';

    $img_url = '';

    if (!empty($_FILES['recipe_image']['name'])) {
        $uploadDir = "../uploads/";

        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        $fileName = time() . "_" . basename($_FILES['recipe_image']['name']);
        $filePath = $uploadDir . $fileName;

        move_uploaded_file($_FILES['recipe_image']['tmp_name'], $filePath);

        $img_url = "uploads/" . $fileName;
    }

    $stmt = $pdo->prepare("
        INSERT INTO RECIPES (title, instructions, difficulty, img_url)
        VALUES (?, ?, ?, ?)
    ");

    $stmt->execute([$title, $instructions, $difficulty, $img_url]);

    echo json_encode(["status"=>"success"]);
}
?>