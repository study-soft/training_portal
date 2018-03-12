-- FIND_QUIZ_BY_QUIZ_ID
SELECT * FROM QUIZZES WHERE QUIZ_ID = ?;

-- FIND_ALL_QUIZZES
SELECT * FROM QUIZZES;

-- FIND_ALL_QUIZ_IDS
SELECT QUIZ_ID FROM QUIZZES;

-- FIND_ALL_QUIZZES_BY_AUTHOR_ID
SELECT * FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_ALL_QUIZ_IDS_BY_AUTHOR_ID
SELECT QUIZ_ID FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_QUIZZES_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.DESCRIPTION, QUIZZES.EXPLANATION,
QUIZZES.CREATION_DATE, QUIZZES.PASSING_TIME, QUIZZES.AUTHOR_ID, QUIZZES.TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ?;

-- FIND_ALL_CLOSED_QUIZ_IDS_BY_AUTHOR_ID
SELECT QUIZ_ID FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'CLOSED' AND AUTHOR_ID = ?;

-- FIND_ALL_NOT_PUBLISHED_QUIZ_IDS_BY_AUTHOR_ID
SELECT QUIZ_ID FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'UNPUBLISHED' AND AUTHOR_ID = ?;

-- FIND_ALL_QUIZ_IDS_BY_STUDENT_ID_AND_STUDENT_QUIZ_STATUS
SELECT QUIZZES.QUIZ_ID
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ? AND STUDENT_QUIZ_STATUS = ?;

-- FIND_QUIZZES_NUMBER_BY_AUTHOR_ID
SELECT COUNT(QUIZ_ID) FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_STUDENTS_NUMBER_BY_AUTHOR_ID_AND_GROUP_ID_AND_QUIZ_ID_WITH_STUDENT_QUIZ_STATUS
SELECT J.STUDENT_QUIZ_STATUS, COUNT(J.USER_ID)
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
INNER JOIN USERS ON J.USER_ID = USERS.USER_ID
WHERE AUTHOR_ID = ? AND USERS.GROUP_ID = ? AND QUIZZES.QUIZ_ID = ?
GROUP BY J.STUDENT_QUIZ_STATUS;

-- FIND_QUIZZES_NUMBER_BY_AUTHOR_ID_WITH_TEACHER_QUIZ_STATUS
SELECT TEACHER_QUIZ_STATUS, COUNT(QUIZ_ID)
FROM QUIZZES WHERE AUTHOR_ID = ? GROUP BY TEACHER_QUIZ_STATUS;

-- FIND_ALL_STUDENT_RESULTS (userId)
SELECT QUIZZES.QUIZ_ID, J.RESULT
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ?;

-- FIND_QUIZ_IDS_BY_STUDENT_ID_AND_ATTEMPT
SELECT QUIZZES.QUIZ_ID
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ? AND J.ATTEMPT = ?;

-- FIND_QUIZZES_BY_STUDENT_ID_AND_AUTHOR_ID
SELECT QUIZZES.QUIZ_ID, QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.DESCRIPTION, QUIZZES.EXPLANATION,
            QUIZZES.CREATION_DATE, QUIZZES.PASSING_TIME, QUIZZES.AUTHOR_ID, QUIZZES.TEACHER_QUIZ_STATUS
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ?;

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

-- FIND_OPENED_QUIZZES_INFO_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.AUTHOR_ID,
  COUNT(QUESTIONS.QUESTION_ID), SUM(QUESTIONS.SCORE), J.SUBMIT_DATE
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'OPENED'
GROUP BY QUIZZES.NAME
ORDER BY J.SUBMIT_DATE DESC;

-- FIND_PASSED_QUIZZES_INFO_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.AUTHOR_ID, J.RESULT,
  SUM(QUESTIONS.SCORE), J.ATTEMPT, J.FINISH_DATE,
  DATEDIFF('MINUTE', J.START_DATE, J.FINISH_DATE)
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'PASSED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- FIND_FINISHED_QUIZZES_INFO_BY_STUDENT_ID
SELECT QUIZZES.QUIZ_ID, QUIZZES.NAME, QUIZZES.AUTHOR_ID, J.RESULT,
  SUM(QUESTIONS.SCORE), J.ATTEMPT, J.FINISH_DATE,
  DATEDIFF('MINUTE', J.START_DATE, J.FINISH_DATE)
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
  INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID
  INNER JOIN QUESTIONS ON QUIZZES.QUIZ_ID = QUESTIONS.QUIZ_ID
WHERE J.USER_ID = ? AND J.STUDENT_QUIZ_STATUS = 'FINISHED'
GROUP BY QUIZZES.NAME
ORDER BY J.FINISH_DATE DESC;

-- ADD_QUIZ
INSERT INTO QUIZZES (NAME, DESCRIPTION, EXPLANATION, CREATION_DATE, PASSING_TIME, AUTHOR_ID, TEACHER_QUIZ_STATUS)
VALUES (?, ?, ?, ?, ?, ?, ?);

-- EDIT_TEACHER_QUIZ_STATUS_BY_QUIZ_ID
UPDATE QUIZZES SET TEACHER_QUIZ_STATUS = ? WHERE QUIZ_ID = ?;

-- TODO: CREATE MORE UPDATE QUERIES
-- EDIT_QUIZ
UPDATE QUIZZES
SET NAME = ?, DESCRIPTION = ?, EXPLANATION = ?, CREATION_DATE = ?, PASSING_TIME = ?, AUTHOR_ID = ?, TEACHER_QUIZ_STATUS = ?
WHERE QUIZ_ID = ?;

-- DELETE_UNPUBLISHED_QUIZ
DELETE FROM QUIZZES WHERE QUIZ_ID = ? AND TEACHER_QUIZ_STATUS = 'UNPUBLISHED';