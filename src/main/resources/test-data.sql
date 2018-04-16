-- Clear test data
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE ANSWERS_ACCORDANCE;
TRUNCATE TABLE ANSWERS_NUMBER;
TRUNCATE TABLE ANSWERS_SEQUENCE;
TRUNCATE TABLE ANSWERS_SIMPLE;
TRUNCATE TABLE GROUPS;
TRUNCATE TABLE QUESTIONS;
TRUNCATE TABLE QUIZZES;
TRUNCATE TABLE USERS;
TRUNCATE TABLE USER_QUIZ_JUNCTIONS;
SET FOREIGN_KEY_CHECKS = 1;

-- Table: users (teachers)
/*1*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Andrew', 'Bronson', 'andrew@example.com', '1970-05-10', '(073)-000-00-11', null, 'Andrew', '123', 'TEACHER');
/*2*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Angel', 'Peterson', 'angel@example.com', '1980-06-15', '(073)-003-02-01', null, 'Angel', '123', 'TEACHER');

-- Table: groups
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('IS-4', 'Program engineering', '2018-03-02', 1);
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('AM-4', 'Applied Mathematics', '2017-03-02', 2);
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('Informatics', NULL, '2017-03-30', 1);

-- Table: users (students)
/*3*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (1, 'Anton', 'Yakovenko', 'anton@example.com', '1996-01-28', '(095)-123-45-67', null, 'Anton', '123', 'STUDENT');
/*4*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (1, 'Artem', 'Yakovenko', 'artem@example.com', '1996-01-28', '(095)-498-76-54', null, 'Artem', '123', 'STUDENT');
/*5*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (2, 'Mike', 'Jameson', 'mike@example.com', '1997-02-16', '(098)-024-68-10', null, 'Mike', '123', 'STUDENT');
/*6*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (2, 'Sarah', 'Stivens', 'sarah@example.com', '1998-03-01', '(098)-135-79-11', null, 'Sarah', '123', 'STUDENT');
/*7*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Jason', 'Statham', 'jason@example.com', '1995-04-10', '(073)-000-11-11', null, 'Jason', '123', 'STUDENT');
/*8*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'William', 'Mathew', 'william@example.com', '1995-04-10', '(073)-000-11-22', null, 'William', '123', 'STUDENT');
/*9*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (NULL, 'Jack', 'Campton', 'jack@example.com', NULL, '(095)-456-34-37', NULL, 'Jack', '123', 'STUDENT');
/*10*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (NULL, 'Lily', 'Collins', 'lily@example.com', NULL, '(095)-437-78-45', NULL, 'Lily', '123', 'STUDENT');
/*11*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (1, 'Thomas', 'Scott', 'thomas@example.com', NULL, '(095)-444-78-45', NULL, 'Thomas', '123', 'STUDENT');
/*12*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (1, 'Katy', 'Walter', 'katy@example.com', NULL, '(095)-437-44-45', NULL, 'Katy', '123', 'STUDENT');
/*13*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (1, 'Jane', 'Nikolas', 'jane@example.com', NULL, '(095)-437-78-44', NULL, 'Jane', '123', 'STUDENT');
/*14*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (1, 'Mary', 'Hendrix', 'mary@example.com', NULL, '(095)-437-44-44', NULL, 'Mary', '123', 'STUDENT');
/*15*/INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, PHOTO, LOGIN, PASSWORD, USER_ROLE)
VALUES (3, 'Jimmy', 'Jimmy', 'jimmy@example.com', NULL, '(095)-787-22-56', NULL, 'Jimmy', '123', 'STUDENT');

-- Table: quizzes
/*1*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Object Oriented Programming', 'There are questions to test your skills in object oriented programming in Java', NULL, '2018-03-01', '00:10:00', 1, 'PUBLISHED');
/*2*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Exceptions', 'Try your exceptions skills', 'Hope you had fun with exceptions :)', '2018-03-02', '00:10:00', 1, 'PUBLISHED');
/*3*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Collections', 'Try your collections skills', 'Hope you had fun with collections :)', '2018-02-01', '00:15:00', 2, 'PUBLISHED');
/*4*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Multithreading', 'Try your multithreading skills', 'Hope you had multithreading fun :)', '2018-02-02', '00:00:10', 2, 'PUBLISHED');
/*5*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Generics', 'Try your generics skills', 'Hope you had generic fun :)', '2018-03-11', '00:15:00', 1, 'PUBLISHED');
/*6*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Input output', 'Try your IO skills', 'Hope you had IO fun :)', '2018-03-11', '00:12:30', 2, 'PUBLISHED');
/*7*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Pascal basics', 'Try your pascal skills', 'Hope you had pascal fun but Pascal is dead :)', '2018-02-02', '00:05:00', 2, 'UNPUBLISHED');
/*8*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Pascal advanced', 'Try your senior pascal skills', 'Hope you had Pascal fun but Pascal is dead :)', '2018-03-11', '00:05:00', 2, 'UNPUBLISHED');
/*9*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('HTML basics', 'Try your HTML skills', NULL, '2018-03-11', '00:10:00', 1, 'UNPUBLISHED');
/*10*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('HTML forms', 'Try your HTML skills with forms', 'Hope you had HTML fun :)', '2018-03-11', '00:09:00', 1, 'UNPUBLISHED');
/*11*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Servlet API', NULL, NULL, '2018-03-27', NULL, 1, 'PUBLISHED');
/*12*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Java server pages', NULL, NULL, '2018-03-27', NULL, 1, 'PUBLISHED');
/*13*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('SQL', NULL, NULL, '2018-03-29', NULL, 1, 'UNPUBLISHED');
/*14*/INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Javascript basics', NULL, NULL, '2018-03-29', NULL, 1, 'UNPUBLISHED');

