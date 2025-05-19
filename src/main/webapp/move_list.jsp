<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movie List - MovieMagnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #ffeb3b;
            --secondary-color: #ffd700;
            --text-color: #ffffff;
            --background-dark: #1a1a1a;
            --card-bg: rgba(255, 255, 255, 0.05);
        }

        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: 'Arial', sans-serif;
            color: var(--text-color);
            background: linear-gradient(180deg, var(--background-dark) 0%, #000000 100%);
            font-size: 20px;
            overflow-x: hidden;
            display: flex;
            flex-direction: column;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 25px 60px;
            background: rgba(0, 0, 0, 0.9);
            position: sticky;
            top: 0;
            z-index: 1000;
            border-bottom: 3px solid var(--primary-color);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            transition: background 0.3s ease;
        }

        header:hover {
            background: rgba(0, 0, 0, 0.95);
        }

        .logo {
            font-size: 48px;
            font-weight: bold;
            color: var(--text-color);
            text-transform: uppercase;
            transition: transform 0.3s ease, color 0.3s ease;
        }

        .logo span {
            color: var(--primary-color);
            font-size: 32px;
            margin-top: 5px;
        }

        .logo:hover {
            transform: scale(1.1);
            color: var(--secondary-color);
        }

        nav {
            display: flex;
            align-items: center;
        }

        nav ul {
            list-style: none;
            display: flex;
            margin: 0;
            gap: 30px;
        }

        nav ul li a {
            text-decoration: none;
            color: #ddd;
            font-size: 28px;
            font-weight: 600;
            padding: 8px 12px;
            transition: color 0.3s ease, transform 0.3s ease;
            border-radius: 5px;
        }

        nav ul li a:hover, .active {
            color: var(--primary-color);
            transform: translateY(-3px);
            background: rgba(255, 235, 59, 0.2);
        }

        .hamburger {
            display: none;
            font-size: 28px;
            color: var(--text-color);
            cursor: pointer;
        }

        .login-link, .logout-link {
            padding: 18px 40px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            border-radius: 30px;
            text-decoration: none;
            color: #1a1a1a;
            font-size: 28px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s ease, box-shadow 0.3s;
            box-shadow: 0 4px 15px rgba(255, 235, 59, 0.6);
            position: relative;
            overflow: hidden;
        }

        .login-link i, .logout-link i {
            font-size: 30px;
        }

        .login-link:hover, .logout-link:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(255, 235, 59, 0.8);
        }

        .login-link::before, .logout-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: 0.5s;
        }

        .login-link:hover::before, .logout-link:hover::before {
            left: 100%;
        }

        .container {
            max-width: 1400px;
            margin: 140px auto 60px;
            padding: 50px;
            background: rgba(26, 26, 26, 0.9);
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(10px);
            animation: fadeIn 1s ease-in-out;
        }

        .search-filter {
            display: flex;
            gap: 20px;
            margin-bottom: 40px;
        }

        .search-filter input {
            padding: 15px;
            border: none;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            font-size: 24px;
            color: var(--text-color);
            flex: 1;
            min-width: 250px;
        }

        .search-filter input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.2);
        }

        .movie-list h2 {
            font-size: 42px;
            color: var(--primary-color);
            text-transform: uppercase;
            margin-bottom: 40px;
            text-align: center;
        }

        .movie-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            grid-auto-flow: row dense;
            gap: 25px;
            justify-items: center;
        }

        @media (min-width: 1200px) {
            .movie-grid { grid-template-columns: repeat(4, 1fr); }
        }

        @media (min-width: 900px) and (max-width: 1199px) {
            .movie-grid { grid-template-columns: repeat(3, 1fr); }
        }

        .movie-card {
            background: var(--card-bg);
            border-radius: 15px;
            overflow: hidden;
            width: 100%;
            max-width: 350px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            position: relative;
        }

        .movie-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.3);
        }

        .movie-card img {
            width: 100%;
            height: 250px;
            object-fit: cover;
        }

        .movie-card .resolution-badge {
            position: absolute;
            top: 12px;
            right: 12px;
            background-color: #4CAF50;
            color: white;
            padding: 8px 15px;
            border-radius: 6px;
            font-size: 18px;
            font-weight: bold;
        }

        .movie-card .favorite-btn {
            position: absolute;
            top: 12px;
            left: 12px;
            background: none;
            border: none;
            color: #ccc;
            font-size: 28px;
            cursor: pointer;
            transition: color 0.3s;
        }

        .movie-card .favorite-btn:hover, .movie-card .favorite-btn.active {
            color: #e91e63;
        }

        .movie-card .movie-info {
            padding: 25px;
            text-align: center;
        }

        .movie-card .movie-info h3 {
            font-size: 28px;
            margin: 0 0 15px;
            color: var(--text-color);
            text-transform: uppercase;
        }

        .movie-card .movie-info p {
            font-size: 20px;
            color: rgba(255, 255, 255, 0.7);
            margin: 8px 0;
        }

        .movie-card .release-year {
            font-size: 22px;
            color: var(--primary-color);
            margin-top: 12px;
            font-weight: bold;
        }

        .movie-card .action-btn {
            padding: 12px 25px;
            background-color: var(--primary-color);
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 8px;
            font-size: 22px;
            font-weight: 600;
            transition: all 0.3s ease;
            border: none;
            cursor: pointer;
            margin-top: 12px;
        }

        .movie-card .action-btn:hover {
            background-color: var(--secondary-color);
            transform: translateY(-2px);
        }

        .no-movies {
            text-align: center;
            color: rgba(255, 255, 255, 0.7);
            font-size: 24px;
            margin-top: 25px;
        }

        footer {
            background-color: #333;
            color: var(--text-color);
            padding: 25px;
            text-align: center;
            margin-top: auto;
        }

        .custom-footer .copyright {
            margin: 0;
            font-size: 22px;
        }

        .custom-footer .company {
            color: var(--primary-color);
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.85);
            display: flex;
            justify-content: center;
            align-items: center;
            animation: fadeInModal 0.5s ease;
        }

        .modal-content {
            background: linear-gradient(135deg, rgba(26, 26, 26, 0.95), rgba(0, 0, 0, 0.95));
            margin: auto;
            padding: 60px;
            border-radius: 20px;
            width: 80%;
            max-width: 800px;
            text-align: center;
            color: var(--text-color);
            border: 4px solid var(--primary-color);
            box-shadow: 0 15px 40px rgba(255, 235, 59, 0.5);
            animation: slideInModal 0.5s ease;
            position: relative;
            overflow: hidden;
        }

        .modal-content::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 235, 59, 0.1) 0%, transparent 70%);
            animation: rotateGradient 10s linear infinite;
            z-index: 0;
        }

        .modal-content > * {
            position: relative;
            z-index: 1;
        }

        .modal-content h2 {
            font-size: 52px;
            margin-bottom: 30px;
            color: var(--primary-color);
            text-transform: uppercase;
            text-shadow: 2px 2px 10px rgba(255, 235, 59, 0.3);
        }

        .modal-content .form-group {
            margin-bottom: 25px;
            text-align: left;
        }

        .modal-content label {
            display: block;
            margin-bottom: 10px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 600;
            font-size: 32px;
        }

        .modal-content input {
            width: 100%;
            padding: 18px;
            border: none;
            background: rgba(255, 255, 255, 0.15);
            border-radius: 12px;
            font-size: 28px;
            color: var(--text-color);
            transition: background 0.3s, box-shadow 0.3s;
        }

        .modal-content input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.25);
            box-shadow: 0 0 10px rgba(255, 235, 59, 0.5);
        }

        .modal-content .submit-btn {
            width: 100%;
            padding: 20px;
            background: linear-gradient(45deg, var(--primary-color), var(--secondary-color));
            color: #1a1a1a;
            border: none;
            border-radius: 12px;
            font-size: 30px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        .modal-content .submit-btn:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(255, 235, 59, 0.7);
        }

        .modal-content .switch-link {
            margin-top: 30px;
            color: var(--primary-color);
            text-decoration: none;
            font-size: 28px;
            transition: color 0.3s, text-shadow 0.3s;
        }

        .modal-content .switch-link:hover {
            color: #4CAF50;
            text-shadow: 0 0 10px rgba(76, 175, 80, 0.5);
        }

        .close {
            position: absolute;
            top: 30px;
            right: 35px;
            font-size: 48px;
            cursor: pointer;
            color: #ccc;
            transition: color 0.3s, transform 0.3s, text-shadow 0.3s;
        }

        .close:hover {
            color: var(--primary-color);
            transform: rotate(90deg) scale(1.1);
            text-shadow: 0 0 15px rgba(255, 235, 59, 0.7);
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideInModal {
            from { transform: translateY(-50px) scale(0.9); opacity: 0; }
            to { transform: translateY(0) scale(1); opacity: 1; }
        }

        @keyframes fadeInModal {
            from { background-color: rgba(0, 0, 0, 0); }
            to { background-color: rgba(0, 0, 0, 0.85); }
        }

        @keyframes rotateGradient {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @media (max-width: 1024px) {
            .movie-grid { grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); }
            .movie-card { max-width: 300px; }
            .movie-card img { height: 200px; }
            .movie-card .movie-info h3 { font-size: 24px; }
            .movie-card .movie-info p { font-size: 18px; }
            .movie-card .action-btn { font-size: 20px; }
            .modal-content { max-width: 700px; padding: 50px; }
        }

        @media (max-width: 768px) {
            header { padding: 20px 30px; flex-direction: column; gap: 15px; }
            .hamburger { display: block; }
            nav { display: none; width: 100%; }
            nav.active { display: block; }
            nav ul { flex-direction: column; gap: 20px; }
            .logo { font-size: 40px; }
            .logo span { font-size: 28px; }
            .login-link, .logout-link { font-size: 24px; padding: 15px 30px; }
            .login-link i, .logout-link i { font-size: 26px; }
            .container { margin-top: 120px; padding: 30px; }
            .movie-list h2 { font-size: 36px; }
            .movie-grid { grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); }
            .modal-content { max-width: 600px; padding: 40px; }
            .modal-content h2 { font-size: 44px; }
            .modal-content label { font-size: 28px; }
            .modal-content input { font-size: 24px; }
            .modal-content .submit-btn { font-size: 26px; }
        }

        @media (max-width: 480px) {
            .movie-grid { grid-template-columns: 1fr; }
            .movie-card img { height: 150px; }
            .movie-card .movie-info h3 { font-size: 22px; }
            .movie-card .movie-info p { font-size: 16px; }
            .movie-card .action-btn { font-size: 18px; }
            .logo { font-size: 36px; }
            .logo span { font-size: 24px; }
            .login-link, .logout-link { font-size: 20px; padding: 12px 25px; }
            .login-link i, .logout-link i { font-size: 22px; }
            .modal-content { max-width: 90%; padding: 30px; }
            .modal-content h2 { font-size: 36px; }
            .modal-content label { font-size: 24px; }
            .modal-content input { font-size: 20px; }
            .modal-content .submit-btn { font-size: 22px; }
        }
    </style>
