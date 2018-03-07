-- FIND_QUIZ_BY_QUIZ_ID
SELECT * FROM QUIZZES WHERE QUIZ_ID = ?;

-- FIND_ALL_QUIZZES
SELECT * FROM QUIZZES;

-- FIND_ALL_QUIZ_NAMES
SELECT QUIZZES.NAME FROM QUIZZES;

-- FIND_ALL_QUIZZES_BY_AUTHOR_ID
SELECT * FROM QUIZZES WHERE AUTHOR_ID = ?;

-- FIND_ALL_QUIZ_NAMES_BY_AUTHOR_ID
SELECT QUIZZES.NAME FROM QUIZZES WHERE AUTHOR_ID = ?;


-- FIND_ALL_QUIZ_NAMES_BY_STUDENT_ID
SELECT QUIZZES.NAME
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ?;

-- FIND_ALL_CLOSED_QUIZ_NAMES_BY_AUTHOR_ID
SELECT NAME FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'closed' AND AUTHOR_ID = ?;

-- FIND_ALL_NOT_PUBLISHED_QUIZZES_BY_AUTHOR_ID
SELECT * FROM QUIZZES WHERE TEACHER_QUIZ_STATUS = 'unpublished';

-- FIND_ALL_QUIZ_NAMES_BY_STUDENT_ID_AND_STUDENT_QUIZ_STATUS
SELECT QUIZZES.NAME
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
SELECT QUIZZES.NAME, J.RESULT
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ?;

-- FIND_QUIZ_NAMES_BY_STUDENT_ID_AND_REOPEN_COUNTER
SELECT QUIZZES.NAME
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ? AND J.REOPEN_COUNTER = ?;

-- FIND_QUIZ_NAMES_BY_STUDENT_ID_AND_AUTHOR_ID
SELECT QUIZZES.NAME
FROM QUIZZES INNER JOIN USER_QUIZ_JUNCTIONS J ON QUIZZES.QUIZ_ID = J.QUIZ_ID
WHERE J.USER_ID = ? AND QUIZZES.AUTHOR_ID = ?;

-- FIND_RESULT_BY_STUDENT_ID_AND_QUIZ_ID
SELECT RESULT FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_SUBMIT_DATE_BY_STUDENT_ID_AND_QUIZ_ID
SELECT SUBMIT_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_FINISH_DATE_BY_STUDENT_ID_AND_QUIZ_ID
SELECT FINISH_DATE FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_REOPEN_COUNTER_BY_STUDENT_ID_AND_QUIZ_ID
SELECT REOPEN_COUNTER FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

-- FIND_STUDENT_QUIZ_STATUS_BY_STUDENT_ID_AND_QUIZ_ID
SELECT STUDENT_QUIZ_STATUS FROM USER_QUIZ_JUNCTIONS WHERE USER_ID = ? AND QUIZ_ID = ?;

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

-- DELETE_QUIZ
DELETE FROM QUIZZES WHERE QUIZ_ID = ?;