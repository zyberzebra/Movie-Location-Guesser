package com.movielocguess.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.jdbc.datasource.init.DatabasePopulator;
import org.springframework.jdbc.datasource.init.DatabasePopulatorUtils;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;

import javax.sql.DataSource;
import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class SQLiteConfig {

    @Bean
    public DataSource dataSource() {
        // Get the application's directory
        Path dbPath = Paths.get(System.getProperty("user.dir"), "data", "moviedb.sqlite");
        
        // Create parent directories if they don't exist
        dbPath.getParent().toFile().mkdirs();
        
        DriverManagerDataSource dataSource = new DriverManagerDataSource();
        dataSource.setDriverClassName("org.sqlite.JDBC");
        dataSource.setUrl("jdbc:sqlite:" + dbPath.toString());
        
        // Initialize the database with our SQL script
        DatabasePopulator populator = new ResourceDatabasePopulator(new ClassPathResource("data.sql"));
        DatabasePopulatorUtils.execute(populator, dataSource);
        
        return dataSource;
    }
} 