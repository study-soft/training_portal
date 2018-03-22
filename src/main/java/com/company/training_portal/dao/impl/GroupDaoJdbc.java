package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.dao.UserDao;
import com.company.training_portal.model.Group;
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
        Map<Group, Integer> results = new HashMap<>();
        template.query(FIND_ALL_GROUPS_AND_STUDENTS_NUMBER_IN_THEM,
                new ResultSetExtractor<Map<Group, Integer>>() {
                    @Override
                    public Map<Group, Integer> extractData(ResultSet rs) throws SQLException, DataAccessException {
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

    private static final String FIND_ALL_GROUPS = "SELECT * FROM GROUPS;";

    private static final String FIND_GROUPS_NUMBER_BY_AUTHOR_ID =
    "SELECT COUNT(GROUP_ID) FROM GROUPS WHERE AUTHOR_ID = ?;";

    private static final String FIND_STUDENTS_NUMBER_IN_GROUP =
    "SELECT COUNT(USER_ID) FROM USERS WHERE GROUP_ID IS ?;";

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