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
## Database schema
![schema](https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/database-schema.png)
## Site map for student
![student-map](https://github.com/training-portal/training_portal/blob/master/src/main/webapp/resources/training-portal-student.png)
