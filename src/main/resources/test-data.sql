-- Table: users (teachers)
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Andrew', 'Bronson', 'andrew@example.com', '1970-05-10', '073-000-00-11', null, 'Andrew', '123', 'TEACHER');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Angel', 'Peterson', 'angel@example.com', '1980-06-15', '073-003-02-01', null, 'Angel', '123', 'TEACHER');

-- Table: groups
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('IS-4', 'Program engineering', '2018-03-02', 1);
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('AM-4', 'Applied Mathematics', '2017-03-02', 2);

-- Table: users (students)
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (1, 'Anton', 'Yakovenko', 'anton@example.com', '1996-01-28', '095-123-45-67', null, 'Anton', '123', 'STUDENT');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (1, 'Artem', 'Yakovenko', 'artem@example.com', '1996-01-28', '095-98-76-54', null, 'Artem', '123', 'STUDENT');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (2, 'Mike', 'Jameson', 'mike@example.com', '1997-02-16', '098-024-68-10', null, 'Mike', '123', 'STUDENT');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (2, 'Sara', 'Stivens', 'sara@example.com', '1998-03-01', '098-135-79-11', null, 'Sara', '123', 'STUDENT');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (null, 'Jason', 'Statham', 'jason@example.com', '1995-04-10', '073-000-11-11', null, 'Jason', '123', 'STUDENT');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'William', 'Mathew', 'william@example.com', '1995-04-10', '073-000-11-22', null, 'William', '123', 'STUDENT');

-- Table: quizzes
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Procedural', 'Try your procedural skills', 'Hope you had procedural fun :)', '2018-03-01', '00:20:00', 1, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Exceptions', 'Try your exceptions skills', 'Hope you had fun with exceptions :)', '2018-03-02', '00:10:00', 1, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Collections', 'Try your collections skills', 'Hope you had fun with collections :)', '2018-02-01', '00:15:00', 2, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Multithreading', 'Try your multithreading skills', 'Hope you had multithreading fun :)', '2018-02-02', '00:05:00', 2, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('IO', 'Try your IO skills', 'Hope you had IO fun :)', '2018-03-11', '00:15:00', 1, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Generics', 'Try your generics skills', 'Hope you had generic fun :)', '2018-03-11', '00:12:30', 2, 'PUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Pascal basics', 'Try your pascal skills', 'Hope you had pascal fun :)', '2018-02-02', '00:05:00', 2, 'UNPUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Pascal advanced', 'Try your senior pascal skills', 'Hope you had pascal fun :)', '2018-03-11', '00:05:00', 2, 'UNPUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('HTML basics', 'Try your HTML skills', 'Hope you had HTML fun :)', '2018-03-11', '00:10:00', 1, 'UNPUBLISHED');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('HTML forms', 'Try your HTML skills with forms', 'Hope you had HTML fun :)', '2018-03-11', '00:09:00', 1, 'UNPUBLISHED');

