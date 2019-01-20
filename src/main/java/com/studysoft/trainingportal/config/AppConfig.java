package com.studysoft.trainingportal.config;

import com.jolbox.bonecp.BoneCPDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;

@Configuration
@ComponentScan(basePackages = "com.studysoft.trainingportal")
@EnableTransactionManagement
@PropertySource("classpath:db.properties")
public class AppConfig {

    @Autowired
    private Environment environment;

//    @Bean
//    public DataSource dataSource() {
//        return new EmbeddedDatabaseBuilder()
//                .setType(EmbeddedDatabaseType.H2)
//                .addScript("schema_mysql.sql")
//                .addScript("test-data.sql")
//                .build();
//    }

//    @Bean
//    public DataSource dataSource() {
//        BoneCPDataSource dataSource = new BoneCPDataSource();
//        dataSource.setDriverClass(environment.getProperty("jdbc.driverClass"));
//        dataSource.setJdbcUrl(environment.getProperty("jdbc.jdbcUrl"));
//        dataSource.setUsername(environment.getProperty("jdbc.username"));
//        dataSource.setPassword(environment.getProperty("jdbc.password"));
//        return dataSource;
//    }

    @Bean(destroyMethod = "close")
    public BoneCPDataSource dataSource() {
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
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource());
        return transactionManager;
    }
}