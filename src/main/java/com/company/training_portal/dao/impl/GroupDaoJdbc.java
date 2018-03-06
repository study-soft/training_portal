package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.GroupDao;
import com.company.training_portal.model.Group;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.util.List;
import java.util.Map;

@Repository
public class GroupDaoJdbc implements GroupDao {

    private JdbcTemplate template;

    @Autowired
    public GroupDaoJdbc(DataSource dataSource) {
        template = new JdbcTemplate(dataSource);
    }

    @Override
    public Group findGroupByGroupId(Long groupId) {
        return null;
    }

    @Override
    public List<Group> findGroupsByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<String> findAllGroupNames() {
        return null;
    }

    @Override
    public List<String> findAllGroupNamesByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public List<Group> findAllGroups() {
        return null;
    }

    @Override
    public Integer findGroupsNumberByAuthorId(Long authorId) {
        return null;
    }

    @Override
    public Map<String, Integer> findAllGroupsAndStudentsNumberInThem() {
        return null;
    }

    @Override
    public Long addGroup(Group group) {
        return null;
    }

    @Override
    public void editGroup(Group group) {

    }

    @Override
    public void deleteGroup(Long groupId) {

    }
}
