package com.studysoft.trainingportal.dao.impl;

import com.studysoft.trainingportal.dao.GroupDao;
import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.Group;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementCreator;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import java.sql.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class GroupDaoJdbc implements GroupDao {

    private JdbcTemplate template;

    private UserDao userDao;

    private static final Logger logger = Logger.getLogger(GroupDaoJdbc.class);

    @Autowired
    public GroupDaoJdbc(DataSource dataSource, UserDao userDao) {
        template = new JdbcTemplate(dataSource);
        this.userDao = userDao;
    }

    @Transactional(readOnly = true)
    @Override
    public Group findGroup(Long groupId) {
        Group group = template.queryForObject(FIND_GROUP_BY_GROUP_ID,
                new Object[]{groupId}, this::mapGroup);
        logger.info("Group found by groupId: " + group);
        return group;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Group> findGroups(Long authorId) {
        List<Group> groups = template.query(FIND_GROUPS_BY_AUTHOR_ID,
                new Object[]{authorId}, this::mapGroup);
        logger.info("All groups by authorId found:");
        groups.forEach(logger::info);
        return groups;
    }

    @Override
    public List<Group> findGroupsWhichTeacherGaveQuiz(Long teacherId) {
        List<Group> groups = template.query(FIND_GROUPS_WITCH_TEACHER_GAVE_QUIZ,
                new Object[]{teacherId}, this::mapGroup);
        logger.info("Found groups which teacher send quiz:");
        groups.forEach(logger::info);
        return groups;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Group> findGroupsForQuizPublication(Long quizId) {
        List<Group> groups = template.query(FIND_GROUPS_FOR_QUIZ_PUBLICATION,
                new Object[]{quizId}, this::mapGroup);
        logger.info("Found groups for quiz publication by quizId = " + quizId + ":");
        groups.forEach(logger::info);
        return groups;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Group> findGroupsForWhichPublished(Long quizId) {
        List<Group> groups = template.query(FIND_GROUPS_FOR_WHICH_PUBLISHED_BY_QUIZ_ID,
                new Object[]{quizId}, this::mapGroup);
        logger.info("Found all groups for which published by quizId '" + quizId + "':");
        groups.forEach(logger::info);
        return groups;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Group> findAllGroups() {
        List<Group> groups = template.query(FIND_ALL_GROUPS, this::mapGroup);
        logger.info("All groups found:");
        groups.forEach(logger::info);
        return groups;
    }

    @Transactional(readOnly = true)
    @Override
    public List<Long> findTeacherGroupIds(Long teacherId) {
        List<Long> groupIds = template.queryForList(FIND_TEACHER_GROUP_IDS,
                new Object[]{teacherId}, Long.class);
        logger.info("Found teacher group ids by teacherId = " + teacherId + ": " + groupIds);
        return groupIds;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findGroupsNumber(Long authorId) {
        Integer groupsNumber = template.queryForObject(FIND_GROUPS_NUMBER_BY_AUTHOR_ID,
                new Object[]{authorId}, Integer.class);
        logger.info("Groups number by authorId found: " + groupsNumber);
        return groupsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Integer findStudentsNumberInGroup(Long groupId) {
        Integer studentsNumber = template.queryForObject(FIND_STUDENTS_NUMBER_IN_GROUP,
                new Object[]{groupId}, Integer.class);
        logger.info("Students number in group found: " + studentsNumber);
        return studentsNumber;
    }

    @Transactional(readOnly = true)
    @Override
    public Map<Group, Integer> findAllGroupsAndStudentsNumberInThem() {
        Map<Group, Integer> results = template.query(
                FIND_ALL_GROUPS_AND_STUDENTS_NUMBER_IN_THEM,
                new ResultSetExtractor<Map<Group, Integer>>() {
                    @Override
                    public Map<Group, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
                        Map<Group, Integer> results = new HashMap<>();
                        while (rs.next()) {
                            results.put(mapGroup(rs, 0), rs.getInt(6));
                        }
                        return results;
                    }
                });
        logger.info("All groups and students number in them found:");
        results.forEach((k, v) -> logger.info(k + " - " + v));
        return results;
    }

    @Transactional(readOnly = true)
    @Override
    public boolean groupExists(String groupName) {
        Group group = template.query(FIND_GROUP_BY_GROUP_NAME,
                new Object[]{groupName}, new ResultSetExtractor<Group>() {
                    @Override
                    public Group extractData(ResultSet rs) throws SQLException, DataAccessException {
                        if (!rs.next()) {
                            return null;
                        }
                        return mapGroup(rs, 0);
                    }
                });
        if (group == null) {
            logger.info("No group exists by groupName: " + groupName);
            return false;
        }
        logger.info("Group exists by groupName: " + groupName);
        return true;
    }

    @Transactional
    @Override
    public Long addGroup(Group group) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        template.update(new PreparedStatementCreator() {
            @Override
            public PreparedStatement createPreparedStatement(Connection con) throws SQLException {
                PreparedStatement stmt = con.prepareStatement(ADD_GROUP, new String[]{"group_id"});
                stmt.setString(1, group.getName());
                stmt.setString(2, group.getDescription());
                stmt.setDate(3, Date.valueOf(group.getCreationDate()));
                stmt.setLong(4, group.getAuthorId());
                return stmt;
            }
        }, keyHolder);
        long groupId = keyHolder.getKey().longValue();
        group.setGroupId(groupId);
        logger.info("Group added: " + group);
        return groupId;
    }

    @Override
    public void editGroup(Group group) {
        template.update(EDIT_GROUP, group.getName(), group.getDescription(),
                Date.valueOf(group.getCreationDate()), group.getAuthorId(), group.getGroupId());
        logger.info("Edited group: " + group);
    }

    @Transactional
    @Override
    public void deleteGroup(Long groupId) {
        userDao.deleteStudentsFromGroupByGroupId(groupId);
        template.update(DELETE_GROUP, groupId);
        logger.info("Deleted group with groupId: " + groupId);
    }

    private Group mapGroup(ResultSet rs, int rowNum) throws SQLException {
        return new Group.GroupBuilder()
                .groupId(rs.getLong("group_id"))
                .name(rs.getString("name"))
                .description(rs.getString("description"))
                .creationDate(rs.getDate("creation_date").toLocalDate())
                .authorId(rs.getLong("author_id"))
                .build();
    }

    private static final String FIND_GROUP_BY_GROUP_ID =
    "SELECT * FROM GROUPS WHERE GROUP_ID = ?;";

    private static final String FIND_GROUPS_BY_AUTHOR_ID =
    "SELECT * FROM GROUPS WHERE AUTHOR_ID = ?;";

    private static final String FIND_GROUPS_WITCH_TEACHER_GAVE_QUIZ =
    "SELECT GROUPS.GROUP_ID, GROUPS.NAME, GROUPS.DESCRIPTION, " +
    "GROUPS.CREATION_DATE, GROUPS.AUTHOR_ID " +
    "FROM GROUPS INNER JOIN USERS ON GROUPS.GROUP_ID = USERS.GROUP_ID " +
    "INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "INNER JOIN QUIZZES ON J.QUIZ_ID = QUIZZES.QUIZ_ID " +
    "WHERE QUIZZES.AUTHOR_ID = ? " +
    "GROUP BY GROUPS.GROUP_ID " +
    "ORDER BY GROUPS.NAME;";

    private static final String FIND_GROUPS_FOR_QUIZ_PUBLICATION =
    "SELECT GROUPS.GROUP_ID, GROUPS.NAME, GROUPS.DESCRIPTION, " +
    "GROUPS.CREATION_DATE, GROUPS.AUTHOR_ID " +
    "FROM GROUPS INNER JOIN USERS ON GROUPS.GROUP_ID = USERS.GROUP_ID " +
    "LEFT JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "WHERE USERS.USER_ID NOT IN (SELECT J.USER_ID FROM USER_QUIZ_JUNCTIONS J WHERE J.QUIZ_ID = ?) " +
    "GROUP BY GROUPS.GROUP_ID " +
    "ORDER BY GROUPS.NAME;";

    private static final String FIND_GROUPS_FOR_WHICH_PUBLISHED_BY_QUIZ_ID =
    "SELECT GROUPS.GROUP_ID, GROUPS.NAME, GROUPS.DESCRIPTION, " +
    "GROUPS.CREATION_DATE, GROUPS.AUTHOR_ID " +
    "FROM GROUPS INNER JOIN USERS ON GROUPS.GROUP_ID = USERS.GROUP_ID " +
    "INNER JOIN USER_QUIZ_JUNCTIONS J ON USERS.USER_ID = J.USER_ID " +
    "WHERE J.QUIZ_ID = ? " +
    "GROUP BY GROUPS.GROUP_ID " +
    "ORDER BY GROUPS.NAME;";

    private static final String FIND_ALL_GROUPS = "SELECT * FROM GROUPS;";

    private static final String FIND_TEACHER_GROUP_IDS =
    "SELECT GROUP_ID FROM GROUPS WHERE AUTHOR_ID = ?;";

    private static final String FIND_GROUPS_NUMBER_BY_AUTHOR_ID =
    "SELECT COUNT(GROUP_ID) FROM GROUPS WHERE AUTHOR_ID = ?;";

    private static final String FIND_STUDENTS_NUMBER_IN_GROUP =
    "SELECT COUNT(USER_ID) FROM USERS WHERE CASE WHEN GROUP_ID IS NULL THEN FALSE ELSE GROUP_ID = ? END;";

    private static final String FIND_ALL_GROUPS_AND_STUDENTS_NUMBER_IN_THEM =
    "SELECT GROUPS.GROUP_ID, GROUPS.NAME, GROUPS.DESCRIPTION, " +
            "GROUPS.CREATION_DATE, GROUPS.AUTHOR_ID, COUNT(USERS.USER_ID) " +
    "FROM USERS INNER JOIN GROUPS ON USERS.GROUP_ID = GROUPS.GROUP_ID " +
    "WHERE USERS.USER_ROLE = 'STUDENT' " +
    "GROUP BY GROUPS.NAME;";

    private static final String FIND_GROUP_BY_GROUP_NAME =
    "SELECT * FROM GROUPS WHERE NAME = ?;";

    private static final String ADD_GROUP =
    "INSERT INTO GROUPS (NAME, DESCRIPTION, CREATION_DATE, AUTHOR_ID) " +
    "VALUES (?, ?, ?, ?);";

    private static final String EDIT_GROUP =
    "UPDATE GROUPS " +
    "SET NAME = ?, DESCRIPTION = ?, CREATION_DATE = ?, AUTHOR_ID = ? " +
    "WHERE GROUP_ID = ?;";

    private static final String DELETE_GROUP = "DELETE FROM GROUPS WHERE GROUP_ID = ?;";
}