-- Table: user_quiz_junctions
/*1*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (7, 1, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:02', '2018-03-05 00:00:04', 1, 'PASSED');
/*2*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (7, 2, 6, '2018-03-05 00:00:00', '2018-04-04 15:32:03', '2018-04-04 15:37:04', 1, 'CLOSED');
/*3*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 3, 1, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:00:04', 2, 'CLOSED');
/*4*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, start_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 4, 2, '2018-03-05 00:00:00', '2018-04-04 15:32:02', '2018-04-04 15:36:02', 3, 'CLOSED');
/*5*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 2, 8, '2018-03-05 00:00:00', '2018-03-05 00:00:03', '2018-03-05 00:00:04', 2, 'PASSED');
/*6*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 1, 23, '2018-03-05 00:00:00', '2018-04-04 15:30:34', '2018-04-04 15:40:04', 2, 'CLOSED');
/*7*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 1, 10, '2018-03-08 00:13:00', '2018-04-04 15:35:40', '2018-04-04 15:41:32', 1, 'PASSED');
/*8*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (5, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*9*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (6, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*10*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 2, 5, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:03:04', 1, 'CLOSED');
/*11*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 3, 2, '2018-03-06 00:14:00', '2018-03-11 00:00:00', '2018-03-11 00:05:00', 2, 'CLOSED');
/*12*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 4, 3, '2018-03-05 00:08:00', '2018-03-11 00:10:00', '2018-03-11 00:16:04', 2, 'PASSED');
/*13*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 5, null, '2018-03-05 00:24:00', null, null, 0, 'OPENED');
/*14*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 6, null, '2018-03-05 00:31:30', null, null, 0, 'OPENED');
/*15*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 5, null, '2018-03-05 00:24:00', null, null, 0, 'OPENED');
/*16*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 6, null, '2018-03-05 00:31:30', null, null, 0, 'OPENED');
/*17*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (5, 5, 5, '2018-03-23 16:18:35', '2018-03-23 19:20:45', '2018-03-23 19:25:45', 1, 'PASSED');
/*18*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (6, 6, NULL, '2018-02-12 14:34:56', NULL, NULL, 0, 'OPENED');
/*19*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (6, 5, NULL, '2018-03-23 16:18:35', NULL, NULL, 0, 'OPENED');
/*20*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (5, 6, NULL, '2018-03-23 16:18:35', NULL, NULL, 0, 'OPENED');
/*21*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 1, NULL, '2018-03-05 00:00:00', NULL, NULL, 0, 'OPENED');
/*22*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 1, 25, '2018-03-05 00:00:00', '2018-03-27 10:20:00', '2018-03-27 10:27:00', 1, 'CLOSED');
/*23*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 1, 15, '2018-03-05 00:00:00', '2018-03-27 10:20:00', '2018-03-27 10:29:00', 2, 'CLOSED');
/*24*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 1, 21, '2018-03-05 00:00:00', '2018-03-27 10:23:00', '2018-03-27 10:30:00', 1, 'PASSED');
/*25*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 2, 6, '2018-03-05 00:00:00', '2018-03-27 10:25:00', '2018-03-27 10:31:30', 1, 'PASSED');
/*26*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 2, NULL, '2018-03-05 00:00:00', NULL, NULL, 0, 'OPENED');
/*27*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 2, 3, '2018-03-05 00:00:00', '2018-03-27 10:24:00', '2018-03-27 10:32:22', 2, 'CLOSED');
/*28*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 2, NULL, '2018-03-05 00:00:00', NULL, NULL, 0, 'OPENED');
/*29*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 3, 3, '2018-03-06 00:14:00', '2018-03-27 10:20:00', '2018-03-27 10:33:45', 1, 'CLOSED');
/*30*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 3, 2, '2018-03-06 00:14:00', '2018-03-27 10:25:00', '2018-03-27 10:34:00', 2, 'CLOSED');
/*31*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 3, 3, '2018-03-06 00:14:00', '2018-03-27 10:27:00', '2018-03-27 10:35:11', 1, 'CLOSED');
/*32*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 3, 2, '2018-03-06 00:14:00', '2018-03-27 10:28:00', '2018-03-27 10:35:55', 1, 'CLOSED');
/*33*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 4, NULL, '2018-03-05 00:08:00', NULL, NULL, 0, 'OPENED');
/*34*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 4, NULL, '2018-03-05 00:08:00', NULL, NULL, 0, 'OPENED');
/*35*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 4, 3, '2018-03-05 00:08:00', '2018-03-27 10:30:00', '2018-03-27 10:36:00', 2, 'CLOSED');
/*36*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 4, 4, '2018-03-05 00:08:00', '2018-03-27 10:33:00', '2018-03-27 10:37:00', 1, 'PASSED');
/*37*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 5, 5, '2018-03-05 00:24:00', '2018-03-27 10:30:00', '2018-03-27 10:38:10', 1, 'CLOSED');
/*38*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 5, 4, '2018-03-05 00:24:00', '2018-03-27 10:32:00', '2018-03-27 10:38:43', 2, 'CLOSED');
/*39*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 5, 5, '2018-03-05 00:24:00', '2018-03-27 10:30:00', '2018-03-27 10:39:00', 1, 'PASSED');
/*40*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 5, 3, '2018-03-05 00:24:00', '2018-03-27 10:34:00', '2018-03-27 10:39:25', 2, 'PASSED');
/*41*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (11, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*42*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (12, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*43*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (13, 6, 2, '2018-03-05 00:31:30', '2018-03-27 10:30:00', '2018-03-27 10:40:00', 1, 'PASSED');
/*44*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (14, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*45*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 11, 0, '2018-03-27 11:04:00', '2018-04-05 14:28:32', '2018-04-05 14:32:33', 1, 'CLOSED');
/*46*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 12, 2, '2018-03-27 11:05:00', '2018-03-27 11:06:00', '2018-03-27 11:07:00', 1, 'PASSED');
/*47*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 11, 5, '2018-03-27 11:06:00', '2018-03-27 11:06:45', '2018-03-27 11:07:30', 1, 'CLOSED');
/*48*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (7, 5, NULL, '2018-04-01 17:39:00', NULL, NULL, 0, 'OPENED');
/*49*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (15, 5, NULL, '2018-04-02 21:17:00', NULL, NULL, 0, 'OPENED');
/*50*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (15, 11, NULL, '2018-04-02 21:23:00', NULL, NULL, 0, 'OPENED');
/*51*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (5, 11, NULL, '2018-04-02 21:23:55', NULL, NULL, 0, 'OPENED');
/*52*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (8, 11, NULL, '2018-04-04 10:40:00', NULL, NULL, 0, 'OPENED');
/*53*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (8, 5, NULL, '2018-04-04 10:41:05', NULL, NULL, 0, 'OPENED');

-- Table: questions
/*1*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.1 bodyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy br br br br br br br br br br br br br br ?', 'Question 1.1 explanation', 'ONE_ANSWER', 1);
/*2*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.2 body?', 'Question 1.2 explanation', 'FEW_ANSWERS', 2);
/*3*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Set accordance between programming languages and their application area', 'Question 1.3 explanation', 'ACCORDANCE', 3);
/*4*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Arrange programming languages in order to their appearance', 'Pascal - 1970, C++ - 1983, Java - 1996, Angular JS - 2009', 'SEQUENCE', 3);
/*5*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.5 body?', 'Question 1.5 explanation', 'NUMBER', 5);
/*6*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.6 body?', 'Question 1.6 explanation', 'ONE_ANSWER', 1);
/*7*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.7 body?', 'Question 1.7 explanation', 'FEW_ANSWERS', 2);
/*8*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Set accordance between code fragments and their description', 'Question 1.8 explanation', 'ACCORDANCE', 4);
/*9*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Arrange classes and interfaces from parent to child', 'Question 1.9 explanation', 'SEQUENCE', 4);
/*10*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.10 body?', 'Question 1.10 explanation', 'NUMBER', 3);
/*11*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.11 body?', 'Question 1.11 explanation', 'ONE_ANSWER', 1);
/*12*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (1, 'Question 1.12 body?', 'Question 1.12 explanation', 'ONE_ANSWER', 1);

/*13*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (2, 'Question 2.1 body?', 'Question 2.1 explanation', 'ONE_ANSWER', 1);
/*14*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (2, 'Question 2.2 body?', 'Question 2.2 explanation', 'FEW_ANSWERS', 2);
/*15*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (2, 'Question 2.3 body?', 'Question 2.3 explanation', 'NUMBER', 5);

/*16*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (3, 'Question 3.1 body?', 'Question 3.1 explanation', 'ONE_ANSWER', 1);
/*17*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (3, 'Question 3.2 body?', 'Question 3.2 explanation', 'FEW_ANSWERS', 2);

/*18*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (4, 'Question 4.1 body?', 'Question 4.1 explanation', 'NUMBER', 4);

/*19*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (5, 'Question 5.1 body?', 'Question 5.1 explanation', 'ONE_ANSWER', 1);
/*20*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (5, 'Question 5.2 body?', 'Question 5.2 explanation', 'SEQUENCE', 4);

/*21*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (6, 'Question 6.1 body?', 'Question 6.1 explanation', 'NUMBER', 3);

/*22*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (7, 'Question 7.1 body?', 'Question 7.1 explanation', 'ONE_ANSWER', 1);

/*23*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (8, 'Question 8.1 body?', 'Question 8.1 explanation', 'FEW_ANSWERS', 3);

/*24*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (9, 'Question 9.1 body?', 'Question 9.1 explanation', 'NUMBER', 4);

/*25*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Which element DOESN''T belongs to HTML forms?', '''Name'' is input type element, NOT form', 'ONE_ANSWER', 1);
/*26*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Set accordance between HTML form elements and their description', NULL, 'ACCORDANCE', 4);
/*27*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Enter the year when Berners-Lee wrote HTML', 'End of 1990', 'NUMBER', 5);
/*28*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Which input restriction specifies a regular expression to check the input value against', 'It is ''pattern'' restriction', 'ONE_ANSWER', 3);
/*29*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Set correct sequence of tags in HTML document', '<html> -> <form action="handler.php"> -> <input type="checkbox"> -> </body>', 'SEQUENCE', 3);
/*30*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (10, 'Select ALL correct HTML form input types', '''style'' and ''value'' are NOT input types', 'FEW_ANSWERS', 3);

/*31*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (11, 'Enter the year when HTTP was invented', NULL, 'NUMBER', 5);

/*32*/INSERT INTO questions (quiz_id, body, explanation, question_type, score)
VALUES (12, 'Which mechanism add content statically in JSP file?', NULL, 'ONE_ANSWER', 2);