-- Table: user_quiz_junctions
/*1*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (7, 1, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:02', '2018-03-05 00:00:04', 1, 'PASSED');
/*2*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (7, 2, 30, '2018-03-05 00:00:00', '2018-03-05 00:00:03', '2018-03-05 00:00:04', 1, 'PASSED');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 25, START_DATE = '2018-03-05 00:00:07', FINISH_DATE = '2018-03-05 00:00:10', ATTEMPT = 1, STUDENT_QUIZ_STATUS = 'FINISHED'
WHERE USER_QUIZ_JUNCTION_ID = 2;
/*3*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 3, 3, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:00:04', 1, 'FINISHED');
/*4*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, start_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 4, 40, '2018-03-05 00:00:00', '2018-03-05 00:00:02', '2018-03-05 00:00:04', 1, 'PASSED');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 40, START_DATE = '2018-03-05 00:00:06', FINISH_DATE = '2018-03-05 00:00:10', ATTEMPT = 1, STUDENT_QUIZ_STATUS = 'PASSED'
WHERE USER_QUIZ_JUNCTION_ID = 4;
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 3, START_DATE = '2018-03-05 00:00:12', FINISH_DATE = '2018-03-05 00:00:15', ATTEMPT = 2, STUDENT_QUIZ_STATUS = 'FINISHED'
WHERE USER_QUIZ_JUNCTION_ID = 4;
/*5*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 2, 5, '2018-03-05 00:00:00', '2018-03-05 00:00:03', '2018-03-05 00:00:04', 1, 'FINISHED');
/*6*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (3, 1, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*7*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 1, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*8*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (5, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*9*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (6, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*10*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 2, 5, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:03:04', 1, 'FINISHED');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 19, START_DATE = '2018-03-05 00:00:09', FINISH_DATE = '2018-03-05 00:00:10', ATTEMPT = 1, STUDENT_QUIZ_STATUS = 'PASSED'
WHERE USER_QUIZ_JUNCTION_ID = 6;
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 10, START_DATE = '2018-03-05 00:00:12', FINISH_DATE = '2018-03-05 00:00:15', ATTEMPT = 1, STUDENT_QUIZ_STATUS = 'FINISHED'
WHERE USER_QUIZ_JUNCTION_ID = 6;
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 10, START_DATE = '2018-03-05 00:00:08', FINISH_DATE = '2018-03-05 00:04:10', ATTEMPT = 1, STUDENT_QUIZ_STATUS = 'PASSED'
WHERE USER_QUIZ_JUNCTION_ID = 7;
/*11*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 3, 3, '2018-03-05 00:00:00', '2018-03-11 00:00:00', '2018-03-11 00:05:00', 1, 'FINISHED');
/*12*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 4, 3, '2018-03-05 00:08:00', '2018-03-11 00:10:00', '2018-03-11 00:16:04', 2, 'PASSED');
/*13*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 5, null, '2018-03-05 00:24:00', null, null, 0, 'OPENED');
/*14*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (4, 6, null, '2018-03-05 00:31:30', null, null, 0, 'OPENED');

-- Table: questions
/*1*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.1', 'Question 1.1 body?', 'Question 1.1 explanation', 'ONE_ANSWER', 1);
/*2*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.2', 'Question 1.2 body?', 'Question 1.2 explanation', 'FEW_ANSWERS', 2);
/*3*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.3', 'Question 1.3 body?', 'Question 1.3 explanation', 'ACCORDANCE', 3);
/*4*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.4', 'Question 1.4 body?', 'Question 1.4 explanation', 'SEQUENCE', 3);
/*5*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.5', 'Question 1.5 body?', 'Question 1.5 explanation', 'NUMBER', 5);
/*6*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.6', 'Question 1.6 body?', 'Question 1.6 explanation', 'ONE_ANSWER', 1);
/*7*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.7', 'Question 1.7 body?', 'Question 1.7 explanation', 'FEW_ANSWERS', 2);
/*8*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.8', 'Question 1.8 body?', 'Question 1.8 explanation', 'ACCORDANCE', 4);
/*9*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.9', 'Question 1.9 body?', 'Question 1.9 explanation', 'SEQUENCE', 4);
/*10*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.10', 'Question 1.10 body?', 'Question 1.10 explanation', 'NUMBER', 3);
/*11*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.11', 'Question 1.11 body?', 'Question 1.11 explanation', 'ONE_ANSWER', 1);
/*12*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.12', 'Question 1.12 body?', 'Question 1.12 explanation', 'ONE_ANSWER', 1);

/*13*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.1', 'Question 2.1 body?', 'Question 2.1 explanation', 'ONE_ANSWER', 1);
/*14*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.2', 'Question 2.2 body?', 'Question 2.2 explanation', 'FEW_ANSWERS', 2);
/*15*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.3', 'Question 2.3 body?', 'Question 2.3 explanation', 'NUMBER', 5);

/*16*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (3, 'Question #3.1', 'Question 3.1 body?', 'Question 3.1 explanation', 'ONE_ANSWER', 1);
/*17*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (3, 'Question #3.2', 'Question 3.2 body?', 'Question 3.2 explanation', 'FEW_ANSWERS', 2);

/*18*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (4, 'Question #4.1', 'Question 4.1 body?', 'Question 4.1 explanation', 'NUMBER', 4);

/*19*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (5, 'Question #5.1', 'Question 5.1 body?', 'Question 5.1 explanation', 'ONE_ANSWER', 1);
/*20*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (5, 'Question #5.2', 'Question 5.2 body?', 'Question 5.2 explanation', 'SEQUENCE', 4);

/*21*/INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (6, 'Question #6.1', 'Question 6.1 body?', 'Question 6.1 explanation', 'NUMBER', 3);

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

-- Table: answers_accordance
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2,
left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (3, 'SQL', 'database', 'Java', 'backend', 'HTML', 'frontend', 'Pascal', 'Dead');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2,
left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (8, '(a == 1)', 'expression', 'a = b + 1;', 'statement', '{a = 0; b = a + 1;}', 'block', '[a-zA-Z]+', 'regExp');


-- Table: answers_sequence
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (4, 'First answer', 'Second answer', 'Third answer', 'Fourth answer');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (9, '1-st item', '2-nd item', '3-rd item', '4-th item');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (20, 'First answer', 'Second answer', 'Third answer', 'Fourth answer');

-- Table: answers_number
INSERT INTO answers_number (question_id, correct) VALUES (5, 5);
INSERT INTO answers_number (question_id, correct) VALUES (10, 3);
INSERT INTO answers_number (question_id, correct) VALUES (18, 1);
INSERT INTO answers_number (question_id, correct) VALUES (21, 1);