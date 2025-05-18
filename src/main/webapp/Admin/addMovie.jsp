<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Add Movie</title>
    <style>
        .container {
            border: 1px solid black;
            padding: 15px;
            width: 300px;
            margin: 20px;
        }
        .row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .label {
            font-weight: bold;
        }
        input[type="text"], input[type="number"] {
            width: 150px;
        }
        .button {
            padding: 5px 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Add Movie</h2>
    <form action="MovieRegisterServlet" method="post">
        <div class="row">
            <span class="label">Movie Name:</span>
            <input type="text" name="title" required>
        </div>
        <div class="row">
            <span class="label">Genre:</span>
            <input type="text" name="genre" required>
        </div>
        <div class="row">
            <span class="label">Year:</span>
            <input type="text" name="releaseDate" placeholder="YYYY-MM-DD" required>
        </div>
        <div class="row">
            <span class="label">Duration (min):</span>
            <input type="number" name="duration" required>
        </div>
        <div class="row">
            <span class="label">Movie ID:</span>
            <input type="text" name="movieID" required>
        </div>
        <div class="row">
            <input type="submit" value="Add" class="button">
        </div>
    </form>
</div>
<a href="index.jsp">Back to Home</a>
</body>
</html>