-- Table: answers_simple
INSERT INTO answers_simple (question_id, body, correct) VALUES (1, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (1, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (1, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (2, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (2, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (2, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (2, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (6, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (6, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (11, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (11, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (11, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (12, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (12, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (12, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (12, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (13, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (13, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (13, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (14, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (14, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (14, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (14, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (16, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (16, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (16, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (17, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (17, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (17, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (17, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (19, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (19, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (19, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (22, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (22, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (22, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (23, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (23, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (23, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (23, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (23, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (25, 'text', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (25, 'select', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (25, 'name', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (25, 'input', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (28, 'value', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (28, 'step', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (28, 'size', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (28, 'pattern', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'radio', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'submit', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'style', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'button', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'reset', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (30, 'value', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (32, 'include', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (32, 'jsp:include', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (32, 'c:import', false);

-- Table: answers_accordance
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2,
left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (3, 'SQL', 'database', 'Java', 'backend', 'HTML', 'frontend', 'Pascal', 'Dead');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2,
left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (8, '(a == 1)', 'expression', 'a = b + 1;', 'statement', '{a = 0; b = a + 1;}', 'block', '[a-zA-Z]+', 'regExp');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2,
left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (26, '<textarea>', 'Defines a multiline input control', '<select>', 'Defines a drop-down list',
'<option>', 'Defines an option in a drop-down list', '<input>', 'Defines an input control');

-- Table: answers_sequence
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (4, 'Pascal', 'C++', 'Java', 'Angular JS');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (9, 'Object', 'Collection', 'List', 'ArrayList');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (20, 'First answer', 'Second answer', 'Third answer', 'Fourth answer');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (29, '<html>', '<form action="handler.php">', '<input type="checkbox">', '</body>');

-- Table: answers_number
INSERT INTO answers_number (question_id, correct) VALUES (5, 5);
INSERT INTO answers_number (question_id, correct) VALUES (10, 3);
INSERT INTO answers_number (question_id, correct) VALUES (15, 3);
INSERT INTO answers_number (question_id, correct) VALUES (18, 1);
INSERT INTO answers_number (question_id, correct) VALUES (21, 1);
INSERT INTO answers_number (question_id, correct) VALUES (24, 1);
INSERT INTO answers_number (question_id, correct) VALUES (27, 1990);
INSERT INTO answers_number (question_id, correct) VALUES (31, 1992);