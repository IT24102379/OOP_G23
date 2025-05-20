<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Showtime</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 400px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #555;
        }

        input[type="datetime-local"],
        input[type="number"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }

        input[type="datetime-local"]:focus,
        input[type="number"]:focus {
            border-color: #4CAF50;
            outline: none;
        }

        .create-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }

        .create-btn:hover {
            background-color: #45a049;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #34a853;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Create New Showtime</h1>
    <form action="${pageContext.request.contextPath}/ShowtimeCreateServlet" method="post">
        <div class="form-group">
            <label for="showtimeDate">Showtime Date & Time</label>
            <input type="datetime-local" id="showtimeDate" name="showtimeDate" required>
        </div>
        <div class="form-group">
            <label for="movieId">Movie ID</label>
            <input type="number" id="movieId" name="movieId" placeholder="Enter Movie ID" required>
        </div>
        <div class="form-group">
            <label for="theaterId">Theater ID</label>
            <input type="number" id="theaterId" name="theaterId" placeholder="Enter Theater ID" required>
        </div>
        <button type="submit" class="create-btn">Create Showtime</button>
    </form>
    <a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>