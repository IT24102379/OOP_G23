<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Theater List</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    table { width: 100%; border-collapse: collapse; margin-top: 20px; }
    th, td { padding: 10px; border: 1px solid #ddd; text-align: left; }
    th { background-color: #4CAF50; color: white; }
    .action-btn { padding: 5px 10px; margin: 0 5px; text-decoration: none; }
    .update-btn { background-color: #4CAF50; color: white; }
    .delete-btn { background-color: #e74c3c; color: white; border: none; padding: 5px 10px; cursor: pointer; }
    .back-link { display: block; margin: 20px 0; color: #34a853; text-decoration: none; }
    .success-message { color: green; text-align: center; }
    .error-message { color: red; text-align: center; }
  </style>
</head>
<body>
<h1>Theater List</h1>
<% if (request.getParameter("success") != null) { %>
<p class="success-message"><%= request.getParameter("success") %></p>
<% } %>
<% if (request.getParameter("error") != null) { %>
<p class="error-message"><%= request.getParameter("error") %></p>
<% } %>
<a href="theater-create.jsp">Add New Theater</a>
<table>
  <tr>
    <th>ID</th>
    <th>Name</th>
    <th>Location</th>
    <th>Capacity</th>
    <th>Actions</th>
  </tr>
  <c:forEach var="theater" items="${theaters}">
    <tr>
      <td>${theater.theaterId}</td>
      <td>${theater.name}</td>
      <td>${theater.location}</td>
      <td>${theater.capacity}</td>
      <td>
        <a href="TheaterUpdateServlet?theaterId=${theater.theaterId}" class="action-btn update-btn">Update</a>
        <form action="TheaterDeleteServlet" method="post" style="display:inline;">
          <input type="hidden" name="theaterId" value="${theater.theaterId}">
          <button type="submit" class="delete-btn" onclick="return confirm('Are you sure?')">Delete</button>
        </form>
      </td>
    </tr>
  </c:forEach>
</table>
<a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</body>
</html>