<?php
header("Content-Type: application/json");

$conn = new mysqli("localhost", "root", "", "daltdd");

// Xử lý yêu cầu GET để lấy dữ liệu
if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    $sql = "SELECT * FROM food_journal";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = [];
        while($row = $result->fetch_assoc()) {
            $data[] = $row;
        }
        echo json_encode($data);
    } else {
        echo json_encode([]);
    }
}

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $food_id = $_POST['food_id'];
    $quatity = $_POST['quatity'];
    $DateNhatKy = $_POST['DateNhatKy'];
    $calories_total = $_POST['calories_total'];

    $query = "INSERT INTO food_journal (user_id, food_id, quatity, DateNhatKy, calories_total) VALUES ('$user_id', '$food_id', '$quatity', '$DateNhatKy', '$calories_total')";

    if ($conn->query($query)) {
        echo json_encode(["message" => "User added successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["error" => "Failed to add user"]);
    }
}

$conn->close();
?>