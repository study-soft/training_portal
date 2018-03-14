-- tables
-- Table: answers_accordance
DROP TABLE IF EXISTS answers_accordance;
CREATE TABLE answers_accordance (
  question_id bigint,
  left_side_1 VARCHAR(255) NOT NULL,
  right_side_1 VARCHAR(255) NOT NULL,
  left_side_2 VARCHAR(255) NOT NULL,
  right_side_2 VARCHAR(255) NOT NULL,
  left_side_3 VARCHAR(255) NOT NULL,
  right_side_3 VARCHAR(255) NOT NULL,
  left_side_4 VARCHAR(255) NOT NULL,
  right_side_4 VARCHAR(255) NOT NULL,
  CONSTRAINT answer_accordance_pk PRIMARY KEY (question_id)
);

-- Table: answers_number
DROP TABLE IF EXISTS answers_number;
CREATE TABLE answers_number (
  question_id bigint,
  correct int NOT NULL,
  CONSTRAINT answer_number_pk PRIMARY KEY (question_id)
);

-- Table: answers_sequence
DROP TABLE IF EXISTS answers_sequence;
CREATE TABLE answers_sequence (
  question_id bigint,
  item_1 VARCHAR(255) NOT NULL,
  item_2 VARCHAR(255) NOT NULL,
  item_3 VARCHAR(255) NOT NULL,
  item_4 VARCHAR(255) NOT NULL,
  CONSTRAINT answer_sequence_pk PRIMARY KEY (question_id)
);

-- Table: answers_simple
DROP TABLE IF EXISTS answers_simple;
CREATE TABLE answers_simple (
  answer_simple_id bigint NOT NULL AUTO_INCREMENT,
  question_id bigint NOT NULL,
  body varchar(255) NOT NULL,
  correct bool NOT NULL,
  CONSTRAINT answer_simple_pk PRIMARY KEY (answer_simple_id)
);

-- Table: groups
DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
  group_id bigint NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  description varchar(2048) NULL,
  creation_date date NOT NULL,
  author_id BIGINT NOT NULL,
  CONSTRAINT group_pk PRIMARY KEY (group_id)
);

-- Table: questions
DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  question_id bigint NOT NULL AUTO_INCREMENT,
  quiz_id bigint NOT NULL,
  name varchar(255) NOT NULL,
  body varchar(2048) NOT NULL,
  explanation varchar(2048) NULL,
  question_type varchar(255) NOT NULL,
  score int NOT NULL,
  CONSTRAINT question_pk PRIMARY KEY (question_id)
);

-- Table: quizzes
DROP TABLE IF EXISTS quizzes;
CREATE TABLE quizzes (
  quiz_id bigint NOT NULL AUTO_INCREMENT,
  name varchar(255) UNIQUE NOT NULL,
  description varchar(2048) NULL,
  explanation varchar(2048) NULL,
  creation_date date NOT NULL,
  passing_time time NULL,
  author_id bigint NOT NULL,
  teacher_quiz_status VARCHAR(255) NOT NULL,
  CONSTRAINT quiz_pk PRIMARY KEY (quiz_id)
);

-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  user_id bigint NOT NULL AUTO_INCREMENT,
  group_id bigint NULL,
  first_name varchar(255) NOT NULL,
  last_name varchar(255) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  date_of_birth varchar(255) NULL,
  phone_number varchar(255) UNIQUE NOT NULL,
  photo blob NULL,
  login varchar(255) UNIQUE NOT NULL,
  password varchar(255) NOT NULL,
  user_role varchar(255) NOT NULL,
  CONSTRAINT user_pk PRIMARY KEY (user_id)
);

-- Table: user_quiz_junctions
DROP TABLE IF EXISTS user_quiz_junctions;
CREATE TABLE user_quiz_junctions (
  user_id bigint NOT NULL,
  quiz_id bigint NOT NULL,
  result int NULL,
  submit_date datetime NULL,
  start_date datetime NULL,
  finish_date datetime NULL,
  attempt int NOT NULL,
  student_quiz_status varchar(255) NOT NULL,
  CONSTRAINT user_quiz_junction_pk PRIMARY KEY (user_id, quiz_id)
);

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