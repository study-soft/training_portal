ALTER USER postgres WITH SUPERUSER;
--ALTER ROLE postgres SET SEARCH_PATH = training_portal;
--SHOW search_path;
--SET search_path TO public;

--------------------------------- CREATE TABLES -------------------------------------

-- tables
-- Table: answers_accordance
DROP TABLE IF EXISTS answers_accordance CASCADE;
CREATE TABLE answers_accordance (
  question_id BIGINT PRIMARY KEY ,
  left_side_1 VARCHAR(255) NOT NULL,
  right_side_1 VARCHAR(255) NOT NULL,
  left_side_2 VARCHAR(255) NOT NULL,
  right_side_2 VARCHAR(255) NOT NULL,
  left_side_3 VARCHAR(255) NOT NULL,
  right_side_3 VARCHAR(255) NOT NULL,
  left_side_4 VARCHAR(255) NOT NULL,
  right_side_4 VARCHAR(255) NOT NULL
);

-- Table: answers_number
DROP TABLE IF EXISTS answers_number CASCADE;
CREATE TABLE answers_number (
  question_id BIGINT PRIMARY KEY ,
  correct int NOT NULL
);

-- Table: answers_sequence
DROP TABLE IF EXISTS answers_sequence CASCADE;
CREATE TABLE answers_sequence (
  question_id BIGINT PRIMARY KEY,
  item_1 VARCHAR(255) NOT NULL,
  item_2 VARCHAR(255) NOT NULL,
  item_3 VARCHAR(255) NOT NULL,
  item_4 VARCHAR(255) NOT NULL
);

-- Table: answers_simple
DROP TABLE IF EXISTS answers_simple CASCADE;
DROP SEQUENCE IF EXISTS answers_simple_answer_simple_id_seq;
CREATE TABLE answers_simple (
  answer_simple_id BIGSERIAL PRIMARY KEY,
  question_id bigint NOT NULL,
  body varchar(255) NOT NULL,
  correct BOOLEAN NOT NULL
);

-- Table: groups
DROP TABLE IF EXISTS groups CASCADE;
DROP SEQUENCE IF EXISTS groups_group_id_seq;
CREATE TABLE groups (
  group_id BIGSERIAL PRIMARY KEY,
  name varchar(255) UNIQUE NOT NULL,
  description VARCHAR(65535),
  creation_date DATE NOT NULL,
  author_id BIGINT NOT NULL
);

-- Table: questions
DROP TABLE IF EXISTS questions CASCADE;
DROP SEQUENCE IF EXISTS questions_question_id_seq;
CREATE TABLE questions (
  question_id BIGSERIAL PRIMARY KEY,
  quiz_id bigint NOT NULL,
  body VARCHAR(65535) NOT NULL,
  explanation VARCHAR(65535) NULL,
  question_type varchar(255) NOT NULL,
  score int NOT NULL
);

-- Table: quizzes
DROP TABLE IF EXISTS quizzes CASCADE;
DROP SEQUENCE IF EXISTS quizzes_quiz_id_seq;
CREATE TABLE quizzes (
  quiz_id BIGSERIAL PRIMARY KEY,
  name varchar(255) UNIQUE NOT NULL,
  description VARCHAR(65535) NULL,
  explanation VARCHAR(65535) NULL,
  creation_date date NOT NULL,
  passing_time time NULL,
  author_id bigint NOT NULL,
  teacher_quiz_status VARCHAR(255) NOT NULL
);

-- Table: users
DROP TABLE IF EXISTS users CASCADE;
DROP SEQUENCE IF EXISTS users_user_id_seq;
CREATE TABLE users (
  user_id BIGSERIAL PRIMARY KEY,
  group_id bigint NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  date_of_birth varchar(255) NULL,
  phone_number varchar(255) UNIQUE NOT NULL,
  photo bytea NULL,
  login varchar(255) UNIQUE NOT NULL,
  password varchar(255) NOT NULL,
  user_role varchar(255) NOT NULL
);

-- Table: user_quiz_junctions
DROP TABLE IF EXISTS user_quiz_junctions CASCADE ;
CREATE TABLE user_quiz_junctions (
  user_id BIGINT NOT NULL,
  quiz_id BIGINT NOT NULL,
  result int NULL,
  submit_date TIMESTAMP NOT NULL,
  start_date TIMESTAMP NULL,
  finish_date TIMESTAMP NULL,
  attempt int NOT NULL,
  student_quiz_status varchar(255) NOT NULL
);

--------------------------------- ADD CONSTRAINTS -------------------------------------

