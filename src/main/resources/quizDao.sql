-- FIND_QUIZ_BY_QUIZ_ID
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  CASE WHEN EXISTS(SELECT * FROM QUESTIONS WHERE QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID)
    THEN SUM(QUESTIONS.SCORE) ELSE 0 END AS SCORE,
  CASE WHEN EXISTS(SELECT * FROM QUESTIONS WHERE QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID)
    THEN COUNT(QUESTIONS.QUESTION_ID) ELSE 0 END AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES LEFT JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE QUIZZES.QUIZ_ID = ?
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_QUIZ_NAME_IF_EXISTS
SELECT NAME FROM QUIZZES WHERE QUIZZES.NAME = ?;

-- FIND_ALL_QUIZZES_WITH_QUESTIONS
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID
SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_UNPUBLISHED_QUIZZES_WITH_QUESTIONS_BY_AUTHOR_ID
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE QUIZZES.AUTHOR_ID = ? AND QUIZZES.TEACHER_QUIZ_STATUS = 'UNPUBLISHED'
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_UNPUBLISHED_QUIZZES_WITHOUT_QUESTIONS_BY_AUTHOR_ID
SELECT *, 0 AS SCORE, 0 AS QUESTIONS_NUMBER FROM QUIZZES
WHERE AUTHOR_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED'
AND NOT EXISTS(SELECT * FROM QUESTIONS WHERE QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID);

-- FIND_PUBLISHED_QUIZZES_BY_AUTHOR_ID
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE QUIZZES.AUTHOR_ID = ? AND QUIZZES.TEACHER_QUIZ_STATUS = 'PUBLISHED'
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_PUBLISHED_QUIZZES_BY_GROUP_ID_AND_TEACHER_ID
SELECT DISTINCT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS_NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
  INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
  INNER JOIN USERS ON J.USER_ID = USERS.USER_ID
WHERE USERS.GROUP_ID = ? AND QUIZZES.AUTHOR_ID = ?
GROUP BY USERS.USER_ID, QUIZZES.QUIZ_ID
ORDER BY QUIZZES.NAME;

-- FIND_QUIZZES_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ?
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_QUIZZES_NUMBER_BY_AUTHOR_ID
SELECT COUNT(QUIZ_ID) FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_STUDENTS_NUMBER_WITH_STUDENT_QUIZ_STATUS_BY_AUTHOR_ID_AND_GROUP_ID_AND_QUIZ_ID
SELECT J.STUDENT_QUIZ_STATUS, COUNT(J.USER_ID)
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
INNER JOIN USERS ON J.USER_ID = USERS.USER_ID
WHERE AUTHOR_ID = ? AND USERS.GROUP_ID = ? AND QUIZZES.QUIZ_ID = ?
GROUP BY J.STUDENT_QUIZ_STATUS;

-- FIND_QUIZZES_NUMBER_BY_AUTHOR_ID_WITH_TEACHER_QUIZ_STATUS
SELECT TEACHER_QUIZ_STATUS, COUNT(QUIZ_ID)
FROM QUIZZES WHERE AUTHOR_ID = ? GROUP BY TEACHER_QUIZ_STATUS;

-- FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID
SELECT QUIZZES.QUIZ_ID AS QUIZ_ID, QUIZZES.NAME AS NAME, QUIZZES.DESCRIPTION AS DESCRIPTION,
  QUIZZES.EXPLANATION AS EXPLANATION, QUIZZES.CREATION_DATE AS CREATION_DATE,
  QUIZZES.PASSING_TIME AS PASSING_TIME, QUIZZES.AUTHOR_ID AS AUTHOR_ID,
  SUM(QUESTIONS.SCORE) AS SCORE, COUNT(QUESTIONS.QUESTION_ID) AS QUESTIONS_NUMBER,
  QUIZZES.TEACHER_QUIZ_STATUS AS TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ?
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_COMMON_QUIZ_IDS_FOR_TWO_STUDENTS
SELECT QUIZZES_1.QUIZ_ID
FROM QUIZZES QUIZZES_1 INNER JOIN USER_QUIZ_JUNCTIONS J_1 ON QUIZZES_1.QUIZ_ID = J_1.QUIZ_ID,
  QUIZZES QUIZZES_2 INNER JOIN USER_QUIZ_JUNCTIONS J_2 ON QUIZZES_2.QUIZ_ID = J_2.QUIZ_ID
WHERE J_1.USER_ID = ? AND J_2.USER_ID = ? AND QUIZZES_1.QUIZ_ID = QUIZZES_2.QUIZ_ID;

-- FIND_RESULT_BY_STUDENT_ID_AND_QUIZ_ID
SELECT RESULT FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_SUBMIT_DATE_BY_STUDENT_ID_AND_QUIZ_ID
SELECT SUBMIT_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID
SELECT START_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_FINISH_DATE_BY_STUDENT_ID_AND_QUIZ_ID
SELECT FINISH_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_ATTEMPT_BY_STUDENT_ID_AND_QUIZ_ID
SELECT ATTEMPT FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_STUDENT_QUIZ_STATUS_BY_STUDENT_ID_AND_QUIZ_ID
SELECT STUDENT_QUIZ_STATUS FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_CLOSING_DATE_BY_GROUP_ID_AND_QUIZ_ID
SELECT MAX(J.FINISH_DATE)
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
WHERE USERS.GROUP_ID = ? AND J.QUIZ_ID = ?;

