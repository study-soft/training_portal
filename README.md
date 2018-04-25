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
5. Questions with a numerical answer.
## Benefits
1. System has an user friendly interface and responsive design.
2. User is fully aware of the information about educational flow, which is competently structured according to sections.
3. Teacher has a convenient editor for creating groups, quizzes and questions to them with a built-in validation check.
4. Student evaluation is automatic. Partially correct answers and attempt of passage influence on total score. When whole group has finished quiz, students get access to correct answers, which allows them to learn from their mistakes and improve learning effectiveness.
## Technologies used
- Java 9 - backend programming language
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
training_portal/
    README.md
    pom.xml
    Procfile
    .gitignore
    src/
        main/
            java/
                com/
                    company/
                        training_portal/
                            config/
                                AppConfig.java
                                WebAppInitializer.java
                                WebConfig.java
                                security/
                                    WebAppSecurityInitializer.java
                                    WebSecurityConfig.java
                            controller/
                                GlobalExceptionHandler.java
                                QuizPassingController.java
                                SessionAttributes.java
                                StudentController.java
                                TeacherController.java
                                TeacherGroupController.java
                                TeacherQuizController.java
                                TeacherResultsController.java
                                UserController.java
                            dao/
                                AnswerAccordanceDao.java
                                AnswerNumber.java
                                AnswerSequence.java
                                AnswerSimple.java
                                GroupDao.java
                                QuestionDao.java
                                QuizDao.java
                                UserDao.java
                                impl/
                                    AnswerAccordanceDaoJdbc.java
                                    AnswerNumberJdbc.java
                                    AnswerSequenceJdbc.java
                                    AnswerSimpleJdbc.java
                                    GroupDaoJdbc.java
                                    QuestionDaoJdbc.java
                                    QuizDaoJdbc.java
                                    UserDaoJdbc.java
                            jstl/
                                FormatDuration.java
                                FormatLocalDate.java
                                FaormatLocalDateTime.java
                                Util.java
                            model/
                                AnswerAccordance.java
                                AnswerNumber.java
                                AnswerSequence.java
                                AnswerSimple.java
                                Group.java
                                OpenedQuiz.java
                                PassedQuiz.java
                                Question.java
                                Quiz.java
                                SecurityUser.java
                                User.java
                                enums/
                                    QuestionType.java
                                    StudentQuizStatus.java
                                    TeacherQuizStatus.java
                                    UserRole.java
                            service/
                                CustomAuthenticationSuccessHandler.java
                                CustomUserDetailsService.java
                            util/
                                Utils.java
                            validator/
                                GroupValidator.java
                                QuizValidator.java
                                UserValidator.java
            resources/
                default_schema.sql
                schema.sql
                schema_postgres.sql
                test-data.sql
                db.properties
                log4j.properties
                validationMessages.properties
                sql_queries/
                    answer_accordance_dao.sql
                    answer_sequence_dao.sql
                    answer_simple_dao.sql
                    answer_number_dao.sql
                    group_dao.sql
                    question_dao.sql
                    quiz_dao.sql
                    user_dao.sql
            webapp/
                resources/
                    main.css
                    icon-danger.png
                    icon-primary.png
                    icon-success.png
                    training-portal-favicon.png
                WEB-INF/
                    web.xml
                    view/
                        edit-profile.jsp
                        login.jsp
                        registration.jsp
                        error/
                            access-denied.jsp
                            exception.jsp
                            no-data-found.jsp
                        fragment/
                            head.jsp
                            navbar.jsp
                        quiz_passing/
                            congratulations.jsp
                            continue.jsp
                            just-passed.jsp
                            question.jsp
                            time-up.jsp
                        student_general/
                            compare-quiz-results.jsp
                            group.jsp
                            quizzes.jsp
                            results.jsp
                            student.jsp
                            student-info.jsp
                            teacher-info.jsp
                            teacher.jsp
                        student_quiz/
                            answers.jsp
                            closed.jsp
                            opened.jsp
                            passed.jsp
                            repass.jsp
                            start.jsp
                        teacher_general/
                            groups.jsp
                            quizzes.jsp
                            results.jsp
                            students.jsp
                            teacher.jsp
                        teacher_group/
                            foreign-group-info.jsp
                            group-add-students.jsp
                            group-create.jsp
                            group-deleted.jsp
                            group-edit.jsp
                            own-group-info.jsp
                        teacher_quiz/
                            published-quiz.jsp
                            questions.jsp
                            quiz-create.jsp
                            quiz-edit.jsp
                            quiz-publication.jsp
                            unpublished-quiz.jsp
                        teacher_results/
                            group-quiz-result.jsp
                            group-result.jsp
                            student-result.jsp
        test/
            java/
                com/
                    company/
                        training_portal/
                            dao/
                                impl/
                                    AnswerAccordanceDaoJdbcTest.java
                                    AnswerNumberDaoJdbcTest.java
                                    AnswerSequenceDaoJdbcTest.java
                                    AnswerSimpleDaoJdbcTest.java
                                    GroupDaoJdbcTest.java
                                    QuestionDaoJdbcTest.java
                                    QuizDaoJdbcTest.java
                                    UserDaoJdbcTest.java
    target/
</pre>
