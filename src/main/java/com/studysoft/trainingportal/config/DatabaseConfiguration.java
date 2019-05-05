package com.studysoft.trainingportal.config;

import com.jolbox.bonecp.BoneCPDataSource;
import com.studysoft.trainingportal.controller.TeacherGroupController;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;

@EnableTransactionManagement
@Configuration
public class DatabaseConfiguration {

    private static final Logger log = Logger.getLogger(TeacherGroupController.class);

    @Autowired
    private Environment env;

    @Bean(destroyMethod = "close")
    public BoneCPDataSource dataSource() {
        URI dbUri = null;
        try {
            Class.forName(env.getRequiredProperty("database.driver-class-name"));
            dbUri = new URI(env.getRequiredProperty("database.url"));
        } catch (ClassNotFoundException | URISyntaxException e) {
            e.printStackTrace();
        }

        String username = dbUri.getUserInfo().split(":")[0];
        String password = dbUri.getUserInfo().split(":")[1];
        String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' +
                dbUri.getPort() + dbUri.getPath() + "?" +
                (env.getRequiredProperty("spring.profiles.active").contains(Constants.SPRING_PROFILE_PROD) ? "sslmode=require" : "");

        log.debug("database url: " + dbUrl);

        BoneCPDataSource dataSource = new BoneCPDataSource();
        dataSource.setJdbcUrl(dbUrl);
        dataSource.setUsername(username);
        dataSource.setPassword(password);

        return dataSource;
    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource());
        return transactionManager;
    }
}