-- FIND_OPENED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id,
  COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score,
  J.SUBMIT_DATE AS submit_date
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED'
GROUP BY QUIZZES.QUIZ_ID;

-- FIND_PASSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED';

-- FIND_CLOSED_QUIZ_BY_STUDENT_ID_AND_QUIZ_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED';

-- FIND_OPENED_QUIZZES_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id,
  COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score,
  J.SUBMIT_DATE AS submit_date
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED'
GROUP BY QUIZZES.NAME
ORDER BY J.SUBMIT_DATE DESC;

-- FIND_PASSED_QUIZZES_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- FIND_CLOSED_QUIZZES_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- FIND_OPENED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.PASSING_TIME AS passing_time, QUIZZES.AUTHOR_ID AS author_id,
  COUNT(QUESTIONS.QUESTION_ID) AS questions_number, SUM(QUESTIONS.SCORE) AS score,
  J.SUBMIT_DATE AS submit_date
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED'
GROUP BY QUIZZES.NAME
ORDER BY J.SUBMIT_DATE DESC;

-- FIND_PASSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- FIND_CLOSED_QUIZZES_BY_STUDENT_ID_AND_TEACHER_ID
SELECT QUIZZES.QUIZ_ID AS quiz_id, QUIZZES.NAME AS quiz_name, QUIZZES.DESCRIPTION AS description,
  QUIZZES.EXPLANATION AS explanation, QUIZZES.AUTHOR_ID AS author_id,
  J.RESULT AS result, SUM(QUESTIONS.SCORE) AS score, COUNT(QUESTIONS.QUESTION_ID) AS questions_number,
  J.ATTEMPT AS attempt, QUIZZES.PASSING_TIME AS passing_time, J.SUBMIT_DATE AS submit_date,
  J.FINISH_DATE AS finish_date, DATEDIFF('SECOND', J.START_DATE, J.FINISH_DATE) AS time_spent
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ? AND J.STUDENT_QUIZ_STATUS = 'CLOSED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- ADD_PUBLISHED_QUIZ_INFO (studentId, quizId, submitDate, attempt, studentQuizStatus)
INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, SUBMIT_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (?, ?, ?, ?, ?);

-- ADD_QUIZ
INSERT INTO QUIZZES (NAME, DESCRIPTION, EXPLANATION, CREATION_DATE, PASSING_TIME, AUTHOR_ID, TEACHER_QUIZ_STATUS)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- EDIT_START_DATE_BY_STUDENT_ID_AND_QUIZ_ID
UPDATE USER_QUIZ_JUNCTIONS SET START_DATE = ? WHERE USER_ID = ? AND QUIZ_ID = ?;

-- EDIT_STUDENT_INFO_ABOUT_OPENED_QUIZ
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = ?, FINISH_DATE = ?, ATTEMPT = ?, STUDENT_QUIZ_STATUS = ?
WHERE USER_ID = ? AND QUIZ_ID = ?;

-- EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID
UPDATE QUIZZES SET TEACHER_QUIZ_STATUS = ? WHERE QUIZ_ID = ?;

-- EDIT_QUIZ_BY_QUIZ_ID_NAME_DESCRIPTION_EXPLANATION_PASSING_TIME
UPDATE QUIZZES
SET NAME = ?, DESCRIPTION = ?, EXPLANATION = ?, PASSING_TIME = ?
WHERE QUIZ_ID = ?;

-- EDIT_STUDENTS_INFO_WITH_OPENED_QUIZ_STATUS
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = 0, START_DATE = ?, FINISH_DATE = ?, ATTEMPT = 0, STUDENT_QUIZ_STATUS = 'CLOSED'
WHERE USER_ID IN (SELECT USERS.USER_ID
                  FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
                  WHERE GROUP_ID = ?)
      AND QUIZ_ID = ? AND STUDENT_QUIZ_STATUS = 'OPENED';

-- CLOSE_QUIZ_TO_STUDENT
UPDATE USER_QUIZ_JUNCTIONS
SET STUDENT_QUIZ_STATUS = 'CLOSED'
WHERE USER_ID = ? AND QUIZ_ID = ?;

-- CLOSE_QUIZ_TO_GROUP
UPDATE USER_QUIZ_JUNCTIONS
SET STUDENT_QUIZ_STATUS = 'CLOSED'
WHERE USER_ID IN (SELECT USER_ID FROM USERS WHERE GROUP_ID = ?) AND QUIZ_ID = ?
  AND STUDENT_QUIZ_STATUS IN ('OPENED', 'PASSED');

-- CLOSE_QUIZ_TO_ALL_BY_TEACHER_ID
UPDATE USER_QUIZ_JUNCTIONS J
SET STUDENT_QUIZ_STATUS = 'CLOSED'
WHERE J.QUIZ_ID IN (SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?)
  AND STUDENT_QUIZ_STATUS IN ('OPENED', 'PASSED');

-- DELETE_UNPUBLISHED_QUIZ
DELETE FROM QUIZZES WHERE QUIZ_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED';

-- DELETE_STUDENTS_INFO_ABOUT_QUIZ
DELETE FROM USER_QUIZ_JUNCTIONS WHERE QUIZ_ID = ?;