<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Car Rental System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css">
    <script>
        function validateForm() {
            const password = document.getElementById("password").value;
            const confirm = document.getElementById("confirmPassword").value;
            if (password !== confirm) {
                alert("Passwords do not match!");
                return false;
            }
            return true;
        }
    </script>
</head>
<body>
    <div class="container mt-5">
        <%
            String error = request.getParameter("error");
            if ("username_taken".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ Username is already taken. Please choose another.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            } else if ("registration_failed".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ❌ Registration failed. Please try again later.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
            }
        %>
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h3 class="card-title text-center mb-4">Register</h3>
                        <form action="RegisterServlet" method="post" onsubmit="return validateForm();">
                            <div class="mb-3">
                                <label for="username" class="form-label">Username</label>
                                <input type="text" name="username" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" name="email" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="phone" class="form-label">Phone Number</label>
                                <input type="text" name="phone" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" name="password" id="password" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">Confirm Password</label>
                                <input type="password" id="confirmPassword" class="form-control" required>
                            </div>

                            <input type="hidden" name="role" value="customer">

                            <button type="submit" class="btn btn-success w-100">Register</button>
                            <p class="mt-3 text-center">Already have an account? <a href="login.jsp">Login</a></p>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
