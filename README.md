# Training portal
#### Learning management system
#### [Heroku link](http://training--portal.herokuapp.com)
## Description
- Learning Management System is a system that is used to develop, manage and share online learning materials with common access.  
- Users are divided into two roles: teachers and students.
- Teacher has opportunity to unite students into groups and create quizzes with various types of questions and preview them as student. Then he publishes them to students and groups. As students pass quizzes, teacher can watch student's results. Also teacher has opportunity to forcibly close quizzes with empty result to students who do not keep within terms of passage.
- Student has opportunity to be in a group and pass quizzes from various teachers published to him. After passing, student can pass quiz again, but the overall score will be lower. When all students in the group have finally completed quiz, they can see answers to it. Also, student can watch his results and compare them with results of group mates.
- Quiz consists of different types of tasks:
1. Questions with one correct answer.
2. Questions with several correct answers.
3. Questions for establishing accordance.
4. Questions for establishing sequence.
5. Questions with numerical answer.
## Benefits
1. System has an user friendly interface and responsive design.
2. User is fully aware of the information about educational flow, which is competently structured according to sections.
3. Teacher has a convenient editor for creating groups, quizzes and questions to them with a built-in validation check.
4. Student evaluation is automatic. Partially correct answers and attempt of passage influence on total score. When whole group has finished quiz, students get access to correct answers, which allows them to learn from their mistakes and improve learning effectiveness.
## Technologies used
- Java 8 - backend programming language
- Apache Tomcat 8.5.24 - application server
- Apache Maven 3.5.3 - build tool
- Spring 4.3 Core, JDBC, MVC, Security - server libraries
- Log4j 1.2.17 - logging events
- JUnit 4.12, Spring 4.3 Test, H2 database 1.4.196 - testing
- BoneCP 0.8.0 - connection pool
- MySQL 5.1.39 - data storage
- HTML 5, CSS 3, Bootstrap 4, JSP 2.2, JSTL 1.2 - frontend
- JavaScript 5.1 - frontend programming language
- JQuery 3.3.1 - JavaScript library
- Git 2.17.0 - versions control
## Folder structure
<pre>
<a href="https://github.com/training-portal/training_portal">training_portal/</a>
    <a href="https://github.com/training-portal/training_portal#training-portal">README.md</a>
    <a href="https://github.com/training-portal/training_portal/blob/master/pom.xml">pom.xml</a>
    <a href="https://github.com/training-portal/training_portal/blob/master/Procfile">Procfile</a>
    <a href="https://github.com/training-portal/training_portal/blob/master/.gitignore">.gitignore</a>
    <a href="https://github.com/training-portal/training_portal/tree/master/src">src/</a>
        <a href="https://github.com/training-portal/training_portal/tree/master/src/main">main/</a>
            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java">java/</a>
                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com">com/</a>
                    <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company">company/</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal">training_portal/</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/config">config/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/config/AppConfig.java">AppConfig.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/config/WebAppInitializer.java">WebAppInitializer.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/config/WebConfig.java">WebConfig.java</a>
                                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/config/security">security/</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/config/security/WebAppSecurityInitializer.java">WebAppSecurityInitializer.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/config/security/WebSecurityConfig.java">WebSecurityConfig.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/controller">controller/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/GlobalExceptionHandler.java">GlobalExceptionHandler.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/QuizPassingController.java">QuizPassingController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/SessionAttributes.java">SessionAttributes.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/StudentController.java">StudentController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/TeacherController.java">TeacherController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/TeacherGroupController.java">TeacherGroupController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/TeacherQuizController.java">TeacherQuizController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/TeacherResultsController.java">TeacherResultsController.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/controller/UserController.java">UserController.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/dao">dao/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/AnswerAccordanceDao.java">AnswerAccordanceDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/AnswerNumberDao.java">AnswerNumberDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/AnswerSequenceDao.java">AnswerSequenceDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/AnswerSimpleDao.java">AnswerSimpleDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/GroupDao.java">GroupDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/QuestionDao.java">QuestionDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/QuizDao.java">QuizDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/UserDao.java">UserDao.java</a>
                                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/dao/impl">impl/</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/AnswerAccordanceDaoJdbc.java">AnswerAccordanceDaoJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/AnswerNumberDaoJdbc.java">AnswerNumberJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/AnswerSequenceDaoJdbc.java">AnswerSequenceJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/AnswerSimpleDaoJdbc.java">AnswerSimpleJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/GroupDaoJdbc.java">GroupDaoJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/QuestionDaoJdbc.java">QuestionDaoJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/QuizDaoJdbc.java">QuizDaoJdbc.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/dao/impl/UserDaoJdbc.java">UserDaoJdbc.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/jstl">jstl/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/jstl/FormatDuration.java">FormatDuration.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/jstl/FormatLocalDate.java">FormatLocalDate.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/jstl/FormatLocalDateTime.java">FaormatLocalDateTime.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/jstl/Util.java">Util.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/model">model/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/AnswerAccordance.java">AnswerAccordance.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/AnswerNumber.java">AnswerNumber.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/AnswerSequence.java">AnswerSequence.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/AnswerSimple.java">AnswerSimple.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/Group.java">Group.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/OpenedQuiz.java">OpenedQuiz.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/PassedQuiz.java">PassedQuiz.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/Question.java">Question.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/Quiz.java">Quiz.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/SecurityUser.java">SecurityUser.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/User.java">User.java</a>
                                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/model/enums">enums/</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/enums/QuestionType.java">QuestionType.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/enums/StudentQuizStatus.java">StudentQuizStatus.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/enums/TeacherQuizStatus.java">TeacherQuizStatus.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/model/enums/UserRole.java">UserRole.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/service">service/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/service/CustomAuthenticationSuccessHandler.java">CustomAuthenticationSuccessHandler.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/service/CustomUserDetailsService.java">CustomUserDetailsService.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/util">util/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/util/Utils.java">Utils.java</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/java/com/company/training_portal/validator">validator/</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/validator/GroupValidator.java">GroupValidator.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/validator/QuizValidator.java">QuizValidator.java</a>
                                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/java/com/company/training_portal/validator/UserValidator.java">UserValidator.java</a>
            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/resources">resources/</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/config_schema.sql">config_schema.sql</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/schema.sql">schema.sql</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/schema_postgress.sql">schema_postgres.sql</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/test-data.sql">test-data.sql</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/db.properties">db.properties</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/log4j.properties">log4j.properties</a>
                <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/validationMessages.properties">validationMessages.properties</a>
                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/resources/sql_queries">sql_queries/</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/answer_accordance_dao.sql">answer_accordance_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/answer_number_dao.sql">answer_number_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/answer_sequence_dao.sql">answer_sequence_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/answer_simple_dao.sql">answer_simple_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/group_dao.sql">group_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/question_dao.sql">question_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/quiz_dao.sql">quiz_dao.sql</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/resources/sql_queries/user_dao.sql">user_dao.sql</a>
            <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp">webapp/</a>
                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/resources">resources/</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/main.css">main.css</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/icon-danger.png">icon-danger.png</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/icon-primary.png">icon-primary.png</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/icon-success.png">icon-success.png</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/training-portal-favicon.png">training-portal-favicon.png</a>
                <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF">WEB-INF/</a>
                    <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/web.xml">web.xml</a>
                    <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/custom_tags">custom_tags/</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/custom_tags/formatDuration.tld">formatDuration.tld</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/custom_tags/formatLocalDate.tld">formatLocalDate.tld</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/custom_tags/formatLocalDateTime.tld">formatLocalDateTime.tld</a>
                    <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view">view/</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/edit-profile.jsp">edit-profile.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/help.jsp">help.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/login.jsp">login.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/registration.jsp">registration.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/error">error/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/error/access-denied.jsp">access-denied.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/error/exception.jsp">exception.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/error/no-data-found.jsp">no-data-found.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/fragment">fragment/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/fragment/head.jsp">head.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/fragment/navbar.jsp">navbar.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/quiz_passing">quiz_passing/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/quiz_passing/congratulations.jsp">congratulations.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/quiz_passing/continue.jsp">continue.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/quiz_passing/just-passed.jsp">just-passed.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/quiz_passing/question.jsp">question.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/quiz_passing/time-up.jsp">time-up.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/student_general">student_general/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/compare-quiz-results.jsp">compare-quiz-results.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/group.jsp">group.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/quizzes.jsp">quizzes.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/results.jsp">results.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/student.jsp">student.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/student-info.jsp">student-info.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/teacher-info.jsp">teacher-info.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_general/teachers.jsp">teachers.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/student_quiz">student_quiz/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/answers.jsp">answers.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/closed.jsp">closed.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/opened.jsp">opened.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/passed.jsp">passed.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/repass.jsp">repass.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/student_quiz/start.jsp">start.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/teacher_general">teacher_general/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_general/groups.jsp">groups.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_general/quizzes.jsp">quizzes.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_general/results.jsp">results.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_general/students.jsp">students.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_general/teacher.jsp">teacher.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/teacher_group">teacher_group/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/foreign-group-info.jsp">foreign-group-info.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/group-add-students.jsp">group-add-students.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/group-create.jsp">group-create.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/group-deleted.jsp">group-deleted.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/group-edit.jsp">group-edit.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_group/own-group-info.jsp">own-group-info.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/teacher_quiz">teacher_quiz/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/published-quiz.jsp">published-quiz.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/questions.jsp">questions.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/quiz-create.jsp">quiz-create.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/quiz-edit.jsp">quiz-edit.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/quiz-publication.jsp">quiz-publication.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_quiz/unpublished-quiz.jsp">unpublished-quiz.jsp</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/main/webapp/WEB-INF/view/teacher_results">teacher_results/</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_results/group-quiz-result.jsp">group-quiz-result.jsp</a>
                            <a href="https://github.com/training-portal/training_portal/blob/master/src/main/webapp/WEB-INF/view/teacher_results/group-result.jsp">group-result.jsp</a>
                            <a href="">student-result.jsp</a>
        <a href="https://github.com/training-portal/training_portal/tree/master/src/test">test/</a>
            <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java">java/</a>
                <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java/com">com/</a>
                    <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java/com/company">company/</a>
                        <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java/com/company/training_portal">training_portal/</a>
                            <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java/com/company/training_portal/dao">dao/</a>
                                <a href="https://github.com/training-portal/training_portal/tree/master/src/test/java/com/company/training_portal/dao/impl">impl/</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/AnswerAccordanceDaoJdbcTest.java">AnswerAccordanceDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/AnswerNumberDaoJdbcTest.java">AnswerNumberDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/AnswerSequenceDaoJdbcTest.java">AnswerSequenceDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/AnswerSimpleDaoJdbcTest.java">AnswerSimpleDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/GroupDaoJdbcTest.java">GroupDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/QuestionDaoJdbcTest.java">QuestionDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/QuizDaoJdbcTest.java">QuizDaoJdbcTest.java</a>
                                    <a href="https://github.com/training-portal/training_portal/blob/master/src/test/java/com/company/training_portal/dao/impl/UserDaoJdbcTest.java">UserDaoJdbcTest.java</a>
    target/
</pre>
