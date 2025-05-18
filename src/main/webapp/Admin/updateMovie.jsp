<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.model.Movie" %>
<%
    String movieID = request.getParameter("movieID");
    Movie movie = Movie.findMovieByID(movieID);
    if (movie == null) {
        response.sendError(HttpServletResponse.SC_NOT_FOUND, "Movie not found");
        return;
    }
%>
<html>
<head>
    <title>Update Movie</title>
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
    <h2>Update Movie</h2>
    <form action="MovieUpdateServlet" method="post">
        <input type="hidden" name="movieID" value="<%= movie.getMovieID() %>">
        <div class="row">
            <span class="label">Movie Name:</span>
            <input type="text" name="title" value="<%= movie.getTitle() %>">
        </div>
        <div class="row">
            <span class="label">Genre:</span>
            <input type="text" name="genre" value="<%= movie.getGenre() %>">
        </div>
        <div class="row">
            <span class="label">Year:</span>
            <input type="text" name="releaseDate" value="<%= movie.getReleaseDate() %>">
        </div>
        <div class="row">
            <span class="label">Duration (min):</span>
            <input type="number" name="duration" value="<%= movie.getDuration() %>">
        </div>
        <div class="row">
            <input type="submit" value="Update" class="button">
        </div>
    </form>
</div>
<a href="index.jsp">Back to Home</a>
</body>
</html>