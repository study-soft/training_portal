package com.company.training_portal.dao.impl;

import com.company.training_portal.config.AppConfig;
import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.model.Group;
import org.hamcrest.CoreMatchers;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import java.time.LocalDate;
import java.util.*;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.*;

@RunWith(SpringRunner.class)
@ContextConfiguration(classes = AppConfig.class)
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

        Group group = groupDao.findGroupByGroupId(1L);

        assertEquals(testGroup, group);
    }

    @Test
    public void test_find_groups_by_authorId() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroupByGroupId(1L));

        List<Group> groups = groupDao.findGroupsByAuthorId(1L);

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_all_groups() {
        List<Group> testGroups = new ArrayList<>();
        testGroups.add(groupDao.findGroupByGroupId(1L));
        testGroups.add(groupDao.findGroupByGroupId(2L));

        List<Group> groups = groupDao.findAllGroups();

        assertEquals(testGroups, groups);
    }

    @Test
    public void test_find_groups_number_by_authorId() {
        Integer groupsNumber = groupDao.findGroupsNumberByAuthorId(1L);
        assertThat(groupsNumber, is(1));
    }

    @Test
    public void test_find_all_groups_and_students_number_in_them() {
        Map<Group, Integer> testGroups = new HashMap<>();
        testGroups.put(groupDao.findGroupByGroupId(1L), 2);
        testGroups.put(groupDao.findGroupByGroupId(2L), 2);

        Map<Group, Integer> groups = groupDao.findAllGroupsAndStudentsNumberInThem();

        assertEquals(testGroups, groups);
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

        Group group = groupDao.findGroupByGroupId(testGroupId);

        assertEquals(testGroup, group);
    }

    @Test
    public void edit_group() {

    }

    @Test(expected = DataIntegrityViolationException.class)
    public void delete_group() {
        groupDao.deleteGroup(1L);
        groupDao.findGroupByGroupId(1L);
    }
}