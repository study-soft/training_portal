package com.company.training_portal.dao;

import com.company.training_portal.model.Group;

import java.util.List;
import java.util.Map;

public interface GroupDao {

    Group findGroup(Long groupId);

    List<Group> findGroups(Long authorId);

    List<Group> findGroupsWhichTeacherGaveQuiz(Long teacherId);

    List<Group> findAllGroups();

    Integer findGroupsNumber(Long authorId);

    Integer findStudentsNumberInGroup(Long groupId);

    //key: Group, value: numberOfStudents
    Map<Group, Integer> findAllGroupsAndStudentsNumberInThem();

    boolean groupExists(String groupName);

    Long addGroup(Group group);

    void editGroup(Group group);

    void deleteGroup(Long groupId);
}