</head>
<body>
<header>
    <div class="logo">
        Movie<span>MAGNET</span>
    </div>
    <div class="hamburger" aria-label="Toggle navigation" tabindex="0">
        <i class="fas fa-bars"></i>
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/publicMovieList" class="active">Movies</a></li>
            <li><a href="#">Contact us</a></li>
            <li><a href="#">About Us</a></li>
        </ul>
    </nav>
    <c:if test="${not empty sessionScope.username}">
        <a href="${pageContext.request.contextPath}/Customer/customer-login.jsp" class="logout-link" aria-label="Logout">
            <i class="fa fa-fw fa-sign-out-alt"></i> Logout
        </a>
    </c:if>
    <c:if test="${empty sessionScope.username}">
        <a href="#" class="login-link" id="loginLink" aria-label="Login">
            <i class="fa fa-fw fa-user"></i> Login
        </a>
    </c:if>
</header>

<div class="container">
    <div class="movie-list">
        <h2>Now Showing</h2>
        <div class="search-filter">
            <input type="text" id="searchInput" placeholder="Search movies..." aria-label="Search movies">
        </div>
        <c:choose>
            <c:when test="${empty movies}">
                <p class="no-movies">No movies available at the moment.</p>
            </c:when>
            <c:otherwise>
                <div class="movie-grid">
                    <c:forEach var="movie" items="${movies}">
                        <c:if test="${not empty movie}">
                            <div class="movie-card" data-genre="${fn:toLowerCase(movie.genre)}">
                                <c:if test="${not empty movie.imageLink}">
                                    <img src="${pageContext.request.contextPath}${movie.imageLink}" alt="${movie.title} image">
                                </c:if>
                                <div class="resolution-badge">1080p</div>
                                <button class="favorite-btn" aria-label="Add to favorites">
                                    <i class="far fa-heart"></i>
                                </button>
                                <div class="movie-info">
                                    <h3><c:out value="${movie.title}"/></h3>
                                    <p>Genre: <c:out value="${movie.genre}"/></p>
                                    <p>Duration: <c:out value="${movie.duration}"/> mins</p>
                                    <p>Release Date: <c:out value="${movie.releaseDate}"/></p>
                                    <div class="release-year">
                                        <c:if test="${not empty movie.releaseDate}">
                                            <c:out value="${fn:substring(movie.releaseDate, 0, 4)}"/>
                                        </c:if>
                                    </div>
                                    <button class="action-btn" onclick="openLoginModal('${movie.movieId}')">
                                        View Showtimes
                                    </button>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer>
    <div class="custom-footer">
        <p class="copyright">© <span class="company">Nexora</span> 2025. All rights reserved.</p>
    </div>
