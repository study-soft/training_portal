package com.company.training_portal.dao;

import com.company.training_portal.model.Group;

import java.util.List;
import java.util.Map;

public interface GroupDao {

    Group findGroupByGroupId(Long groupId);

    List<Group> findGroupsByAuthorId(Long authorId);

    List<Group> findAllGroups();

    Integer findGroupsNumberByAuthorId(Long authorId);

    //key: Group, value: numberOfStudents
    Map<Group, Integer> findAllGroupsAndStudentsNumberInThem();

    Long addGroup(Group group);

    //todo: make user cases of editGroup(Group group)
    void editGroup(Group group);

    void deleteGroup(Long groupId);
}