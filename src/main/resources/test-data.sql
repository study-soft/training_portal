-- Table: users (teachers)
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Andrew', 'Bronson', 'andrew@example.com', '1970-05-10', '073-000-00-11', null, 'Andrew', '123', 'teacher');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (null, 'Angel', 'Peterson', 'angel@example.com', '1980-06-15', '073-003-02-01', null, 'Angel', '123', 'teacher');


-- Table: groups
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('IS-4', 'Program engineering', '2018-03-02', 1);
INSERT INTO groups (name, description, creation_date, author_id) VALUES ('AM-4', 'Applied Mathematics', '2017-03-02', 2);

-- Table: users (students)
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (1, 'Anton', 'Yakovenko', 'anton@example.com', '1996-01-28', '095-123-45-67', null, 'Anton', '123', 'student');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (1, 'Artem', 'Yakovenko', 'artem@example.com', '1996-01-28', '095-98-76-54', null, 'Artem', '123', 'student');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
VALUES (2, 'Mike', 'Jameson', 'mike@example.com', '1997-02-16', '098-024-68-10', null, 'Mike', '123', 'student');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (2, 'Sara', 'Stivens', 'sara@example.com', '1998-03-01', '098-135-79-11', null, 'Sara', '123', 'student');
INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role) 
VALUES (null, 'Jason', 'Statham', 'jason@example.com', '1995-04-10', '073-000-11-11', null, 'Jason', '123', 'student');

-- Table: quizzes
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Procedural', 'Try your procedural skills', 'Hope you had procedural fun :)', '2018-03-01', '00:20:00', 1, 'published');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Exceptions', 'Try your exceptions skills', 'Hope you had fun with exceptions :)', '2018-03-02', '00:10:00', 1, 'published');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Collections', 'Try your collections skills', 'Hope you had fun with collections :)', '2018-02-01', '00:15:00', 2, 'published');
INSERT INTO quizzes (name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
VALUES ('Multithreading', 'Try your multithreading skills', 'Hope you had multithreading fun :)', '2018-02-02', '00:05:00', 2, 'published');

-- Table: user_quiz_junctions
/*1*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (7, 1, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'passed');
/*2*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (7, 2, 30, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'passed');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 25, FINISH_DATE = '2018-03-05 00:00:10', REOPEN_COUNTER = 1, STUDENT_QUIZ_STATUS = 'finished'
WHERE USER_QUIZ_JUNCTION_ID = 2;
/*3*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (3, 3, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'finished');
/*4*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (3, 4, 40, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'passed');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 40, FINISH_DATE = '2018-03-05 00:00:10', REOPEN_COUNTER = 1, STUDENT_QUIZ_STATUS = 'passed'
WHERE USER_QUIZ_JUNCTION_ID = 4;
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 35, FINISH_DATE = '2018-03-05 00:00:15', REOPEN_COUNTER = 2, STUDENT_QUIZ_STATUS = 'finished'
WHERE USER_QUIZ_JUNCTION_ID = 4;
/*5*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (3, 2, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'finished');
/*6*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (3, 1, null, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'opened');
/*7*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (4, 1, null, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'opened');
/*8*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (5, 3, null, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'opened');
/*9*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (6, 3, null, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'opened');
/*10*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, finish_date, reopen_counter, STUDENT_QUIZ_STATUS)
VALUES (4, 2, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:04', 0, 'finished');
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 19, FINISH_DATE = '2018-03-05 00:00:10', REOPEN_COUNTER = 0, STUDENT_QUIZ_STATUS = 'passed'
WHERE USER_QUIZ_JUNCTION_ID = 6;
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 19, FINISH_DATE = '2018-03-05 00:00:15', REOPEN_COUNTER = 1, STUDENT_QUIZ_STATUS = 'finished'
WHERE USER_QUIZ_JUNCTION_ID = 6;

-- Table: questions
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.1', 'Question 1.1 body?', 'Question 1.1 explanation', 'one_answer', 1);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.2', 'Question 1.2 body?', 'Question 1.2 explanation', 'few_answers', 2);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.3', 'Question 1.3 body?', 'Question 1.3 explanation', 'accordance', 3);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.4', 'Question 1.4 body?', 'Question 1.4 explanation', 'sequence', 3);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (1, 'Question #1.5', 'Question 1.5 body?', 'Question 1.5 explanation', 'number', 5);

INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.1', 'Question 2.1 body?', 'Question 2.1 explanation', 'one_answer', 1);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.2', 'Question 2.2 body?', 'Question 2.2 explanation', 'few_answers', 2);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (2, 'Question #2.3', 'Question 2.3 body?', 'Question 2.3 explanation', 'number', 5);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)

VALUES (3, 'Question #3.1', 'Question 3.1 body?', 'Question 3.1 explanation', 'one_answer', 1);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)
VALUES (3, 'Question #3.2', 'Question 3.2 body?', 'Question 3.2 explanation', 'few_answers', 2);
INSERT INTO questions (quiz_id, name, body, explanation, question_type, score)

VALUES (4, 'Question #4.1', 'Question 4.1 body?', 'Question 4.1 explanation', 'number', 4);

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
INSERT INTO answers_simple (question_id, body, correct) VALUES (6, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (7, 'correct answer', true);

INSERT INTO answers_simple (question_id, body, correct) VALUES (9, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (9, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (9, 'incorrect answer', false);

INSERT INTO answers_simple (question_id, body, correct) VALUES (10, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (10, 'correct answer', true);
INSERT INTO answers_simple (question_id, body, correct) VALUES (10, 'incorrect answer', false);
INSERT INTO answers_simple (question_id, body, correct) VALUES (10, 'correct answer', true);

-- Table: answers_accordance
INSERT INTO answers_accordance (question_id) VALUES (3);

-- Table: correct_maps
INSERT INTO correct_maps (left_side, right_side, answer_accordance_id) VALUES ('SQL', 'database', 1);
INSERT INTO correct_maps (left_side, right_side, answer_accordance_id) VALUES ('Java', 'backend', 1);
INSERT INTO correct_maps (left_side, right_side, answer_accordance_id) VALUES ('HTML', 'frontend', 1);

-- Table: answers_sequence
INSERT INTO answers_sequence (question_id) VALUES (4);

-- Table: correct_lists
INSERT INTO correct_lists (item, answer_sequence_id) VALUES ('First', 1);
INSERT INTO correct_lists (item, answer_sequence_id) VALUES ('Second', 1);
INSERT INTO correct_lists (item, answer_sequence_id) VALUES ('Third', 1);
INSERT INTO correct_lists (item, answer_sequence_id) VALUES ('Fourth', 1);

-- Table: answers_number
INSERT INTO answers_number (question_id, correct) VALUES (5, 5);
INSERT INTO answers_number (question_id, correct) VALUES (8, 3);
INSERT INTO answers_number (question_id, correct) VALUES (11, 1);