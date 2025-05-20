<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/main.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            text-align: center;
        }
        .welcome-message {
            text-align: center;
            margin-bottom: 20px;
        }
        .action-links {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 15px;
        }
        .action-links a {
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            transition: background-color 0.3s;
        }
        .action-links a:hover {
            background-color: #45a049;
        }
        .logout-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #e74c3c;
            text-decoration: none;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Admin Dashboard</h1>
    <div class="welcome-message">
        Welcome, <%= request.getAttribute("username") %>! (ID: <%= request.getAttribute("userId") %>)
    </div>
    <% if (request.getParameter("success") != null) { %>
    <p style="color: green; text-align: center;"><%= request.getParameter("success") %></p>
    <% } %>
    <div class="action-links">
        <a href="${pageContext.request.contextPath}/Admin/movie-create.jsp">Create Movie</a>
        <a href="${pageContext.request.contextPath}/MovieListServlet">Manage Movies</a>
        <a href="${pageContext.request.contextPath}/Admin/theater-create.jsp">Create Theater</a>

        <a href="${pageContext.request.contextPath}/TheaterListServlet">Manage Theaters</a>
        <a href="${pageContext.request.contextPath}/Admin/showtime-create.jsp">Create Showtime</a>

        <a href="${pageContext.request.contextPath}/ShowtimeListServlet">Manage Showtimes</a>
        <a href="${pageContext.request.contextPath}/Admin/admin-update.jsp">Update Profile</a>
        <a href="${pageContext.request.contextPath}/Admin/admin-delete.jsp">Delete Account</a>

    </div>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link">Logout</a>
</div>
</body>
</html>