-- primary keys
-- user_quiz_junction
ALTER TABLE user_quiz_junctions ADD CONSTRAINT user_quiz_junctions_pk
PRIMARY KEY (user_id, quiz_id);

-- foreign keys
-- Reference: User_Group (table: users)
ALTER TABLE users ADD CONSTRAINT users_groups_fk FOREIGN KEY (group_id)
REFERENCES groups (group_id);

-- Reference: answer_accordance_question (table: answers_accordance)
ALTER TABLE answers_accordance ADD CONSTRAINT answers_accordance_questions_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_answer_sequence (table: answers_sequence)
ALTER TABLE answers_sequence ADD CONSTRAINT questions_answers_sequence_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_answer_simple (table: answers_simple)
ALTER TABLE answers_simple ADD CONSTRAINT questions_answers_simple_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_answer_number (table: answers_number)
ALTER TABLE answers_number ADD CONSTRAINT questions_answers_number_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_quiz (table: questions)
ALTER TABLE questions ADD CONSTRAINT questions_quizzes_fk FOREIGN KEY (quiz_id)
REFERENCES quizzes (quiz_id);

-- Reference: user_quiz_junction_quiz (table: user_quiz_junctions)
ALTER TABLE user_quiz_junctions ADD CONSTRAINT user_quiz_junctions_quizzes_fk FOREIGN KEY (quiz_id)
REFERENCES quizzes (quiz_id);

-- Reference: user_quiz_junction_user (table: user_quiz_junctions)
ALTER TABLE user_quiz_junctions ADD CONSTRAINT user_quiz_junctions_users_fk FOREIGN KEY (user_id)
REFERENCES users (user_id);

-- Reference: quiz_user (table: quizzes)
ALTER TABLE quizzes ADD CONSTRAINT quizzes_users_fk FOREIGN KEY (author_id)
REFERENCES users(user_id);

-- Reference: group_user (table: groups)
ALTER TABLE groups ADD CONSTRAINT groups_users_fk FOREIGN KEY (author_id)
REFERENCES users(user_id);

--------------------------------- INSERT DATA -------------------------------------

-- Table: users (teachers)
/*1*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
     VALUES (null, 'Andrew', 'Bronson', 'andrew@example.com', '1970-05-10', '(073)-000-00-11', null, 'Andrew', '123', 'TEACHER');
/*2*/INSERT INTO users (group_id, first_name, last_name, email, date_of_birth, phone_number, photo, login, password, user_role)
     VALUES (null, 'Angel', 'Peterson', 'angel@example.com', '1980-06-15', '(073)-003-02-01', null, 'Angel', '123', 'TEACHER');

-- Table: groups
/*1*/INSERT INTO groups (name, description, creation_date, author_id) VALUES ('IS-4', 'Program engineering', '2018-03-02', 1);
/*2*/INSERT INTO groups (name, description, creation_date, author_id) VALUES ('AM-4', 'Applied Mathematics', '2017-03-02', 2);
/*3*/INSERT INTO groups (name, description, creation_date, author_id) VALUES ('Informatics', NULL, '2017-03-30', 1);

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
/*1*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (1, 'Object Oriented Programming', 'There are questions to test your skills in object oriented programming in Java', null, '2018-05-01', '00:10:00', 1, 'PUBLISHED');
/*2*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (2, 'Exceptions', 'Try your exceptions skills', 'Hope you had fun with exceptions :)', '2018-12-02', '00:10:00', 1, 'PUBLISHED');
/*3*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (3, 'Generics', 'Try your generics skills', 'Hope you had fun with generics :)', '2018-02-01', '00:15:00', 2, 'PUBLISHED');
/*4*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (4, 'Multithreading', 'Try your multithreading skills', 'Hope you had multithreading fun :)', '2018-02-02', '00:00:10', 2, 'PUBLISHED');
/*5*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (5, 'Collections', 'Try your collections skills', 'Hope you had fun with collections :)', '2018-03-11', '00:15:00', 1, 'PUBLISHED');
/*6*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (6, 'Input output', 'Try your IO skills', 'Hope you had IO fun :)', '2018-03-11', '00:12:30', 2, 'PUBLISHED');
/*7*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (7, 'Pascal basics', 'Try your pascal skills', 'Hope you had pascal fun but Pascal is dead :)', '2018-02-02', '00:05:00', 2, 'UNPUBLISHED');
/*8*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (8, 'Pascal advanced', 'Try your senior pascal skills', 'Hope you had Pascal fun but Pascal is dead :)', '2018-03-11', '00:05:00', 2, 'UNPUBLISHED');
/*9*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
     VALUES (9, 'HTML basics', 'Try your HTML skills', null, '2018-03-11', '00:10:00', 1, 'UNPUBLISHED');
/*10*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
      VALUES (10, 'HTML forms', 'Try your HTML skills with forms', 'Hope you had HTML fun :)', '2018-03-11', '00:09:00', 1, 'UNPUBLISHED');
/*11*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
      VALUES (11, 'Servlet API', null, null, '2018-03-27', null, 1, 'PUBLISHED');
/*12*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
      VALUES (12, 'Java server pages', null, null, '2018-03-27', null, 1, 'PUBLISHED');
/*13*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
      VALUES (13, 'SQL', null, null, '2018-03-29', null, 1, 'UNPUBLISHED');
/*14*/INSERT INTO quizzes (quiz_id, name, description, explanation, creation_date, passing_time, author_id, teacher_quiz_status)
      VALUES (14, 'Javascript basics', null, null, '2018-03-29', null, 1, 'UNPUBLISHED');

