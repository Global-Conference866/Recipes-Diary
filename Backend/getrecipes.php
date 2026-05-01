<?php
require_once 'config.php';

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

try {
    $stmt = $pdo->query("
        SELECT 
            recipe_id AS id,
            title,
            img_url,
            isTrending,
            isRecommended
        FROM RECIPES
        ORDER BY created_at DESC
    ");

    echo json_encode($stmt->fetchAll(PDO::FETCH_ASSOC));

} catch(PDOException $e) {
    echo json_encode(["error"=>$e->getMessage()]);
}
?>