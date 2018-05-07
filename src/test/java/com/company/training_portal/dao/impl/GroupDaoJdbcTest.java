package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.model.Group;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.EmptyResultDataAccessException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import java.time.LocalDate;
import java.util.*;

import static org.hamcrest.CoreMatchers.is;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
@WebAppConfiguration
@Sql(executionPhase = Sql.ExecutionPhase.BEFORE_TEST_METHOD,
        scripts = {"classpath:schema_postgres.sql", "classpath:test-data.sql"})
public class GroupDaoJdbcTest {

    @Autowired
    private GroupDao groupDao;

    public void setGroupDao(GroupDao groupDao) {
        this.groupDao = groupDao;
    }

    @Test
    public void test_find_group_by_groupId() {
        Group testGroup = new Group.GroupBuilder()
                .groupId(1L)
                .name("IS-4")
                .description("Program engineering")
                .creationDate(LocalDate.of(2018, 3, 2))
                .authorId(1L)
                .build();

        Group group = groupDao.findGroup(1L);

        assertEquals(testGroup, group);
    }

    @Test
    public void test_find_groups_by_authorId() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroup(1L));

        List<Group> groups = groupDao.findGroups(1L);

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_groups_which_teacher_gave_quiz_by_teacher_id() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroup(2L));
        testGroups.add(groupDao.findGroup(1L));

        List<Group> groups = groupDao.findGroupsWhichTeacherGaveQuiz(1L);

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_groups_for_quiz_publication() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroup(2L));
        testGroups.add(groupDao.findGroup(3L));

        List<Group> groups = groupDao.findGroupsForQuizPublication(1L);

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_groups_for_which_published() {
        List<Group> testGroups = new ArrayList<>(0);
        testGroups.add(groupDao.findGroup(2L));
        testGroups.add(groupDao.findGroup(1L));

        List<Group> groups = groupDao.findGroupsForWhichPublished(3L);

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_all_groups() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroup(1L));
        testGroups.add(groupDao.findGroup(2L));

        List<Group> groups = groupDao.findAllGroups();

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_teacher_group_ids() {
        List<Long> testTeacherGroupIds = Arrays.asList(1L, 3L);
        List<Long> teacherGroupIds = groupDao.findTeacherGroupIds(1L);
        assertEquals(testTeacherGroupIds, teacherGroupIds);
    }

    @Test
    public void test_find_groups_number_by_authorId() {
        Integer groupsNumber = groupDao.findGroupsNumber(1L);
        assertThat(groupsNumber, is(1));
    }

    @Test
    public void test_find_students_number_in_group() {
        Integer studentsNumberInGroup = groupDao.findStudentsNumberInGroup(2L);
        assertThat(studentsNumberInGroup, is(2));
    }

    @Test
    public void test_find_all_groups_and_students_number_in_them() {
        Map<Group, Integer> testGroups = new HashMap<>();
        testGroups.put(groupDao.findGroup(1L), 2);
        testGroups.put(groupDao.findGroup(2L), 2);

        Map<Group, Integer> groups = groupDao.findAllGroupsAndStudentsNumberInThem();

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_group_exists_by_groupName() {
        assertTrue(groupDao.groupExists("IS-4"));
        assertFalse(groupDao.groupExists("Test group"));
    }

    @Test
    public void test_add_group() {
        Group testGroup = new Group.GroupBuilder()
                .name("Test-1")
                .description("description")
                .creationDate(LocalDate.of(2018, 3, 8))
                .authorId(1L)
                .build();

        Long testGroupId = groupDao.addGroup(testGroup);

        Group group = groupDao.findGroup(testGroupId);

        assertEquals(testGroup, group);
    }

    @Test
    public void edit_group() {
        Group testGroup = new Group.GroupBuilder()
                .groupId(1L)
                .name("testGroup")
                .description("testDescription")
                .creationDate(LocalDate.of(2000, 1, 1))
                .authorId(1L)
                .build();
        groupDao.editGroup(testGroup);

        Group group = groupDao.findGroup(1L);

        assertEquals(testGroup, group);
    }

    @Test(expected = EmptyResultDataAccessException.class)
    public void delete_group() {
        groupDao.deleteGroup(1L);
        groupDao.findGroup(1L);
    }
}