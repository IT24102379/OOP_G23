<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - MovieMagnet</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            overflow-x: hidden;
            font-family: 'Arial', sans-serif;
            background: linear-gradient(180deg, #1a1a1a 0%, #000000 100%);
            color: white;
            font-size: 18px;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 50px;
            background: rgba(0, 0, 0, 0.9);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 1000;
            border-bottom: 3px solid #ffeb3b;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5);
            box-sizing: border-box;
            transition: background 0.3s ease;
        }

        header:hover {
            background: rgba(0, 0, 0, 0.95);
        }

        .logo {
            display: flex;
            flex-direction: column;
            font-size: 40px;
            font-weight: bold;
            color: white;
            text-transform: uppercase;
            transition: transform 0.3s ease, color 0.3s ease;
        }

        .logo span {
            color: #ffeb3b;
            font-size: 26px;
            margin-top: 5px;
            transition: color 0.3s ease;
        }

        .logo:hover {
            transform: scale(1.1);
            color: #ffd700;
        }

        .logo:hover span {
            color: #ffca28;
        }

        nav ul {
            list-style: none;
            display: flex;
            align-items: center;
            margin: 0;
            gap: 25px;
        }

        nav ul li {
            margin: 0;
            position: relative;
        }

        nav ul li a {
            text-decoration: none;
            color: #ddd;
            font-size: 24px;
            font-weight: 600;
            text-transform: uppercase;
            padding: 5px 10px;
            transition: color 0.3s ease, transform 0.3s ease, background 0.3s ease;
            border-radius: 5px;
        }

        nav ul li a:hover, nav ul li a.active {
            color: #ffeb3b;
            transform: translateY(-3px);
            background: rgba(255, 235, 59, 0.2);
        }

        .login-link {
            margin-left: auto;
            margin-right: 20px;
            padding: 15px 35px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            border: none;
            border-radius: 30px;
            text-decoration: none;
            color: #1a1a1a;
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
            transition: all 0.3s ease, box-shadow 0.3s ease;
            box-shadow: 0 6px 20px rgba(255, 235, 59, 0.7);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .login-link i {
            font-size: 26px;
        }

        .login-link:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(255, 235, 59, 0.9);
            color: #1a1a1a;
        }

        .login-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.5), transparent);
            transition: 0.6s;
        }

        .login-link:hover::before {
            left: 100%;
        }

        .container {
            max-width: 1400px;
            margin: 150px auto 50px;
            padding: 50px;
            text-align: center;
        }

        .hero {
            position: relative;
            height: 600px;
            overflow: hidden;
            margin-top: 0;
            width: 100%;
            max-width: 100vw;
            left: 50%;
            transform: translateX(-50%);
        }

        .hero-slideshow {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
        }

        .hero-slide {
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            transition: opacity 1s ease-in-out;
            position: absolute;
            opacity: 0;
        }

        .hero-slide.active {
            opacity: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            height: 100%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: white;
            text-shadow: 2px 2px 10px rgba(0, 0, 0, 0.7);
        }

        .hero-content h1 {
            font-size: 52px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 4px;
            margin-bottom: 25px;
            background: linear-gradient(90deg, #ffffff, #ffeb3b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .hero-content p {
            font-size: 28px;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 35px;
            line-height: 1.6;
        }

        .hero-buttons a {
            padding: 18px 40px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 0.5rem;
            font-size: 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            gap: 12px;
            box-shadow: 0 4px 15px rgba(255, 235, 59, 0.4);
        }

        .hero-buttons a:hover {
            background: linear-gradient(45deg, #ffd700, #ffeb3b);
            transform: translateY(-4px);
            box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
        }

        .hero-buttons a::after {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
            transition: 0.5s;
        }

        .hero-buttons a:hover::after {
            left: 100%;
        }

        .movie-list {
            margin-top: 40px;
            padding: 20px 0;
        }

        .movie-list h2 {
            font-size: 36px;
            color: #ffeb3b;
            text-transform: uppercase;
            margin-bottom: 35px;
            text-shadow: 1px 1px 5px rgba(255, 235, 59, 0.3);
        }

        .movie-carousel {
            width: 100%;
            overflow: hidden;
            position: relative;
        }

        .movie-container {
            display: flex;
            animation: scroll 20s linear infinite;
            width: fit-content;
        }

        .movie-container:hover {
            animation-play-state: paused;
        }

        .movie-card {
            background: rgba(26, 26, 26, 0.9);
            border-radius: 15px;
            overflow: hidden;
            width: 300px;
            margin: 0 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            transition: transform 0.3s ease;
            text-align: center;
            padding: 15px;
            flex-shrink: 0;
        }

        .movie-card:hover {
            transform: translateY(-5px);
        }

        .movie-card img {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }

        .movie-info {
            padding: 15px 0;
        }

        .movie-info h3 {
            font-size: 24px;
            margin: 10px 0;
            color: white;
            text-transform: uppercase;
        }

        .movie-info p {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.7);
            margin: 5px 0;
        }

        .movie-info .release-year {
            font-size: 18px;
            color: #ffeb3b;
            font-weight: bold;
            margin: 10px 0;
        }

        .movie-card .action-btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #ffeb3b;
            color: #1a1a1a;
            text-decoration: none;
            border-radius: 5px;
            font-size: 18px;
            font-weight: 600;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .movie-card .action-btn:hover {
            background-color: #ffd700;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 235, 59, 0.5);
        }

        @keyframes scroll {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1001;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.8);
        }

        .modal-content {
            background: linear-gradient(135deg, rgba(26, 26, 26, 0.95), rgba(0, 0, 0, 0.95));
            margin: 5% auto;
            padding: 50px;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            text-align: center;
            color: white;
            position: relative;
            animation: slideIn 0.5s ease;
            border: 3px solid #ffeb3b;
            box-shadow: 0 10px 30px rgba(255, 235, 59, 0.5);
        }

        .modal-content h2 {
            font-size: 40px;
            margin-bottom: 30px;
            color: #ffeb3b;
            text-transform: uppercase;
            text-shadow: 2px 2px 8px rgba(255, 235, 59, 0.4);
        }

        .tabs {
            display: flex;
            justify-content: center;
            margin-bottom: 30px;
        }

        .tab-btn {
            flex: 1;
            padding: 15px;
            background: rgba(255, 255, 255, 0.1);
            border: none;
            color: white;
            font-size: 20px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border-bottom: 3px solid transparent;
        }

        .tab-btn.active {
            background: rgba(255, 235, 59, 0.2);
            border-bottom: 3px solid #ffeb3b;
            color: #ffeb3b;
        }

        .tab-btn:hover {
            background: rgba(255, 235, 59, 0.3);
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .modal-content .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .modal-content label {
            display: block;
            margin-bottom: 8px;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 600;
            font-size: 24px;
        }

        .modal-content input {
            width: 100%;
            padding: 12px;
            border: none;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 8px;
            font-size: 20px;
            color: white;
            transition: background 0.3s;
        }

        .modal-content input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.2);
        }

        .modal-content .submit-btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            color: #1a1a1a;
            border: none;
            border-radius: 8px;
            font-size: 22px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .modal-content .submit-btn:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(255, 235, 59, 0.6);
        }

        .modal-content .switch-link {
            display: block;
            margin-top: 20px;
            color: #ffeb3b;
            text-decoration: none;
            font-size: 20px;
            transition: color 0.3s;
        }

        .modal-content .switch-link:hover {
            color: #ffd700;
        }

        .close {
            position: absolute;
            top: 20px;
            right: 25px;
            font-size: 36px;
            cursor: pointer;
            color: #ccc;
            transition: color 0.3s, transform 0.3s;
        }

        .close:hover {
            color: #ffeb3b;
            transform: rotate(90deg);
        }

        footer {
            background: linear-gradient(180deg, rgba(51, 51, 51, 0.9), rgba(0, 0, 0, 0.9)), url('${pageContext.request.contextPath}/img/footer-bg.jpg') center/cover no-repeat;
            color: white;
            padding: 50px 20px;
            text-align: center;
            font-family: Arial, sans-serif;
            font-size: 18px;
            position: relative;
            margin-top: auto;
        }

        .footer-content {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 20px;
            max-width: 1200px;
            margin: 0 auto 30px;
        }

        .footer-section {
            flex: 1;
            min-width: 250px;
            text-align: left;
        }

        .footer-section h3 {
            font-size: 24px;
            color: #ffeb3b;
            margin-bottom: 20px;
            text-transform: uppercase;
        }

        .footer-section p, .footer-section a {
            font-size: 16px;
            color: rgba(255, 255, 255, 0.8);
            margin: 5px 0;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: #ffeb3b;
        }

        .footer-section.social .social-icons {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }

        .footer-section.social a {
            font-size: 24px;
            color: rgba(255, 255, 255, 0.8);
            transition: color 0.3s ease, transform 0.3s ease;
        }

        .footer-section.social a:hover {
            color: #ffeb3b;
            transform: translateY(-3px);
        }

        .footer-section.newsletter form {
            display: flex;
            gap: 10px;
            margin-top: 10px;
        }

        .footer-section.newsletter input {
            padding: 10px;
            border: none;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 5px;
            font-size: 16px;
            color: white;
            flex: 1;
        }

        .footer-section.newsletter input:focus {
            outline: none;
            background: rgba(255, 255, 255, 0.2);
        }

        .footer-section.newsletter button {
            padding: 10px 20px;
            background: linear-gradient(45deg, #ffeb3b, #ffd700);
            color: #1a1a1a;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .footer-section.newsletter button:hover {
            background: linear-gradient(45deg, #ffd700, #ffca28);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(255, 235, 59, 0.5);
        }

        .footer-bottom {
            border-top: 1px solid rgba(255, 235, 59, 0.3);
            padding-top: 20px;
        }

        .footer-bottom .copyright {
            margin: 0;
        }

        .footer-bottom .company {
            color: #ffeb3b;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media (max-width: 1024px) {
            header { padding: 15px 30px; }
            .logo { font-size: 36px; }
            .logo span { font-size: 22px; }
            nav ul { gap: 15px; }
            nav ul li a { font-size: 20px; }
            .login-link { font-size: 20px; padding: 12px 25px; margin-right: 15px; }
            .login-link i { font-size: 22px; }
            .hero-content h1 { font-size: 40px; }
            .hero-content p { font-size: 20px; }
            .hero-buttons a { font-size: 18px; padding: 14px 30px; }
            .movie-card { width: 250px; }
            .movie-card img { height: 350px; }
            .modal-content { max-width: 500px; padding: 40px; }
            .footer-section h3 { font-size: 22px; }
            .footer-section p, .footer-section a { font-size: 14px; }
        }

        @media (max-width: 768px) {
            body { font-size: 16px; }
            header { padding: 10px 20px; flex-direction: column; gap: 10px; }
            .logo { font-size: 32px; }
            .logo span { font-size: 20px; }
            nav ul { gap: 10px; flex-wrap: wrap; justify-content: center; }
            nav ul li a { font-size: 18px; }
            .login-link { font-size: 18px; padding: 10px 20px; margin-right: 0; }
            .login-link i { font-size: 20px; }
            .hero { height: 500px; }
            .hero-content h1 { font-size: 32px; }
            .hero-content p { font-size: 18px; }
            .movie-card { width: 200px; }
            .movie-card img { height: 300px; }
            .movie-info h3 { font-size: 20px; }
            .movie-info p { font-size: 14px; }
            .movie-card .action-btn { font-size: 16px; }
            .modal-content { max-width: 400px; padding: 30px; }
            .modal-content h2 { font-size: 32px; }
            .modal-content label { font-size: 20px; }
            .modal-content input { font-size: 18px; }
            .modal-content .submit-btn { font-size: 18px; }
            .tab-btn { font-size: 18px; }
            footer { font-size: 16px; padding: 30px 15px; }
            .footer-section { text-align: center; }
            .footer-section.newsletter form { flex-direction: column; }
            .footer-section.newsletter input, .footer-section.newsletter button { width: 100%; }
        }

        @media (max-width: 480px) {
            .logo { font-size: 28px; }
            .logo span { font-size: 18px; }
            nav ul li a { font-size: 16px; }
            .login-link { font-size: 16px; padding: 8px 15px; }
            .login-link i { font-size: 18px; }
            .hero-content h1 { font-size: 28px; }
            .hero-content p { font-size: 16px; }
            .movie-card { width: 180px; }
            .movie-card img { height: 250px; }
            .modal-content { max-width: 300px; padding: 20px; }
            .modal-content h2 { font-size: 28px; }
            .modal-content label { font-size: 18px; }
            .modal-content input { font-size: 16px; }
            .modal-content .submit-btn { font-size: 16px; }
            .tab-btn { font-size: 16px; }
            .footer-section h3 { font-size: 20px; }
        }
    </style>
</head>
<body>
<header>
    <div class="logo">
        Movie<span>MAGNET</span>
    </div>
    <nav>
        <ul>
            <li><a href="${pageContext.request.contextPath}/index.jsp" class="active">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/publicMovieList">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/contact-us.jsp">Contact us</a></li>
            <li><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></li>
        </ul>
    </nav>
    <c:if test="${empty sessionScope.username}">
        <a href="#" class="login-link" id="loginLink"><i class="fa fa-fw fa-user"></i> Login</a>
    </c:if>
</header>

<div class="container">
    <section class="hero">
        <div class="hero-slideshow">
            <div class="hero-slide active" style="background-image: url('${pageContext.request.contextPath}/img/Card_1.jpg');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/img/Card_2.jpg');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/img/Card_3.jpg');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/img/Card_4.jpg');"></div>
            <div class="hero-slide" style="background-image: url('${pageContext.request.contextPath}/img/Card_5.jpg');"></div>
        </div>
        <div class="hero-content">
            <h1>Welcome to MovieMagnet</h1>
            <p>Discover the latest movies, book your tickets, and dive into cinematic adventures with ease!</p>
            <div class="hero-buttons">
                <a href="${pageContext.request.contextPath}/publicMovieList"><i class="fa-solid fa-ticket"></i> Book Now</a>
            </div>
        </div>
    </section>

    <div class="movie-list">
        <h2>Now Showing</h2>
        <div class="movie-carousel">
            <div class="movie-container">
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_1.jpg" alt="Movie 1">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 1</h3>
                        <p>Genre: Action</p>
                        <p>Duration: 120 mins</p>
                        <p>Release Date: 2025-05-01</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_2.jpg" alt="Movie 2">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 2</h3>
                        <p>Genre: Drama</p>
                        <p>Duration: 135 mins</p>
                        <p>Release Date: 2025-05-10</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_3.jpg" alt="Movie 3">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 3</h3>
                        <p>Genre: Sci-Fi</p>
                        <p>Duration: 150 mins</p>
                        <p>Release Date: 2025-05-15</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_1.jpg" alt="Movie 1">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 1</h3>
                        <p>Genre: Action</p>
                        <p>Duration: 120 mins</p>
                        <p>Release Date: 2025-05-01</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_2.jpg" alt="Movie 2">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 2</h3>
                        <p>Genre: Drama</p>
                        <p>Duration: 135 mins</p>
                        <p>Release Date: 2025-05-10</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
                <div class="movie-card">
                    <img src="${pageContext.request.contextPath}/img/Card_3.jpg" alt="Movie 3">
                    <div class="movie-info">
                        <h3>MOVIE TITLE 3</h3>
                        <p>Genre: Sci-Fi</p>
                        <p>Duration: 150 mins</p>
                        <p>Release Date: 2025-05-15</p>
                        <div class="release-year">2025</div>
                        <a href="${pageContext.request.contextPath}/publicMovieList" class="action-btn">Book Now</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div id="loginModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeLoginModal()">×</span>
        <h2>Login</h2>
        <div class="tabs">
            <button class="tab-btn active" onclick="showTab('customer')">Customer</button>
            <button class="tab-btn" onclick="showTab('admin')">Admin</button>
        </div>
        <div id="customer" class="tab-content active">
            <form id="customerLoginForm" action="${pageContext.request.contextPath}/CustomerLoginServlet" method="post">
                <div class="form-group">
                    <label for="customerUsername">Username</label>
                    <input type="text" id="customerUsername" name="username" placeholder="Enter username" required>
                </div>
                <div class="form-group">
                    <label for="customerPassword">Password</label>
                    <input type="password" id="customerPassword" name="password" placeholder="Enter password" required>
                </div>
                <button type="submit" class="submit-btn">Login</button>
            </form>
            <a href="${pageContext.request.contextPath}/Customer/customer-register.jsp" class="switch-link">Don't have an account? Register</a>
        </div>
        <div id="admin" class="tab-content">
            <form id="adminLoginForm" action="${pageContext.request.contextPath}/AdminLoginServlet" method="post">
                <div class="form-group">
                    <label for="adminUsername">Admin Username</label>
                    <input type="text" id="adminUsername" name="adminUsername" placeholder="Enter admin username" required>
                </div>
                <div class="form-group">
                    <label for="adminPassword">Admin Password</label>
                    <input type="password" id="adminPassword" name="adminPassword" placeholder="Enter admin password" required>
                </div>
                <button type="submit" class="submit-btn">Login</button>
            </form>
            <a href="${pageContext.request.contextPath}/Admin/admin-register.jsp" class="switch-link">Don't have an account? Register</a>
        </div>
    </div>
</div>

<footer>
    <div class="footer-content">
        <div class="footer-section about">
            <h3>About MovieMagnet</h3>
            <p>We bring the magic of cinema to your fingertips with seamless booking and the latest movies.</p>
        </div>
        <div class="footer-section links">
            <h3>Quick Links</h3>
            <p><a href="${pageContext.request.contextPath}/index.jsp">Home</a></p>
            <p><a href="${pageContext.request.contextPath}/publicMovieList">Movies</a></p>
            <p><a href="${pageContext.request.contextPath}/contact-us.jsp">Contact Us</a></p>
            <p><a href="${pageContext.request.contextPath}/about-us.jsp">About Us</a></p>
        </div>
        <div class="footer-section social">
            <h3>Follow Us</h3>
            <div class="social-icons">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-youtube"></i></a>
            </div>
        </div>
        <div class="footer-section newsletter">
            <h3>Newsletter</h3>
            <p>Stay updated with the latest movies and offers!</p>
            <form action="#" method="post">
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit">Subscribe</button>
            </form>
        </div>
    </div>
    <div class="footer-bottom">
        <p class="copyright">© <span class="company">Nexora</span> 2025. All rights reserved.</p>
    </div>
</footer>

<script>
    document.addEventListener('DOMContentLoaded', () => {
        const loginLink = document.getElementById('loginLink');
        const modal = document.getElementById('loginModal');

        loginLink.addEventListener('click', (e) => {
            e.preventDefault();
            modal.style.display = 'block';
        });

        window.closeLoginModal = function() {
            modal.style.display = 'none';
        };

        window.addEventListener('click', (e) => {
            if (e.target == modal) {
                modal.style.display = 'none';
            }
        });

        window.showTab = function(tabName) {
            const tabs = document.querySelectorAll('.tab-content');
            const tabButtons = document.querySelectorAll('.tab-btn');
            tabs.forEach(tab => {
                tab.classList.remove('active');
                if (tab.id === tabName) {
                    tab.classList.add('active');
                }
            });
            tabButtons.forEach(btn => {
                btn.classList.remove('active');
                if (btn.getAttribute('onclick').includes(tabName)) {
                    btn.classList.add('active');
                }
            });
        };

        const slides = document.querySelectorAll('.hero-slide');
        let currentSlide = 0;

        function showSlide(index) {
            slides.forEach((slide, i) => {
                slide.classList.remove('active');
                if (i === index) {
                    slide.classList.add('active');
                }
            });
        }

        function nextSlide() {
            currentSlide = (currentSlide + 1) % slides.length;
            showSlide(currentSlide);
        }

        setInterval(nextSlide, 5000);
    });
</script>