<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Registration</title>
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

        .error-message {
            color: red;
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="form-container">
        <h2 class="form-title">Admin Registration</h2>
        <% if (request.getAttribute("errorMessage") != null) { %>
        <p class="error-message"><%= request.getAttribute("errorMessage") %></p>
        <% } %>
        <form id="adminRegisterForm" action="${pageContext.request.contextPath}/AdminRegisterServlet" method="post">
            <div class="form-group">
                <label for="adminName">Full Name</label>
                <input type="text" id="adminName" name="name" placeholder="Enter full name" value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>" required>
            </div>
            <div class="form-group">
                <label for="adminEmail">Email</label>
                <input type="email" id="adminEmail" name="email" placeholder="Enter email" value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>" required>
            </div>
            <div class="form-group">
                <label for="adminPassword">Password</label>
                <input type="password" id="adminPassword" name="password" placeholder="Enter password" required>
            </div>
            <button type="submit" class="submit-btn">Register</button>
        </form>
        <a href="${pageContext.request.contextPath}/Admin/admin-login.jsp" class="switch-link">Already have an account? Login</a>
        <a href="${pageContext.request.contextPath}/index.jsp" class="switch-link">← Back to Home</a>
    </div>
</div>
</body>
</html>