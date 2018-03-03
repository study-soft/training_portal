package com.company.training_portal.dao.impl;

import com.company.training_portal.dao.UserDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

@Repository
public abstract class UserDaoJdbc implements UserDao {

    private JdbcTemplate jdbcTemplate;

    @Autowired
    public UserDaoJdbc(DataSource dataSource) {
        jdbcTemplate = new JdbcTemplate(dataSource);
    }
}