</footer>

<div id="loginModal" class="modal" role="dialog">
    <div class="modal-content">
        <span class="close" onclick="closeLoginModal()" aria-label="Close modal">×</span>
        <h2>Customer Login</h2>
        <form id="customerLoginForm" action="${pageContext.request.contextPath}/CustomerLoginServlet" method="post">
            <div class="form-group">
                <label for="modalUsername">Username</label>
                <input type="text" id="modalUsername" name="username" placeholder="Enter username" required aria-required="true">
            </div>
            <div class="form-group">
                <label for="modalPassword">Password</label>
                <input type="password" id="modalPassword" name="password" placeholder="Enter password" required aria-required="true">
            </div>
            <button type="submit" class="submit-btn">Login</button>
        </form>
        <a href="${pageContext.request.contextPath}/Customer/customer-register.jsp" class="switch-link">
            Don't have an account? Register
        </a>
    </div>
</div>

<script>
    // Hamburger menu toggle
    const hamburger = document.querySelector('.hamburger');
    const nav = document.querySelector('nav');
    hamburger.addEventListener('click', () => {
        nav.classList.toggle('active');
    });

    // Favorite button toggle
    document.querySelectorAll('.favorite-btn').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.classList.toggle('active');
            btn.querySelector('i').classList.toggle('far');
            btn.querySelector('i').classList.toggle('fas');
        });
    });

    // Search functionality
    const searchInput = document.getElementById('searchInput');
    const movieCards = document.querySelectorAll('.movie-card');

    function filterMovies() {
        const searchTerm = searchInput.value.toLowerCase().trim();
        movieCards.forEach(card => {
            const title = card.querySelector('h3').textContent.toLowerCase();
            const matchesSearch = title.includes(searchTerm);
            card.style.display = matchesSearch ? 'block' : 'none';
        });
    }

    searchInput.addEventListener('input', filterMovies);

    // Modal functionality
    const loginLink = document.getElementById('loginLink');
    loginLink.addEventListener('click', (e) => {
        e.preventDefault();
        openLoginModal();
    });

    function openLoginModal(movieId) {
        const modal = document.getElementById('loginModal');
        modal.style.display = 'flex';
        document.getElementById('customerLoginForm').setAttribute('data-movie-id', movieId || '');
    }

    function closeLoginModal() {
        document.getElementById('loginModal').style.display = 'none';
    }

    document.getElementById('customerLoginForm').addEventListener('submit', function(e) {
        const movieId = this.getAttribute('data-movie-id');
        if (movieId) {
            this.action += '?movieId=' + encodeURIComponent(movieId);
        }
    });

    window.addEventListener('click', function(e) {
        if (e.target == document.getElementById('loginModal')) {
            closeLoginModal();
        }
    });

    // Keyboard accessibility
    document.querySelector('.hamburger').addEventListener('keydown', (e) => {
        if (e.key === 'Enter' || e.key === ' ') {
            nav.classList.toggle('active');
        }
    });
</script>
</body>
</html>