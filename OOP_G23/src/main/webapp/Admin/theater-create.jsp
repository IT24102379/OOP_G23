<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Create Theater</title>
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

    input[type="text"],
    input[type="number"] {
      width: 100%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 6px;
      box-sizing: border-box;
      font-size: 14px;
      transition: border-color 0.3s;
    }

    input[type="text"]:focus,
    input[type="number"]:focus {
      border-color: #4CAF50;
      outline: none;
      box-shadow: 0 0 5px rgba(76, 175, 80, 0.3);
    }

    .create-btn {
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

    .create-btn:hover, .create-btn:focus {
      background-color: #45a049;
      transform: translateY(-1px);
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
  </style>
</head>
<body>
<div class="form-container">
  <h1>Create New Theater</h1>
  <form action="${pageContext.request.contextPath}/TheaterCreateServlet" method="post">
    <div class="form-group">
      <label for="name">Theater Name</label>
      <input type="text" id="name" name="name" placeholder="Enter theater name" required>
    </div>
    <div class="form-group">
      <label for="location">Location</label>
      <input type="text" id="location" name="location" placeholder="Enter theater location" required>
    </div>
    <div class="form-group">
      <label for="capacity">Capacity</label>
      <input type="number" id="capacity" name="capacity" placeholder="Enter capacity" min="1" max="500" required>
    </div>
    <button type="submit" class="create-btn">Create Theater</button>
  </form>
  <a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>