<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Help</title>
    <c:import url="fragment/head.jsp"/>
    <script>
        $(document).ready(function () {
            $("#teacher").click(function (event) {
                event.preventDefault();
                $(this).next().toggleClass("hidden");
            });

            $("#student").click(function (event) {
                event.preventDefault();
                $(this).next().toggleClass("hidden");
            });
        });
    </script>
</head>
<body>
<div class="container">
    <h1 class="text-center">How to use Training Portal</h1>
    <a href="" id="teacher" class="text-center"><h2>If you are teacher</h2></a>
    <div class="hidden">
        <h4>About quiz</h4>
        <p>
            Teacher can create quizzes and add questions to them.
            There are five types of questions:
        </p>
        <ul>
            <li>questions with one correct answer</li>
            <li>questions with few correct answers</li>
            <li>questions for establishing accordance</li>
            <li>questions for establishing sequence</li>
            <li>questions with numerical answers</li>
        </ul>
        <p>
            After creating a quiz, teacher can view information about it
            and questions, edit them, add new ones and delete existing ones.
            Also, teacher can preview a quiz to understand how it will look like
            when students pass it. Then teacher can publish quiz. He has opportunity
            publish it to a single student, to whole group or to few students in group.
        </p>
        <p>
            After publishing a quiz, students start to pass it and teacher can no longer
            edit it because assessment will not be objective. There are three quiz statuses:
        </p>
        <ul>
            <li>opened</li>
            <li>passed</li>
            <li>closed</li>
        </ul>
        <p>
            At the start all students have quiz status "opened". When somebody passes quiz
            for the first time, he changes his quiz status to "passed". Student can repass
            quiz unlimited number of times but eventually need to close it. Then quiz status
            become "closed". When all students in group has quiz status "closed", they can
            see answers for this quiz.
        </p>
        <p>
            During all process of passing quiz by students, teacher can see their results.
            If some students pass quiz too long teacher can forcibly close quiz to them
            with current score. Also teacher can publish quiz again to those groups and
            students who have not previously published. If teacher unpublish quiz, it
            disappear from all students to whom was published. Teacher can edit or delete
            only unpublished quizzes.
        </p>
        <h4>About group</h4>
        <p>
            Teacher can create groups and add students to them. He can add only
            students without group because student can belong only to one group.
            When teacher publish at least one quiz to group he can observe
            process of passing quiz by this group. Also teacher can delete students
            from group or entire group.
        </p>
    </div>
    <a href="" id="student" class="text-center"><h2>If you are student</h2></a>
    <div class="hidden">
        <p>
            When student register, he does not belong to any group and have no quizzes
            to pass. Only teacher can add student to group or delete him from it and gave
            him quizzes. There are three quiz statuses:
        </p>
        <ul>
            <li>opened</li>
            <li>passed</li>
            <li>closed</li>
        </ul>
        <p>
            After student get quiz, it has status "opened". When student pass quiz for the
            first time, he changes quiz status to "passed". He can repass quiz unlimited
            number of times but after each passing, final score will be less on 10%. Eventually
            student need to close quiz and status becomes "closed". When all students in his
            group have status "closed" he can see answers for this quiz.
        </p>
        <p>
            Also student can explore teachers that publish quizzes to him. And student can
            compare his results with group mates.
        </p>
    </div>
    <div class="row justify-content-center">
        <button class="btn btn-primary" onclick="window.history.go(-1);">Back</button>
    </div>
</div>
<br>
</body>
</html>
