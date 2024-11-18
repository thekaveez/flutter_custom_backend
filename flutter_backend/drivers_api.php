<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE");
header("Access-Control-Allow-Headers: Content-Type");

// Database configuration
$host = "localhost";
$dbname = "driversDB";
$username = "root";
$password = ""; // Set your database password here

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch(PDOException $e) {
    echo json_encode(["error" => "Connection failed: " . $e->getMessage()]);
    exit();
}

// Get request method
$method = $_SERVER['REQUEST_METHOD'];

switch($method) {
    case 'GET':
        // Read all drivers or specific driver
        $driver_id = isset($_GET['driver_id']) ? $_GET['driver_id'] : null;
        
        if ($driver_id) {
            $stmt = $conn->prepare("SELECT * FROM drivers WHERE driver_id = ?");
            $stmt->execute([$driver_id]);
        } else {
            $stmt = $conn->query("SELECT * FROM drivers");
        }
        
        $drivers = $stmt->fetchAll(PDO::FETCH_ASSOC);
        echo json_encode($drivers);
        break;

    case 'POST':
        // Create new driver
        $data = json_decode(file_get_contents("php://input"), true);
        
        if (!isset($data['name']) || !isset($data['age']) || !isset($data['phone_number'])) {
            echo json_encode(["error" => "Missing required fields"]);
            exit();
        }

        $stmt = $conn->prepare("INSERT INTO drivers (name, age, phone_number) VALUES (?, ?, ?)");
        
        try {
            $stmt->execute([$data['name'], $data['age'], $data['phone_number']]);
            echo json_encode([
                "message" => "Driver created successfully",
                "driver_id" => $conn->lastInsertId()
            ]);
        } catch(PDOException $e) {
            echo json_encode(["error" => $e->getMessage()]);
        }
        break;

    case 'PUT':
        // Update existing driver
        $data = json_decode(file_get_contents("php://input"), true);
        
        if (!isset($data['driver_id'])) {
            echo json_encode(["error" => "Driver ID is required"]);
            exit();
        }

        $updates = [];
        $params = [];

        if (isset($data['name'])) {
            $updates[] = "name = ?";
            $params[] = $data['name'];
        }
        if (isset($data['age'])) {
            $updates[] = "age = ?";
            $params[] = $data['age'];
        }
        if (isset($data['phone_number'])) {
            $updates[] = "phone_number = ?";
            $params[] = $data['phone_number'];
        }

        if (empty($updates)) {
            echo json_encode(["error" => "No fields to update"]);
            exit();
        }

        $params[] = $data['driver_id'];
        $sql = "UPDATE drivers SET " . implode(", ", $updates) . " WHERE driver_id = ?";
        
        $stmt = $conn->prepare($sql);
        
        try {
            $stmt->execute($params);
            echo json_encode(["message" => "Driver updated successfully"]);
        } catch(PDOException $e) {
            echo json_encode(["error" => $e->getMessage()]);
        }
        break;

    case 'DELETE':
        // Delete driver
        $driver_id = isset($_GET['driver_id']) ? $_GET['driver_id'] : null;
        
        if (!$driver_id) {
            echo json_encode(["error" => "Driver ID is required"]);
            exit();
        }

        $stmt = $conn->prepare("DELETE FROM drivers WHERE driver_id = ?");
        
        try {
            $stmt->execute([$driver_id]);
            echo json_encode(["message" => "Driver deleted successfully"]);
        } catch(PDOException $e) {
            echo json_encode(["error" => $e->getMessage()]);
        }
        break;

    default:
        echo json_encode(["error" => "Method not allowed"]);
        break;
}