-- Table: user_quiz_junctions
/*1*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (7, 1, 20, '2018-03-05 00:00:00', '2018-03-05 00:00:02', '2018-03-05 00:00:04', 1, 'PASSED');
/*2*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (7, 2, 13, '2018-03-05 00:00:00', '2018-04-04 15:32:03', '2018-04-04 15:37:04', 1, 'CLOSED');
/*3*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (3, 3, 7, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:00:04', 2, 'CLOSED');
/*4*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (3, 4, 12, '2018-03-05 00:00:00', '2018-04-04 15:32:02', '2018-04-04 15:32:08', 3, 'CLOSED');
/*5*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (3, 2, 16, '2018-03-05 00:00:00', '2018-03-05 00:00:03', '2018-03-05 00:00:04', 2, 'PASSED');
/*6*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (3, 1, 23, '2018-03-05 00:00:00', '2018-04-04 15:30:34', '2018-04-04 15:40:04', 2, 'CLOSED');
/*7*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (4, 1, 10, '2018-03-08 00:13:00', '2018-04-04 15:35:40', '2018-04-04 15:41:32', 1, 'PASSED');
/*8*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (5, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*9*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (6, 3, null, '2018-03-05 00:00:00', null, null, 0, 'OPENED');
/*10*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
       VALUES (4, 2, 10, '2018-03-05 00:00:00', '2018-03-05 00:00:01', '2018-03-05 00:03:04', 1, 'CLOSED');
/*11*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
       VALUES (4, 3, 5, '2018-03-06 00:14:00', '2018-03-11 00:00:00', '2018-03-11 00:05:00', 2, 'CLOSED');
/*12*/ INSERT INTO user_quiz_junctions (user_id, quiz_id, result, submit_date, start_date, finish_date, ATTEMPT, STUDENT_QUIZ_STATUS)
       VALUES (4, 4, 11, '2018-03-05 00:08:00', '2018-03-11 00:10:00', '2018-03-11 00:10:04', 2, 'PASSED');
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
      VALUES (13, 2, 9, '2018-03-05 00:00:00', '2018-03-27 10:24:00', '2018-03-27 10:32:22', 2, 'CLOSED');
