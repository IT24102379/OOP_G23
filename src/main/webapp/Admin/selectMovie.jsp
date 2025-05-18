<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Select Movie</title>
</head>
<body>
<h2>Select a Movie to View Details</h2>
<form action="MovieDetailsServlet" method="get">
    <label for="movieID">Movie ID:</label>
    <input type="text" id="movieID" name="movieID" required>
    <input type="submit" value="View Details">
</form>
<br>
<a href="/index.jsp">Back to Home</a>
</body>
</html>