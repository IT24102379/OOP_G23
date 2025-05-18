<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Movie Details</title>
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
        .buttons {
            display: flex;
            justify-content: space-between;
        }
        .button {
            padding: 5px 15px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<c:choose>
    <c:when test="${not empty movie}">
        <div class="container">
            <h2>Movie Details</h2>
            <div class="row">
                <span class="label">Movie ID:</span>
                <span>${movie.movieID}</span>
            </div>
            <div class="row">
                <span class="label">Movie Name:</span>
                <span>${movie.title}</span>
            </div>
            <div class="row">
                <span class="label">Genre:</span>
                <span>${movie.genre}</span>
            </div>
            <div class="row">
                <span class="label">Release Date:</span>
                <span>${movie.releaseDate}</span>
            </div>
            <div class="row">
                <span class="label">Duration:</span>
                <span>${movie.duration} minutes</span>
            </div>
            <div class="row">
                <span class="label">Showtimes:</span>
                <span>
                        <c:if test="${not empty movie.showtimes}">
                            <c:forEach var="showtime" items="${movie.showtimes}">
                                ${showtime}<br>
                            </c:forEach>
                        </c:if>
                        <c:if test="${empty movie.showtimes}">
                            No showtimes available.
                        </c:if>
                    </span>
            </div>
            <div class="buttons">
                <form action="updateMovie.jsp" method="get">
                    <input type="hidden" name="movieID" value="${movie.movieID}">
                    <input type="submit" value="Update" class="button">
                </form>
                <form action="MovieDeleteServlet" method="post">
                    <input type="hidden" name="movieID" value="${movie.movieID}">
                    <input type="submit" value="Delete" class="button">
                </form>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="container">
            <h2>Error</h2>
            <p>Movie not found. Please select a valid movie.</p>
        </div>
    </c:otherwise>
</c:choose>
<a href="/index.jsp">Back to Home</a>
</body>
</html>