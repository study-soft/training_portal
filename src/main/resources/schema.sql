-- tables
-- Table: answers_accordance
DROP TABLE IF EXISTS answers_accordance;
CREATE TABLE answers_accordance (
  answer_accordance_id bigint NOT NULL AUTO_INCREMENT,
  question_id bigint NOT NULL,
  CONSTRAINT answer_accordance_pk PRIMARY KEY (answer_accordance_id)
);

-- Table: answers_number
DROP TABLE IF EXISTS answers_number;
CREATE TABLE answers_number (
  answer_number_id bigint NOT NULL AUTO_INCREMENT,
  question_id bigint NOT NULL,
  correct int NOT NULL,
  CONSTRAINT answer_space_pk PRIMARY KEY (answer_number_id)
);

-- Table: answers_sequence
DROP TABLE IF EXISTS answers_sequence;
CREATE TABLE answers_sequence (
  answer_sequence_id bigint NOT NULL AUTO_INCREMENT,
  question_id bigint NOT NULL,
  CONSTRAINT answer_sequence_pk PRIMARY KEY (answer_sequence_id)
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

-- Table: correct_lists
DROP TABLE IF EXISTS correct_lists;
CREATE TABLE correct_lists (
  correct_list_id bigint NOT NULL AUTO_INCREMENT,
  item varchar(255) NOT NULL,
  answer_sequence_id BIGINT NOT NULL ,
  CONSTRAINT correct_list_pk PRIMARY KEY (correct_list_id)
);

-- Table: correct_maps
DROP TABLE IF EXISTS correct_maps;
CREATE TABLE correct_maps (
  correct_map_id bigint NOT NULL AUTO_INCREMENT,
  left_side varchar(255) NOT NULL,
  right_side varchar(255) NOT NULL,
  answer_accordance_id BIGINT NOT NULL ,
  CONSTRAINT correct_map_pk PRIMARY KEY (correct_map_id)
);

-- Table: groups
DROP TABLE IF EXISTS groups;
CREATE TABLE groups (
  group_id bigint NOT NULL AUTO_INCREMENT,
  name varchar(255) UNIQUE NOT NULL,
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
  first_name varchar(255) NULL,
  last_name varchar(255) NULL,
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
  user_quiz_junction_id bigint NOT NULL AUTO_INCREMENT,
  user_id bigint NOT NULL,
  quiz_id bigint NOT NULL,
  result int NULL,
  submit_date datetime NULL,
  finish_date datetime NULL,
  reopen_counter int NOT NULL,
  student_quiz_status varchar(255) NOT NULL,
  CONSTRAINT user_quiz_junction_pk PRIMARY KEY (user_quiz_junction_id)
);

-- foreign keys
-- Reference: User_Group (table: users)
ALTER TABLE users ADD CONSTRAINT users_groups_fk FOREIGN KEY (group_id)
REFERENCES groups (group_id);

-- Reference: answer_accordance_correct_map (table: answers_accordance)
ALTER TABLE correct_maps ADD CONSTRAINT correct_maps_answers_accordance_fk FOREIGN KEY (answer_accordance_id)
REFERENCES answers_accordance (answer_accordance_id);

-- Reference: answer_accordance_question (table: answers_accordance)
ALTER TABLE answers_accordance ADD CONSTRAINT answers_accordance_questions_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: correct_list_answer_sequence (table: answers_sequence)
ALTER TABLE correct_lists ADD CONSTRAINT answer_sequences_correct_lists_fk FOREIGN KEY (answer_sequence_id)
REFERENCES answers_sequence (answer_sequence_id);

-- Reference: question_answer_sequence (table: answers_sequence)
ALTER TABLE answers_sequence ADD CONSTRAINT questions_answers_sequence_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_answer_simple (table: answers_simple)
ALTER TABLE answers_simple ADD CONSTRAINT questions_answers_simple_fk FOREIGN KEY (question_id)
REFERENCES questions (question_id);

-- Reference: question_answer_space (table: answers_number)
ALTER TABLE answers_number ADD CONSTRAINT questions_answers_space_fk FOREIGN KEY (question_id)
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