<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Showtime</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #f5f7fa, #ffffff);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            color: #333;
        }

        .form-container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            width: 100%;
            max-width: 450px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 25px;
            font-size: 24px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #555;
        }

        input[type="datetime-local"],
        input[type="number"],
        input[type="hidden"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            font-size: 14px;
            transition: border-color 0.3s;
        }

        input[type="datetime-local"]:focus,
        input[type="number"]:focus {
            border-color: #4CAF50;
            outline: none;
            box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
        }

        .update-btn {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s, transform 0.1s;
        }

        .update-btn:hover, .update-btn:focus {
            background-color: #45a049;
            transform: translateY(-1px);
        }

        .update-btn:focus {
            outline: 2px solid #ffffff;
            outline-offset: 2px;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #34a853;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s;
        }

        .back-link:hover, .back-link:focus {
            color: #2e8b57;
            text-decoration: underline;
        }

        .back-link:focus {
            outline: 2px solid #4CAF50;
            outline-offset: 2px;
            border-radius: 4px;
        }

        @media (max-width: 480px) {
            .form-container {
                padding: 20px;
            }

            h1 {
                font-size: 20px;
            }

            input[type="datetime-local"],
            input[type="number"] {
                font-size: 13px;
            }

            .update-btn {
                font-size: 14px;
            }
        }
    </style>
</head>
<body>
<div class="form-container">
    <h1>Update Showtime</h1>
    <form action="${pageContext.request.contextPath}/ShowtimeUpdateServlet" method="post">
        <input type="hidden" name="showtimeId" value="${showtime.showtimeId}">
        <div class="form-group">
            <label for="showtimeDate">Showtime Date & Time</label>
            <input type="datetime-local" id="showtimeDate" name="showtimeDate" value="${showtime.showtimeDate}" required>
        </div>
        <div class="form-group">
            <label for="movieId">Movie ID</label>
            <input type="number" id="movieId" name="movieId" value="${showtime.movieId}" required>
        </div>
        <div class="form-group">
            <label for="theaterId">Theater ID</label>
            <input type="number" id="theaterId" name="theaterId" value="${showtime.theaterId}" required>
        </div>
        <button type="submit" class="update-btn">Update Showtime</button>
    </form>
    <a href="${pageContext.request.contextPath}/ShowtimeListServlet" class="back-link">Back to Showtime List</a>
</div>
</body>
</html>