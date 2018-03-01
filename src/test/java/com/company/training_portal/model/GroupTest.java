package com.company.training_portal.model;

import org.junit.Before;
import org.junit.Test;

import java.time.LocalDate;

import static org.junit.Assert.*;

public class GroupTest {

    private Group group;

    @Before
    public void setUp() {
        group = new Group.GroupBuilder().build();
        group.setGroupId(1L);
        group.setName("name");
        group.setDescription("description");
        group.setCreationDate(LocalDate.of(2018, 3, 1));
    }

    @Test
    public void test_group_builder() {
        Group groupBuild = new Group.GroupBuilder()
                .groupId(1L)
                .name("name")
                .description("description")
                .creationDate(LocalDate.of(2018, 3, 1))
                .build();
        assertEquals(group, groupBuild);
    }
}