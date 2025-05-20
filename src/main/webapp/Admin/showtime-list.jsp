<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Showtime List</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background: linear-gradient(135deg, #f5f7fa, #ffffff);
            display: flex;
            justify-content: center;
            min-height: 100vh;
            color: #333;
        }

        .container {
            width: 100%;
            max-width: 1000px;
        }

        h1 {
            color: #333;
            text-align: center;
            margin-bottom: 20px;
            font-size: 24px;
            font-weight: 600;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        th, td {
            padding: 12px 15px;
            border: 1px solid #ddd;
            text-align: left;
            font-size: 14px;
            transition: background-color 0.3s;
        }

        th {
            background: linear-gradient(135deg, #4CAF50, #3b9c43);
            color: white;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        td {
            background-color: #fff;
        }

        tr:hover td {
            background-color: #f9f9f9;
        }

        .action-btn {
            padding: 6px 12px;
            margin: 0 5px;
            text-decoration: none;
            border-radius: 4px;
            font-size: 14px;
            transition: background-color 0.3s, transform 0.1s;
        }

        .update-btn {
            background-color: #4CAF50;
            color: white;
        }

        .update-btn:hover, .update-btn:focus {
            background-color: #45a049;
            transform: translateY(-1px);
        }

        .delete-btn {
            background-color: #e74c3c;
            color: white;
        }

        .delete-btn:hover, .delete-btn:focus {
            background-color: #c0392b;
            transform: translateY(-1px);
        }

        .action-btn:focus {
            outline: 2px solid #4CAF50;
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

        .success-message {
            color: #27ae60;
            text-align: center;
            margin-bottom: 20px;
            font-weight: 500;
            background-color: rgba(39, 174, 96, 0.1);
            padding: 10px;
            border-radius: 4px;
        }

        @media (max-width: 768px) {
            table {
                font-size: 13px;
            }

            th, td {
                padding: 10px 12px;
            }

            .action-btn {
                padding: 5px 10px;
                font-size: 13px;
            }
        }

        @media (max-width: 480px) {
            h1 {
                font-size: 20px;
            }

            table {
                font-size: 12px;
            }

            th, td {
                padding: 8px 10px;
            }

            .action-btn {
                padding: 4px 8px;
                font-size: 12px;
            }
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Showtime List</h1>
    <% if (request.getParameter("success") != null) { %>
    <p class="success-message"><%= request.getParameter("success") %></p>
    <% } %>
    <a href="showtime-create.jsp" class="action-btn update-btn">Add New Showtime</a>
    <table>
        <tr>
            <th>ID</th>
            <th>Date & Time</th>
            <th>Movie ID</th>
            <th>Theater ID</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="showtime" items="${showtimes}">
            <tr>
                <td>${showtime.showtimeId}</td>
                <td>${showtime.showtimeDate}</td>
                <td>${showtime.movieId}</td>
                <td>${showtime.theaterId}</td>
                <td>
                    <a href="ShowtimeUpdateServlet?showtimeId=${showtime.showtimeId}" class="action-btn update-btn">Update</a>
                    <a href="ShowtimeDeleteServlet?showtimeId=${showtime.showtimeId}" class="action-btn delete-btn" onclick="return confirm('Are you sure?')">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
    <a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>