package com.studysoft.trainingportal.service;

import com.studysoft.trainingportal.dao.UserDao;
import com.studysoft.trainingportal.model.SecurityUser;
import com.studysoft.trainingportal.model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private UserDao userDao;

    @Autowired
    public CustomUserDetailsService(UserDao userDao) {
        this.userDao = userDao;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = userDao.findUserByLogin(username);
        if (user == null) {
            throw new UsernameNotFoundException(username);
        }
        return new SecurityUser(user.getLogin(), user.getPassword(), true,
                true, true, true,
                AuthorityUtils.createAuthorityList("ROLE_" + user.getUserRole().getRole()), user.getUserId());
    }
}
