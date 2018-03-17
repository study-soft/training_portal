-- FIND_USER_BY_USER_ID
SELECT * FROM USERS WHERE USER_ID = ?;

-- FIND_USER_BY_LOGIN
SELECT * FROM USERS WHERE LOGIN = ?;

-- FIND_USER_BY_EMAIL
SELECT * FROM USERS WHERE EMAIL = ?;

-- FIND_USER_BY_PHONE_NUMBER
SELECT * FROM USERS WHERE PHONE_NUMBER = ?;

-- FIND_USER_NAME_BY_USER_ID
SELECT FIRST_NAME, LAST_NAME FROM USERS WHERE USER_ID = ?;

-- FIND_USER_BY_FIRST_NAME_AND_LAST_NAME_AND_USER_ROLE
SELECT * FROM USERS WHERE FIRST_NAME = ? AND LAST_NAME = ? AND USER_ROLE;

-- FIND_STUDENTS_BY_GROUP_ID (groupId)
SELECT *
FROM USERS
WHERE GROUP_ID IS ? AND USER_ROLE = 'STUDENT'
ORDER BY LAST_NAME;

-- FIND_ALL_STUDENTS
SELECT * FROM USERS WHERE USER_ROLE = 'STUDENT';

-- FIND_ALL_TEACHERS
SELECT * FROM USERS WHERE USER_ROLE = 'TEACHER';

-- FIND_STUDENT_IDS_BY_GROUP_ID_AND_QUIZ_ID (groupId, quizId)
SELECT USERS.USER_ID
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
WHERE USERS.USER_ROLE = 'STUDENT' AND USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;

-- FIND_STUDENTS_NUMBER
SELECT COUNT(USER_ID) FROM USERS WHERE USER_ROLE = 'STUDENT';

-- FIND_TEACHERS_NUMBER
SELECT COUNT(USER_ID) FROM USERS WHERE USER_ROLE = 'TEACHER';

-- FIND_STUDENTS_NUMBER_IN_GROUP_WITH_FINISHED_QUIZ (groupId, quizId)
SELECT COUNT(USERS.USER_ID)
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
WHERE USERS.USER_ROLE = 'STUDENT' AND USERS.GROUP_ID IS ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'FINISHED';

-- FIND_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID (groupId, quizId)
SELECT COUNT(J.RESULT)
FROM USER_QUIZ_JUNCTIONS J INNER JOIN USERS ON J.USER_ID = USERS.USER_ID
WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;

-- FIND_FINAL_RESULTS_NUMBER_BY_GROUP_ID_AND_QUIZ_ID (groupId, quizId)
SELECT COUNT(J.RESULT)
FROM USER_QUIZ_JUNCTIONS J INNER JOIN USERS ON J.USER_ID = USERS.USER_ID
WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ? AND J.STUDENT_QUIZ_STATUS = 'FINISHED';

-- FIND_STUDENT_IDS_WITHOUT_GROUP
SELECT USER_ID FROM USERS WHERE USER_ROLE = 'STUDENT' AND GROUP_ID IS NULL;

-- FIND_STUDENT_IDS_AND_RESULTS_BY_GROUP_ID_AND_QUIZ_ID
SELECT USERS.USER_ID, J.RESULT
FROM USERS INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID
WHERE USERS.GROUP_ID IS ? AND J.QUIZ_ID = ?;

-- FIND_USER_BY_LOGIN_AND_PASSWORD
SELECT * FROM USERS WHERE LOGIN = ? AND PASSWORD = ?;

-- REGISTER_USER (userId, groupId)
INSERT INTO USERS (GROUP_ID, FIRST_NAME, LAST_NAME, EMAIL, DATE_OF_BIRTH, PHONE_NUMBER, LOGIN, PASSWORD, USER_ROLE)
VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?);

-- ADD_STUDENT_TO_GROUP_BY_GROUP_ID_AND_USER_ID
UPDATE USERS
SET GROUP_ID = ?
WHERE USER_ID = ? AND USER_ROLE = 'STUDENT';

-- ADD_STUDENT_INFO_ABOUT_QUIZ
INSERT INTO USER_QUIZ_JUNCTIONS (USER_ID, QUIZ_ID, RESULT, SUBMIT_DATE, START_DATE, FINISH_DATE, ATTEMPT, STUDENT_QUIZ_STATUS)
VALUES (?, ?, ?, ?, ?, ?, 0, ?);

-- UPDATE_STUDENT_INFO_ABOUT_QUIZ
UPDATE USER_QUIZ_JUNCTIONS
SET RESULT = ?, START_DATE = ?, FINISH_DATE = ?, ATTEMPT = ?, STUDENT_QUIZ_STATUS = ?
WHERE USER_ID = ? AND QUIZ_ID = ?;

-- EDIT_USER
UPDATE USERS
SET FIRST_NAME = ?, LAST_NAME = ?, EMAIL = ?, DATE_OF_BIRTH = ?, PHONE_NUMBER = ?, PASSWORD = ?
WHERE USER_ID = ?;

-- DELETE_STUDENT_FROM_GROUP_BY_USER_ID
UPDATE USERS SET GROUP_ID = NULL WHERE USER_ID = ? AND USER_ROLE = 'STUDENT';

-- DELETE_STUDENTS_FROM_GROUP_BY_GROUP_ID
UPDATE USERS SET GROUP_ID = NULL WHERE GROUP_ID = ? AND USER_ROLE = 'STUDENT';