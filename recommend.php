<?php
// Simple recipe recommender based on search terms
header('Content-Type: application/json; charset=utf-8');

$dataDir = __DIR__ . '/DataBase';
$recipesFile = $dataDir . '/recipes.json';
$logsFile = $dataDir . '/search_logs.json';

if (!file_exists($recipesFile)) {
    http_response_code(500);
    echo json_encode(['error' => 'Recipe database not found']);
    exit;
}

$query = isset($_GET['query']) ? trim((string)$_GET['query']) : '';
$userId = isset($_GET['user_id']) ? trim((string)$_GET['user_id']) : null;

if ($query === '') {
    echo json_encode(['results' => [], 'message' => 'Provide a query parameter like ?query=pancake']);
    exit;
}

$raw = file_get_contents($recipesFile);
$recipes = json_decode($raw, true) ?: [];

// tokenize query
$tokens = preg_split('/[^\p{L}\p{N}]+/u', mb_strtolower($query));
$tokens = array_filter($tokens);

function scoreRecipe(array $recipe, array $tokens) {
    $score = 0.0;
    $title = mb_strtolower($recipe['title'] ?? '');
    $description = mb_strtolower($recipe['description'] ?? '');
    $category = mb_strtolower($recipe['category'] ?? '');
    $ingredients = array_map('mb_strtolower', $recipe['ingredients'] ?? []);
    $tags = array_map('mb_strtolower', $recipe['tags'] ?? []);

    foreach ($tokens as $t) {
        if ($t === '') continue;
        if (mb_strpos($title, $t) !== false) $score += 3.0;
        foreach ($ingredients as $ing) {
            if (mb_strpos($ing, $t) !== false) $score += 2.0;
        }
        if ($category === $t) $score += 1.5;
        foreach ($tags as $tag) {
            if ($tag === $t) $score += 1.0;
        }
        if (mb_strpos($description, $t) !== false) $score += 0.5;
    }

    return $score;
}

$scored = [];
foreach ($recipes as $r) {
    $s = scoreRecipe($r, $tokens);
    if ($s > 0) {
        $r['_score'] = $s;
        $scored[] = $r;
    }
}

usort($scored, function($a, $b){
    return $b['_score'] <=> $a['_score'];
});

$top = array_slice($scored, 0, 5);

// Log the search asynchronously (best-effort)
if ($userId !== null) {
    $entry = ['user_id' => $userId, 'query' => $query, 'time' => date('c')];
    try {
        $logs = file_exists($logsFile) ? json_decode(file_get_contents($logsFile), true) : [];
        if (!is_array($logs)) $logs = [];
        $logs[] = $entry;
        file_put_contents($logsFile, json_encode($logs, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    } catch (Exception $e) {
        // ignore logging errors
    }
}

echo json_encode(['query' => $query, 'results' => $top], JSON_UNESCAPED_UNICODE);
