<?php
header('Content-Type: application/json; charset=utf-8');

$dataDir = __DIR__ . '/DataBase';
$usersFile = $dataDir . '/users.json';

//creates new file if previous one doesn't exist, otherwise it does nothing
if (!file_exists($usersFile)) {
    file_put_contents($usersFile, json_encode([], JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
}

$action = isset($_GET['action']) ? $_GET['action'] : '';

//creates error message in json format and exits
function jsonErr($msg, $code = 400) {
    http_response_code($code);
    echo json_encode(['error' => $msg]);
    exit;
}

//retrieve user information
$raw = file_get_contents($usersFile);
$users = json_decode($raw, true);
if (!is_array($users)) $users = [];

//if user tries to register, check if username is unique and store the new user with hashed password
if ($action === 'register') {
    $username = isset($_GET['username']) ? trim((string)$_GET['username']) : '';
    $password = isset($_GET['password']) ? (string)$_GET['password'] : '';
    if ($username === '' || $password === '') jsonErr('username and password are required', 422);

    foreach ($users as $u) {
        if (isset($u['username']) && mb_strtolower($u['username']) === mb_strtolower($username)) {
            jsonErr('username already exists', 409);
        }
    }
    //hashes the password and stores the user with a unique id based on timestamp and random bytes to avoid collisions, then saves the updated users list back to the file
    $id = (string)time() . bin2hex(random_bytes(4));
    $hash = password_hash($password, PASSWORD_DEFAULT);
    $user = ['id' => $id, 'username' => $username, 'password_hash' => $hash, 'created' => date('c')];
    // default role is regular user; staff accounts should be granted manually
    $user['role'] = 'user';
    $users[] = $user;
    file_put_contents($usersFile, json_encode($users, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE));
    echo json_encode(['status' => 'ok', 'user_id' => $id]);
    exit;
}

//if user tries to login, check if username exists and password matches the stored hash, then return the user id if successful, otherwise return appropriate error messages
if ($action === 'login') {
    $username = isset($_GET['username']) ? trim((string)$_GET['username']) : '';
    $password = isset($_GET['password']) ? (string)$_GET['password'] : '';
    if ($username === '' || $password === '') jsonErr('username and password are required', 422);

    foreach ($users as $u) {
        if (isset($u['username']) && mb_strtolower($u['username']) === mb_strtolower($username)) {
            if (isset($u['password_hash']) && password_verify($password, $u['password_hash'])) {
                echo json_encode(['status' => 'ok', 'user_id' => $u['id']]);
                exit;
            }
            jsonErr('invalid credentials', 401);
        }
    }
    jsonErr('user not found', 404);
}

// staff login: only users with role 'staff' may authenticate here
if ($action === 'staff_login') {
    $username = isset($_GET['username']) ? trim((string)$_GET['username']) : '';
    $password = isset($_GET['password']) ? (string)$_GET['password'] : '';
    if ($username === '' || $password === '') jsonErr('username and password are required', 422);

    foreach ($users as $u) {
        if (isset($u['username']) && mb_strtolower($u['username']) === mb_strtolower($username)) {
            if (!isset($u['role']) || $u['role'] !== 'staff') {
                jsonErr('forbidden: not a staff account', 403);
            }
            if (isset($u['password_hash']) && password_verify($password, $u['password_hash'])) {
                echo json_encode(['status' => 'ok', 'user_id' => $u['id'], 'role' => $u['role']]);
                exit;
            }
            jsonErr('invalid credentials', 401);
        }
    }
    jsonErr('user not found', 404);
}

//if user requests a guest token, generate a unique guest ID that is not stored persistently and return it in the response
if ($action === 'guest') {
    // generate a non-persistent guest token
    try {
        $guestId = 'guest_' . bin2hex(random_bytes(8));
    } catch (Exception $e) {
        $guestId = 'guest_' . uniqid();
    }
    echo json_encode(['status' => 'ok', 'guest_id' => $guestId]);
    exit;
}

// usage
echo json_encode([
    'usage' => [
        'register' => '/auth.php?action=register&username=...&password=...',
        'login' => '/auth.php?action=login&username=...&password=...',
        'staff_login' => '/auth.php?action=staff_login&username=...&password=... (requires role=staff)',
        'guest' => '/auth.php?action=guest'
    ]
]);
