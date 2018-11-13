package com.studysoft.trainingportal.dao;

import com.studysoft.trainingportal.model.Group;

import java.util.List;
import java.util.Map;

public interface GroupDao {

    Group findGroup(Long groupId);

    List<Group> findGroups(Long authorId);

    List<Group> findGroupsWhichTeacherGaveQuiz(Long teacherId);

    List<Group> findGroupsForQuizPublication(Long quizId);

    List<Group> findGroupsForWhichPublished(Long quizId);

    // No usages
    List<Group> findAllGroups();

    List<Long> findTeacherGroupIds(Long teacherId);

    // No usages
    Integer findGroupsNumber(Long authorId);

    Integer findStudentsNumberInGroup(Long groupId);

    // No usages
    //key: Group, value: numberOfStudents
    Map<Group, Integer> findAllGroupsAndStudentsNumberInThem();

    boolean groupExists(String groupName);

    Long addGroup(Group group);

    void editGroup(Group group);

    void deleteGroup(Long groupId);
}