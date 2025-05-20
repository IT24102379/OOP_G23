<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Movie List</title>
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

    .container {
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      padding: 30px;
      width: 100%;
      max-width: 1200px;
    }

    h1 {
      color: #333;
      text-align: center;
      margin-bottom: 25px;
      font-size: 24px;
    }

    /* Row-First Dynamic Movie Cards Grid */
    .movie-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      grid-auto-flow: row dense;
      gap: 20px;
      justify-items: center;
    }

    .movie-card {
      background: #fff;
      border-radius: 10px;
      overflow: hidden;
      width: 100%;
      max-width: 300px;
      box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
      transition: transform 0.3s ease, box-shadow 0.3s ease;
      position: relative;
    }

    .movie-card:hover {
      transform: translateY(-5px);
      box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2);
    }

    .movie-card img {
      width: 100%;
      height: 200px;
      object-fit: cover;
      display: block;
    }

    .movie-card .resolution-badge {
      position: absolute;
      top: 10px;
      right: 10px;
      background-color: #4CAF50;
      color: white;
      padding: 5px 10px;
      border-radius: 5px;
      font-size: 12px;
      font-weight: bold;
    }

    .movie-card .movie-info {
      padding: 15px;
      text-align: center;
    }

    .movie-card .movie-info h3 {
      font-size: 18px;
      margin: 0 0 10px;
      color: #333;
      text-transform: uppercase;
    }

    .movie-card .movie-info p {
      font-size: 14px;
      color: #555;
      margin: 5px 0;
    }

    .movie-card .release-year {
      font-size: 14px;
      color: #34a853;
      margin-top: 10px;
      font-weight: bold;
    }

    .movie-card .actions {
      margin-top: 10px;
      display: flex;
      justify-content: center;
      gap: 10px;
    }

    .action-btn {
      padding: 8px 12px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      transition: opacity 0.3s;
    }

    .update-btn {
      background-color: #34a853;
      color: white;
    }

    .delete-btn {
      background-color: #ff4444;
      color: white;
    }

    .action-btn:hover {
      opacity: 0.9;
    }

    .back-link {
      display: block;
      text-align: center;
      margin-top: 20px;
      color: #34a853;
      text-decoration: none;
    }

    .error-message, .success-message {
      text-align: center;
      margin-bottom: 20px;
    }

    .error-message {
      color: red;
    }

    .success-message {
      color: green;
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
      .movie-grid {
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
      }

      .movie-card {
        max-width: 250px;
      }

      .movie-card img {
        height: 180px;
      }
    }

    @media (max-width: 768px) {
      .container {
        padding: 20px;
      }

      h1 {
        font-size: 20px;
      }

      .movie-grid {
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
      }

      .movie-card {
        max-width: 100%;
      }

      .movie-card img {
        height: 150px;
      }

      .movie-card .movie-info h3 {
        font-size: 16px;
      }

      .movie-card .movie-info p {
        font-size: 12px;
      }

      .movie-card .resolution-badge {
        font-size: 10px;
        padding: 3px 6px;
      }

      .movie-card .release-year {
        font-size: 12px;
      }

      .action-btn {
        padding: 6px 10px;
        font-size: 12px;
      }
    }

    @media (max-width: 480px) {
      .movie-grid {
        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
      }

      .movie-card img {
        height: 120px;
      }

      .movie-card .movie-info h3 {
        font-size: 14px;
      }

      .movie-card .movie-info p {
        font-size: 10px;
      }

      .movie-card .release-year {
        font-size: 10px;
      }
    }
  </style>
</head>
<body>
<div class="container">
  <h1>Movie List</h1>
  <c:if test="${not empty errorMessage}">
    <p class="error-message">${errorMessage}</p>
  </c:if>
  <c:if test="${not empty param.success}">
    <p class="success-message">${param.success}</p>
  </c:if>
  <div class="movie-grid">
    <c:forEach var="movie" items="${movies}">
      <div class="movie-card">
        <c:if test="${not empty movie.imageLink}">
          <img src="${pageContext.request.contextPath}${movie.imageLink}" alt="${movie.title} image">
        </c:if>
        <div class="resolution-badge">1080p</div>
        <div class="movie-info">
          <h3>${movie.title}</h3>
          <p>Genre: ${movie.genre}</p>
          <p>Duration: ${movie.duration} mins</p>
          <p>Release Date: ${movie.releaseDate}</p>
          <div class="release-year">
            <c:if test="${not empty movie.releaseDate}">
              <c:out value="${fn:substring(movie.releaseDate, 0, 4)}"/>
            </c:if>
          </div>
          <div class="actions">
            <a href="${pageContext.request.contextPath}/MovieUpdateServlet?movieId=${movie.movieId}">
              <button class="action-btn update-btn">Update</button>
            </a>
            <a href="${pageContext.request.contextPath}/MovieDeleteServlet?movieId=${movie.movieId}"
               onclick="return confirm('Are you sure you want to delete ${movie.title}?')">
              <button class="action-btn delete-btn">Delete</button>
            </a>
          </div>
        </div>
      </div>
    </c:forEach>
  </div>
  <a href="${pageContext.request.contextPath}/Admin/adminLoginSuccess.jsp" class="back-link">Back to Dashboard</a>
</div>
</body>
</html>