package com.studysoft.trainingportal.config;

import com.jolbox.bonecp.BoneCPDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.*;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Arrays;

@Configuration
@ComponentScan(basePackages = "com.studysoft.trainingportal")
@EnableTransactionManagement
@PropertySource("classpath:db.properties")
public class AppConfig {

    @Autowired
    private Environment env;

//    @Bean
//    public DataSource dataSource() {
//        return new EmbeddedDatabaseBuilder()
//                .setType(EmbeddedDatabaseType.H2)
//                .addScript("schema_mysql.sql")
//                .addScript("test-data.sql")
//                .build();
//    }

    @Bean
    @Profile("dev")
    public DataSource localDataSource() {
        BoneCPDataSource dataSource = new BoneCPDataSource();
        dataSource.setDriverClass(env.getProperty("jdbc.driverClass"));
        dataSource.setJdbcUrl(env.getProperty("jdbc.jdbcUrl"));
        dataSource.setUsername(env.getProperty("jdbc.username"));
        dataSource.setPassword(env.getProperty("jdbc.password"));
        return dataSource;
    }

    @Bean
    @Profile("dev")
    public PlatformTransactionManager devTransactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(localDataSource());
        return transactionManager;
    }

    @Bean(destroyMethod = "close")
    @Profile("prod")
    public BoneCPDataSource herokuDataSource() {
        URI dbUri = null;
        try {
            Class.forName("org.postgresql.Driver");
            dbUri = new URI(System.getenv("DATABASE_URL"));
        } catch (ClassNotFoundException | URISyntaxException e) {
            e.printStackTrace();
        }

        String username = dbUri.getUserInfo().split(":")[0];
        String password = dbUri.getUserInfo().split(":")[1];
        String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' +
                dbUri.getPort() + dbUri.getPath() + "?sslmode=require";

        BoneCPDataSource dataSource = new BoneCPDataSource();
        dataSource.setJdbcUrl(dbUrl);
        dataSource.setUsername(username);
        dataSource.setPassword(password);

        return dataSource;
    }

    @Bean
    @Profile("prod")
    public PlatformTransactionManager prodTransactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(herokuDataSource());
        return transactionManager;
    }
}