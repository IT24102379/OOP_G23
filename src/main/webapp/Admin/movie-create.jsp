<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Movie</title>
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

        input[type="text"],
        input[type="number"],
        input[type="date"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            font-size: 16px;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus {
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

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
    <script>
        function validateForm() {
            const duration = document.getElementById("duration").value;
            const imageLink = document.getElementById("imageLink").value;
            const releaseDate = document.getElementById("releaseDate").value;
            const pathPattern = /^\/images\/.*\.(?:png|jpg|jpeg|gif)$/i;
            const today = new Date().toISOString().split("T")[0];

            if (duration <= 0) {
                alert("Duration must be a positive number.");
                return false;
            }
            if (imageLink && !pathPattern.test(imageLink)) {
                alert("Image path must start with '/images/' and end with .png, .jpg, .jpeg, or .gif");
                return false;
            }
            if (!releaseDate) {
                alert("Release date is required.");
                return false;
            }
            if (releaseDate > today) {
                alert("Release date cannot be in the future.");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
<div class="form-container">
    <h1>Create New Movie</h1>
    <c:if test="${not empty errorMessage}">
        <p class="error-message">${errorMessage}</p>
    </c:if>
    <form action="${pageContext.request.contextPath}/MovieCreateServlet" method="post" onsubmit="return validateForm()">
        <div class="form-group">
            <label for="title">Title</label>
            <input type="text" id="title" name="title" placeholder="Enter movie title" required>
        </div>
        <div class="form-group">
            <label for="genre">Genre</label>
            <input type="text" id="genre" name="genre" placeholder="Enter genre" required>
        </div>
        <div class="form-group">
            <label for="duration">Duration (minutes)</label>
            <input type="number" id="duration" name="duration" placeholder="Enter duration" required>
        </div>
        <div class="form-group">
            <label for="imageLink">Image Path</label>
            <input type="text" id="imageLink" name="imageLink" placeholder="/images/movie1.jpg">
        </div>
        <div class="form-group">
            <label for="releaseDate">Release Date</label>
            <input type="date" id="releaseDate" name="releaseDate" required>
        </div>
        <button type="submit" class="create-btn">Create Movie</button>
    </form>
    <a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>