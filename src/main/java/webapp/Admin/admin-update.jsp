<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Admin Details</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/main.css">
    <style>
        .form-container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            width: 400px;
            margin: 50px auto;
        }

        .form-title {
            margin-bottom: 20px;
            color: #333;
            font-size: 24px;
            text-align: center;
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #34a853;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }

        .switch-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            color: #34a853;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h2 class="form-title">Update Admin Details</h2>
        <form id="adminUpdateForm" action="${pageContext.request.contextPath}/AdminUpdateServlet" method="post">
            <div class="form-group">
                <label for="previous-email">Current Email</label>
                <input type="email" id="previous-email" name="previous-email" placeholder="Enter current email" required>
            </div>
            <div class="form-group">
                <label for="previous-password">Current Password</label>
                <input type="password" id="previous-password" name="previous-password" placeholder="Enter current password" required>
            </div>
            <div class="form-group">
                <label for="username">New Username</label>
                <input type="text" id="username" name="username" placeholder="Enter new username" required>
            </div>
            <div class="form-group">
                <label for="email">New Email</label>
                <input type="email" id="email" name="email" placeholder="Enter new email" required>
            </div>
            <div class="form-group">
                <label for="password">New Password</label>
                <input type="password" id="password" name="password" placeholder="Enter new password" required>
            </div>
            <button type="submit" class="submit-btn">Update</button>
        </form>
        <a href="${pageContext.request.contextPath}/index.jsp" class="switch-link">← Back to Home</a>
    </div>
</div>
<script src="${pageContext.request.contextPath}/scripts/main.js"></script>
</body>
</html>