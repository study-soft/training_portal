package com.company.training_portal.config;

import com.company.training_portal.config.test.TestDaoConfig;
import com.jolbox.bonecp.BoneCPDataSource;
import org.springframework.context.annotation.*;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@ComponentScan(basePackages = "com.company.training_portal",
        excludeFilters = @ComponentScan.Filter(type = FilterType.ASSIGNABLE_TYPE,
                classes = TestDaoConfig.class))
@EnableTransactionManagement
public class AppConfig {

    @Bean
    public DataSource boneCPDataSource() {
        BoneCPDataSource dataSource = new BoneCPDataSource();
        dataSource.setDriverClass("com.mysql.jdbc.Driver");
        dataSource.setJdbcUrl("jdbc:mysql://127.0.0.1:3306/training_portal_db");
        dataSource.setUsername("root");
        dataSource.setPassword("root");
        return dataSource;
    }

//    @Bean
//    public DataSource h2DataSource() {
//        return new EmbeddedDatabaseBuilder()
//                .setType(EmbeddedDatabaseType.H2)
//                .build();
//    }

    @Bean
    public PlatformTransactionManager transactionManager() {
        DataSourceTransactionManager transactionManager = new DataSourceTransactionManager();
        transactionManager.setDataSource(boneCPDataSource());
        return transactionManager;
    }
}
