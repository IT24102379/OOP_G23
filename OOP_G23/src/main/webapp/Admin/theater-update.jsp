<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Update Theater</title>
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
    input[type="hidden"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      box-sizing: border-box;
      font-size: 16px;
    }

    input[type="text"]:focus,
    input[type="number"]:focus {
      border-color: #4CAF50;
      outline: none;
    }

    .update-btn {
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

    .update-btn:hover {
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
  <h1>Update Theater</h1>
  <form action="${pageContext.request.contextPath}/TheaterUpdateServlet" method="post">
    <input type="hidden" name="theaterId" value="${theater.theaterId}">
    <div class="form-group">
      <label for="name">Name</label>
      <input type="text" id="name" name="name" value="${theater.name}" required>
    </div>
    <div class="form-group">
      <label for="location">Location</label>
      <input type="text" id="location" name="location" value="${theater.location}" required>
    </div>
    <div class="form-group">
      <label for="capacity">Capacity</label>
      <input type="number" id="capacity" name="capacity" value="${theater.capacity}" required>
    </div>
    <button type="submit" class="update-btn">Update Theater</button>
  </form>
  <a href="${pageContext.request.contextPath}/TheaterListServlet" class="back-link">Back to Theater List</a>
</div>
</body>
</html>