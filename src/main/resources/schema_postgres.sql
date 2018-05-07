-- tables
-- Table: answers_accordance
DROP TABLE IF EXISTS answers_accordance CASCADE ;
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
DROP TABLE IF EXISTS answers_number CASCADE ;
CREATE TABLE answers_number (
  question_id BIGINT PRIMARY KEY ,
  correct int NOT NULL
);

-- Table: answers_sequence
DROP TABLE IF EXISTS answers_sequence CASCADE ;
CREATE TABLE answers_sequence (
  question_id BIGINT PRIMARY KEY,
  item_1 VARCHAR(255) NOT NULL,
  item_2 VARCHAR(255) NOT NULL,
  item_3 VARCHAR(255) NOT NULL,
  item_4 VARCHAR(255) NOT NULL
);

-- Table: answers_simple
DROP TABLE IF EXISTS answers_simple CASCADE ;
CREATE TABLE answers_simple (
  answer_simple_id BIGSERIAL PRIMARY KEY,
  question_id bigint NOT NULL,
  body varchar(255) NOT NULL,
  correct BOOLEAN NOT NULL
);

-- Table: groups
DROP TABLE IF EXISTS groups CASCADE ;
CREATE TABLE groups (
  group_id BIGSERIAL PRIMARY KEY,
  name varchar(255) UNIQUE NOT NULL,
  description VARCHAR(65535) NULL,
  creation_date DATE NOT NULL,
  author_id BIGINT NOT NULL
);

-- Table: questions
DROP TABLE IF EXISTS questions CASCADE ;
CREATE TABLE questions (
  question_id BIGSERIAL PRIMARY KEY,
  quiz_id bigint NOT NULL,
  body VARCHAR(65535) NOT NULL,
  explanation VARCHAR(65535) NULL,
  question_type varchar(255) NOT NULL,
  score int NOT NULL
);

-- Table: quizzes
DROP TABLE IF EXISTS quizzes CASCADE ;
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
DROP TABLE IF EXISTS users CASCADE ;
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