/*28*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (14, 2, NULL, '2018-03-05 00:00:00', NULL, NULL, 0, 'OPENED');
/*29*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (11, 3, 1, '2018-03-06 00:14:00', '2018-03-27 10:20:00', '2018-03-27 10:33:45', 1, 'CLOSED');
/*30*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (12, 3, 9, '2018-03-06 00:14:00', '2018-03-27 10:25:00', '2018-03-27 10:34:00', 2, 'CLOSED');
/*31*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (13, 3, 8, '2018-03-06 00:14:00', '2018-03-27 10:27:00', '2018-03-27 10:35:11', 1, 'CLOSED');
/*32*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (14, 3, 6, '2018-03-06 00:14:00', '2018-03-27 10:28:00', '2018-03-27 10:35:55', 1, 'CLOSED');
/*33*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (11, 4, NULL, '2018-03-05 00:08:00', NULL, NULL, 0, 'OPENED');
/*34*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (12, 4, NULL, '2018-03-05 00:08:00', NULL, NULL, 0, 'OPENED');
/*35*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (13, 4, 9, '2018-03-05 00:08:00', '2018-03-27 10:30:00', '2018-03-27 10:30:09', 2, 'CLOSED');
/*36*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (14, 4, 14, '2018-03-05 00:08:00', '2018-03-27 10:33:00', '2018-03-27 10:33:11', 1, 'PASSED');
/*37*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (11, 5, 18, '2018-03-05 00:24:00', '2018-03-27 10:30:00', '2018-03-27 10:38:10', 1, 'CLOSED');
/*38*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (12, 5, 15, '2018-03-05 00:24:00', '2018-03-27 10:32:00', '2018-03-27 10:38:43', 2, 'CLOSED');
/*39*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (13, 5, 20, '2018-03-05 00:24:00', '2018-03-27 10:30:00', '2018-03-27 10:39:00', 1, 'PASSED');
/*40*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (14, 5, 8, '2018-03-05 00:24:00', '2018-03-27 10:34:00', '2018-03-27 10:39:25', 2, 'PASSED');
/*41*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (11, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*42*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (12, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*43*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (13, 6, 4, '2018-03-05 00:31:30', '2018-03-27 10:30:00', '2018-03-27 10:40:00', 1, 'PASSED');
/*44*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (14, 6, NULL, '2018-03-05 00:31:30', NULL, NULL, 0, 'OPENED');
/*45*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (4, 11, 13, '2018-03-27 11:04:00', '2018-04-05 14:28:32', '2018-04-05 14:32:33', 1, 'CLOSED');
/*46*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (4, 12, 21, '2018-03-27 11:05:00', '2018-03-27 11:06:00', '2018-03-27 11:07:00', 1, 'PASSED');
/*47*/INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
      VALUES (3, 11, 19, '2018-03-27 11:06:00', '2018-03-27 11:06:45', '2018-03-27 11:07:30', 1, 'CLOSED');
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
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (2, 1, 'Select primitive data types from Java', ' There are 8 primitive data types in Java: byte, short, char, int, long, double, float, boolean', 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (5, 1, 'What will print this program:
public class Test {
      public static void main(String[] args) {
            List strings1 = new ArrayList<>(Arrays.asList("24", "a", "xyz"));
            List strings2 = new ArrayList<>(Arrays.asList("30", "24", "17", "b"));
            strings1.retainAll(strings2);
            System.out.println(strings1.get(0));
      }
}', 'retainAll() is an intersection of two collections', 'NUMBER', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (6, 1, 'Which type of inheritance in Java?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (7, 1, 'Select all principles of object oriented programming', null, 'FEW_ANSWERS', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (9, 1, 'Arrange classes and interfaces from parent to child', null, 'SEQUENCE', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (10, 1, 'Enter the year of Java first release date', 'January 23, 1996', 'NUMBER', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (11, 1, 'Which keyword would you use for comparison of types?', 'See docs.oracle.com', 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (12, 1, 'Select correct statement about difference between interface and abstract class', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (14, 2, 'Select all CHECKED exceptions', null, 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (16, 5, 'ArrayList based on singly-linked list', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (17, 5, 'Select ALL collections where average difficulty of remove() operation is O(1)', null, 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (18, 4, 'Question 4.1 body?', 'Question 4.1 explanation', 'NUMBER', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (22, 7, 'Pascal is dead?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (25, 10, 'Which element DOESN''T belongs to HTML forms?', '''Name'' is input type element, NOT form', 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (26, 10, 'Set accordance between HTML form elements and their description', null, 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (27, 10, 'Enter the year when Berners-Lee wrote HTML', 'End of 1990', 'NUMBER', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (28, 10, 'Which input restriction specifies a regular expression to check the input value against', 'It is ''pattern'' restriction', 'ONE_ANSWER', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (29, 10, 'Set correct sequence of tags in HTML document', '<html> -> <form action="handler.php"> -> <input type="checkbox"> -> </body>', 'SEQUENCE', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (30, 10, 'Select all CORRECT HTML form input types', '''style'' and ''value'' are NOT input types', 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (31, 11, 'Enter the year when HTTP was invented', null, 'NUMBER', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (32, 12, 'Which mechanism add content statically in JSP file?', null, 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (33, 1, 'Arrange access modifiers from narrowest to widest', null, 'SEQUENCE', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (34, 14, 'Where is the correct place to insert a JavaScript?', null, 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (35, 14, 'How do you write "Hello World" in an alert box?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (37, 14, 'How do you create a function in JavaScript?', ' There are two ways to create a function in JavaScript:
function myFunction() - function definition;
var function = function() - function expression;', 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (43, 14, 'How does a WHILE loop start?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (44, 14, 'What is the correct way to write a JavaScript array?', 'The following statements create equivalent arrays:
var arr = new Array(element0, element1, ..., elementN);
var arr = Array(element0, element1, ..., elementN);
var arr = [element0, element1, ..., elementN];', 'FEW_ANSWERS', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (45, 14, 'How can you detect the client''s browser name?', 'navigator - global object of JavaScript', 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (46, 14, 'Which event occurs when the user clicks on an HTML element?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (48, 13, 'Which SQL statement is used to extract data from a database?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (49, 13, 'With SQL, how do you select all the columns from a table named "Persons"?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (50, 13, 'With SQL, how do you select all the records from a table named "Persons" where the value of the column "FirstName" is "Peter"?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (51, 13, 'With SQL, how do you select all the records from a table named "Persons" where the "LastName" is alphabetically between (and including) "Hansen" and "Pettersen"?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (52, 13, 'Which SQL statement is used to return only different values?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (53, 13, 'Which SQL keyword is used to sort the result-set?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (54, 13, 'With SQL, how can you insert a new record into the "Persons" table?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (55, 13, 'With SQL, how can you return the number of records in the "Persons" table?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (56, 13, 'What is the most common type of join?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (57, 13, 'Set accordance between abbreviations and their definitions', null, 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (58, 13, 'Enter the year when SQL was first appeared', 'SQL was initially developed at IBM by Donald D. Chamberlin and Raymond F. Boyce after learning about the relational model from Ted Codd in the early 1970s', 'NUMBER', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (59, 2, 'Select all UNCHECKED exceptions', null, 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (60, 2, 'Set correct sequence from parent to child in exceptions hierarchy', null, 'SEQUENCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (61, 2, 'Block ''finally'' is always executed', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (62, 2, 'Set accordance between exceptions and cases when they are thrown', 'See docs.oracle.com', 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (63, 2, 'Error checked?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (64, 3, 'In which version of Java generic types were appear?', null, 'NUMBER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (65, 3, 'Set accordance between code fragments and their usage', null, 'ACCORDANCE', 6);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (66, 11, 'Set correct hierarchy from parent to child', null, 'SEQUENCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (67, 11, 'Object that intercepts request and can transform header and content of the client''s request', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (68, 11, 'Set correct sequence of servlet''s methods invocation when application is starting', null, 'SEQUENCE', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (69, 11, 'Which action leads to the loss of request attributes?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (70, 11, 'Which HTTP method is MUTABLE?', null, 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (71, 11, 'Which methods are NOT DEFINED in HTTP specification?', 'HTTP methods: GET, POST, PUT, DELETE, HEAD, TRACE, OPTIONS', 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (72, 12, 'Set correct sequence of JSP lifecycle', null, 'SEQUENCE', 6);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (73, 12, 'How can you use scriplet on JSP?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (74, 12, 'Which place in "Model-view-controller" pattern JSP takes?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (75, 12, 'Select all CORRECT variants of using equality operator in JSP', null, 'FEW_ANSWERS', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (76, 12, 'Enter the year when JSP appeared', 'June 1999', 'NUMBER', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (77, 12, 'Set correct sequence of variable scopes in JSP from narrowest to widest', null, 'SEQUENCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (78, 12, 'What is TLD?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (79, 12, 'Which groups of tags includes JSTL?', null, 'FEW_ANSWERS', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (94, 1, 'Set accordance between code fragments and their description', null, 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (95, 3, 'Select the most correct declaration of ArrayList', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (107, 5, 'Arrange classes and interfaces into correct hierarchy from parent to child', null, 'SEQUENCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (108, 5, 'Set accordance between contains() method and its average difficulty in different collections', null, 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (109, 5, 'I want to insert 1 million elements into begin of List. Which implementation should I use?', 'ArrayList - O(n), LinkedList - O(1)', 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (110, 5, 'I want to get element on index from List. Which implementation should I use?', 'ArrayList - O(1), LinkedList - O(n)', 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (111, 5, 'Select correct statement about ArrayList', null, 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (112, 5, 'Map<String, String> map = new HashMap<>();
Which is the maximum number of used buckets in this Map before the first rehash?', 'Default initial capacity = 16;
Default load factor = 0.75;
So 16 * 0.75 = 12', 'NUMBER', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (113, 8, 'Set accordance between programming languages and their application area', 'Pascal is dead', 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (114, 4, 'Select correct ways how can create thread', null, 'FEW_ANSWERS', 3);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (115, 4, 'On which object synchronization occurs when static method is called?', null, 'ONE_ANSWER', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (116, 4, 'Which interface can throws exception?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (117, 4, 'Set accordance between type of synchronizers and their descriptions', null, 'ACCORDANCE', 4);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (118, 6, 'Choose char-oriented streams', null, 'FEW_ANSWERS', 2);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (119, 6, 'What is most common used charset?', null, 'ONE_ANSWER', 1);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (120, 6, 'Select ALL classes-adapters', null, 'FEW_ANSWERS', 5);
INSERT INTO questions (question_id, quiz_id, body, explanation, question_type, score)
VALUES (121, 6, 'Select ALL classes-decorators', null, 'FEW_ANSWERS', 4);

-- Table: answers_simple
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (46, 25, 'text', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (47, 25, 'select', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (48, 25, 'name', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (49, 25, 'input', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (50, 28, 'value', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (51, 28, 'step', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (52, 28, 'size', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (53, 28, 'pattern', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (54, 30, 'radio', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (55, 30, 'submit', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (56, 30, 'style', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (57, 30, 'button', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (58, 30, 'reset', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (59, 30, 'value', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (67, 6, 'Monotonous', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (68, 6, 'Plural', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (69, 6, 'Both', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (73, 7, 'Composition', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (74, 7, 'Encapsulation', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (75, 7, 'Inheritance', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (76, 7, 'Enumeration', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (77, 7, 'Reflexivity', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (78, 7, 'Polymorphysm', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (85, 2, 'boolean', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (86, 2, 'number', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (87, 2, 'symbol', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (88, 2, 'int', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (89, 2, 'double', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (90, 2, 'string', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (95, 12, 'we can create instances of abstract class', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (96, 12, 'inrerface and abstract class are synonyms', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (97, 12, 'interface represent behaviour, abstract class - default template implementation', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (98, 12, 'interface does not have implemented methods since Java 8', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (99, 34, 'Both the <head> section and the <body> section are correct', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (100, 34, 'The <body> section', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (101, 34, 'The <head> section', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (102, 35, 'msgBox("Hello World");', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (103, 35, 'alert("Hello World");', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (104, 35, 'alertBox("Hello World");', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (105, 35, 'msg("Hello World");', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (110, 37, 'function myFunction()', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (111, 37, 'function = myFunction()', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (112, 37, 'function:myFunction()', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (113, 37, 'var function = function()', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (143, 43, 'while i = 1 to 10', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (144, 43, 'while (i <= 10; i++)', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (145, 43, 'while (i <= 10)', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (146, 44, 'var colors = 1 = ("red"), 2 = ("green"), 3 = ("blue")', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (147, 44, 'var colors = "red", "green", "blue"', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (148, 44, 'var colors = ["red", "green", "blue"]', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (149, 44, 'var colors = (1:"red", 2:"green", 3:"blue")', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (150, 44, 'var colors = new Array("red", "green", "blue");', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (151, 44, 'var colors = Array("red", "green", "blue");', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (152, 45, 'browser.name', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (153, 45, 'navigator.appName', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (154, 45, 'client.navName', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (155, 46, 'onclick', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (156, 46, 'onchange', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (157, 46, 'onmouseclick', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (158, 46, 'onmouseover', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (159, 48, 'GET', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (160, 48, 'SELECT', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (161, 48, 'EXTRACT', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (162, 48, 'OPEN', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (163, 49, 'SELECT *.Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (164, 49, 'SELECT * FROM Persons', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (165, 49, 'SELECT Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (166, 49, 'SELECT [all] FROM Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (167, 50, 'SELECT [all] FROM Persons WHERE FirstName=''Peter''', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (168, 50, 'SELECT * FROM Persons WHERE FirstName<>''Peter''', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (169, 50, 'SELECT [all] FROM Persons WHERE FirstName LIKE ''Peter''', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (170, 50, 'SELECT * FROM Persons WHERE FirstName=''Peter''', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (171, 51, 'SELECT * FROM Persons WHERE LastName BETWEEN ''Hansen'' AND ''Pettersen''', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (172, 51, 'SELECT * FROM Persons WHERE LastName>''Hansen'' AND LastName<''Pettersen''', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (173, 51, 'SELECT LastName>''Hansen'' AND LastName<''Pettersen'' FROM Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (174, 52, 'SELECT DIFFERENT', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (175, 52, 'SELECT DISTINCT', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (176, 52, 'SELECT UNIQUE', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (177, 53, 'SORT', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (178, 53, 'ORDER BY', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (179, 53, 'ORDER', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (180, 53, 'SORT BY', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (181, 54, 'INSERT (''Jimmy'', ''Jackson'') INTO Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (182, 54, 'INSERT INTO Persons VALUES (''Jimmy'', ''Jackson'')', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (183, 54, 'INSERT VALUES (''Jimmy'', ''Jackson'') INTO Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (184, 55, 'SELECT COLUMNS(*) FROM Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (185, 55, 'SELECT COUNT(*) FROM Persons', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (186, 55, 'SELECT NO(*) FROM Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (187, 55, 'SELECT LEN(*) FROM Persons', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (188, 56, 'INNER JOIN', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (189, 56, 'JOINED', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (190, 56, 'INSIDE JOIN', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (191, 56, 'JOINED TABLE', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (192, 14, 'NullPointerException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (193, 14, 'IndexOutOfBoundsException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (194, 14, 'ClassNotFoundException', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (195, 14, 'SQLException', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (196, 14, 'ClassCastException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (197, 14, 'InterruptedException', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (198, 59, 'IOException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (199, 59, 'Arithmetic exception', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (200, 59, 'IllegalStateException', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (201, 59, 'ServletException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (202, 59, 'ArrayStoreException', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (203, 59, 'FileNotFoundException', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (204, 61, 'true', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (205, 61, 'false', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (206, 63, 'Yes', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (207, 63, 'No', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (208, 67, 'ServletContext', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (209, 67, 'ServletConfig', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (210, 67, 'Filter', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (211, 67, 'HttpSession', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (212, 69, 'Response.sendRedirect()', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (213, 69, 'RequestDispatcher.forward()', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (214, 69, 'RequestDispatcher.include()', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (215, 70, 'GET', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (216, 70, 'POST', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (217, 70, 'PUT', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (218, 70, 'DELETE', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (219, 71, 'GET', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (220, 71, 'CHECK', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (221, 71, 'HEAD', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (222, 71, 'SELECT', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (223, 71, 'POST', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (224, 71, 'OPTIONS', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (225, 71, 'RETURN', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (226, 32, '<%@include%>', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (227, 32, '<jsp:include>', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (228, 32, '<c:import>', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (229, 73, '<% scriplet %>', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (230, 73, '<%@ scriplet %>', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (231, 73, '<c:out scriplet >', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (232, 74, 'Model', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (233, 74, 'View', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (234, 74, 'Controller', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (235, 75, '!=', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (236, 75, '==', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (237, 75, 'eq', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (238, 75, 'equals', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (239, 75, '=', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (240, 78, 'Tag language definition', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (241, 78, 'Tag library descriptor', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (242, 78, 'Text list of data', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (243, 79, 'Core', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (244, 79, 'General', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (245, 79, 'Function', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (246, 79, 'XML', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (247, 79, 'Application', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (248, 79, 'JSON', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (280, 11, 'is', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (281, 11, 'typeof', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (282, 11, 'instanceof', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (283, 95, 'List<String> list = new List<>();', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (284, 95, 'List<String> list = new ArrayList<>();', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (285, 95, 'ArrayList<String> list = new ArrayList<>();', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (286, 95, 'List<> list = new ArrayList<>();', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (297, 110, 'ArrayList', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (298, 110, 'LinkedList', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (299, 109, 'ArrayList', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (300, 109, 'LinkedList', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (301, 111, 'default initial capacity 10, 2-fold increment', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (302, 111, 'default initial capacity 0, 1.5-fold increment', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (303, 111, 'default initial capacity 10, 1.5-fold increment', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (304, 111, 'default initial capacity 16, 1.5-fold increment', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (305, 111, 'default initial capacity 16, 2-fold increment', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (312, 17, 'ArrayList', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (313, 17, 'LinkedList', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (314, 17, 'HashSet', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (315, 17, 'TreeSet', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (316, 17, 'HashMap', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (317, 17, 'TreeMap', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (320, 16, 'true', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (321, 16, 'false', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (322, 22, 'true', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (323, 22, 'false', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (324, 114, 'implements Runnable', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (325, 114, 'extends Thread', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (326, 114, '@ThreadSafe', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (327, 114, 'implements Executor', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (328, 114, 'implements Callable', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (329, 114, 'implements Future', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (330, 115, 'class', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (331, 115, 'method', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (332, 115, 'field', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (333, 116, 'Runnable', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (334, 116, 'Callable', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (335, 118, 'InputSteam', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (336, 118, 'OutputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (337, 118, 'Reader', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (338, 118, 'Writer', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (342, 119, 'ASCII', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (343, 119, 'UTF-8', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (344, 119, 'windows1251', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (352, 120, 'InputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (353, 120, 'InputStreamReader', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (354, 120, 'Reader', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (355, 120, 'FileInputStream', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (356, 120, 'DataInputStream', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (357, 120, 'File', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (358, 120, 'DataInput', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (359, 120, 'BufferedReader', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (360, 120, 'BufferedInputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (361, 121, 'OutputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (362, 121, 'OutputStreamWriter', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (363, 121, 'Writer', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (364, 121, 'BufferedWriter', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (365, 121, 'ByteArrayOutputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (366, 121, 'BufferedOutputStream', TRUE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (367, 121, 'ObjectOutputStream', FALSE);
INSERT INTO answers_simple (answer_simple_id, question_id, body, correct) VALUES (368, 121, 'CZIPOutputStream', TRUE);

-- Table: answers_accordance
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (26, '<textarea>', 'Defines a multiline input control',
        '<select>', 'Defines a drop-down list',
        '<option>', 'Defines an option in a drop-down list',
        '<input>', 'Defines an input control');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (57, 'SQL', 'Language for storing, manipulating and retrieving data in databases',
        'DDL', 'Language for defining data structures, especially database schemas',
        'DML', 'Language used for adding (inserting), deleting, and modifying (updating) data in a database',
        'MySQL', 'Open-source relational database management system (RDBMS)');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (62, 'NullPointerException', 'Thrown when an application attempts to use an object reference that has the null value',
        'ArithmeticException', 'Thrown when condition "divide by zero" is occured',
        'ArrayIndexOutOfBoundsException', 'Thrown to indicate that an array has been accessed with an illegal index',
        'IllegalStateException', 'Thrown when a method has been invoked at an illegal or inappropriate time');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (65, '<? extends Number>', 'Undefined type parameter is producer',
        '<? super Comparable>', 'Undefined type parameter is consumer',
        'List<?>', 'Value of type parameter is not important',
        'List<String>', 'Value of type parameter is important');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (94, '(a == 1)', 'expression',
        'a = b + 1;', 'statement',
        '{a = 0; b = a + 1;}', 'block',
        '[a-zA-Z]+', 'regular expression');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (108, 'HashMap', 'O(1)',
        'TreeMap', 'O(log(n))',
        'List', 'O(n)',
        'List<List>', 'O(n^2)');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (113, 'Java', 'Backend',
        'HTML', 'Frontend',
        'SQL', 'Database',
        'Pascal', 'Dead');
INSERT INTO answers_accordance (question_id, left_side_1, right_side_1, left_side_2, right_side_2, left_side_3, right_side_3, left_side_4, right_side_4)
VALUES (117, 'Monitor', 'Synchronization construct that allows threads to have mutual exclusion',
        'CountDownLatch', 'A synchronization aid that allows one or more threads to wait until a set of operations being performed in other threads completes',
        'Semaphore', 'Synchronization construct used to control access to a common resource by multiple processes in a concurrent system such as a multitasking operating system',
        'CyclicBarrier', 'A synchronization aid that allows a set of threads to all wait for each other to reach a common barrier point');

-- Table: answers_sequence
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (9, 'Object', 'Collection', 'List', 'ArrayList');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (29, '<html>', '<form action="handler.php">', '<input type="checkbox">', '</body>');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (33, 'private', 'default (package private)', 'protected', 'public');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (60, 'Throwable', 'Exception', 'IOException', 'EndOfFileException');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (66, 'Servlet', 'GenericServlet', 'HttpServlet', 'CustomServlet');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (68, 'default constructor', 'init()', 'service()', 'destroy()');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (72, 'Translation to java class', 'Compilation to bytecodes', 'Initialization', 'Request processing');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (77, 'page', 'request', 'session', 'application');
INSERT INTO answers_sequence (question_id, item_1, item_2, item_3, item_4)
VALUES (107, 'Set', 'SortedSet', 'NavigableSet', 'TreeSet');

-- Table: answers_number
INSERT INTO answers_number (question_id, correct) VALUES (5, 24);
INSERT INTO answers_number (question_id, correct) VALUES (10, 1996);
INSERT INTO answers_number (question_id, correct) VALUES (18, 1);
INSERT INTO answers_number (question_id, correct) VALUES (27, 1990);
INSERT INTO answers_number (question_id, correct) VALUES (31, 1992);
INSERT INTO answers_number (question_id, correct) VALUES (58, 1974);
INSERT INTO answers_number (question_id, correct) VALUES (64, 5);
INSERT INTO answers_number (question_id, correct) VALUES (76, 1999);
INSERT INTO answers_number (question_id, correct) VALUES (112, 12);
