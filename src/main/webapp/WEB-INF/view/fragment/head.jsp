<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="shortcut icon" type="image/png"
      href="${pageContext.request.contextPath}/resources/training-portal-favicon.png"/>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<!-- Latest compiled and minified CSS -->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css">
<!-- jQuery library -->
<%--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>--%>
<script src="https://code.jquery.com/jquery-3.3.1.min.js"
        integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8="
        crossorigin="anonymous"></script>
<!-- Popper JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js"></script>
<!-- Latest compiled JavaScript -->
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css"
      href="${pageContext.request.contextPath}/resources/bootstrap/css/bootstrap.min.css">
<link rel="script" href="${pageContext.request.contextPath}/resources/bootstrap/js/bootstrap.min.js">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/resources/main.css">
<script>
    $(document).ready(function () {
        const currentPath = window.location.pathname;
        let locationPath;
        if (currentPath === "/student" || currentPath === "/teacher") {
            locationPath = currentPath;
        } else {
            const url = currentPath.split("/");
            locationPath = "/" + url[1] + "/" + url[2];
        }
        $('ul li a[href="'+ locationPath + '"]').parent().addClass('active');
    });
</script>
<script>
    $(document).ready(function () {
        $("#logout").click(function (event) {
            event.preventDefault();
            const quizStarted = Boolean("${sessionScope.result}");
            if (quizStarted) {
                if (confirm("Are you sure you want to log out? You do not finish current quiz")) {
                    window.location = $(this).attr("href");
                }
            } else {
                window.location = "/logout";
            }
        });
    });
</script>