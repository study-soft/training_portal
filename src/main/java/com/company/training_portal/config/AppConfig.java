package com.company.training_portal.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseBuilder;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.Properties;

@Configuration
@ComponentScan(basePackages = "com.company.training_portal")
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

    @Bean(destroyMethod = "close")
    public HikariDataSource dataSource() {
        HikariConfig config = new HikariConfig();
        config.setDriverClassName(environment.getRequiredProperty("jdbc.driverClass"));
        config.setJdbcUrl(environment.getRequiredProperty("jdbc.jdbcUrl"));
        config.setUsername(environment.getRequiredProperty("jdbc.username"));
        config.setPassword(environment.getRequiredProperty("jdbc.password"));
        return new HikariDataSource(config);
    }

//    @Bean
//    public DataSource dataSource() {
//        URI dbUri = null;
//        try {
//            Class.forName("org.postgresql.Driver");
//            dbUri = new URI(System.getenv("DATABASE_URL"));
//        } catch (ClassNotFoundException | URISyntaxException e) {
//            e.printStackTrace();
//        }
//
//        String username = dbUri.getUserInfo().split(":")[0];
//        String password = dbUri.getUserInfo().split(":")[1];
//        String dbUrl = "jdbc:postgresql://" + dbUri.getHost() + ':' +
//                dbUri.getPort() + dbUri.getPath() + "?sslmode=require";
//
//        BoneCPDataSource dataSource = new BoneCPDataSource();
//        dataSource.setJdbcUrl(dbUrl);
//        dataSource.setUsername(username);
//        dataSource.setPassword(password);
//
//        return dataSource;
//    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(dataSource());
        return transactionManager;
    }
}
