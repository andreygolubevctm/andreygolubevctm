package com.ctm.spring;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceBuilder;
import org.springframework.boot.autoconfigure.jdbc.DataSourceProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.Lifecycle;
import org.springframework.context.annotation.Configuration;

import javax.sql.DataSource;

/**
 * Created by dkocovski on 24/09/2015.
 */
@Configuration
@EnableConfigurationProperties(DataSourceProperties.class)
public class WebCtmDataAccessConfiguration implements Lifecycle, InitializingBean, DisposableBean {
    private static final Logger LOGGER = LoggerFactory.getLogger(WebCtmDataAccessConfiguration.class);

    private static DataSourceBuilder dataSourceFactory;

    @Autowired
    private DataSourceProperties dataSourceProperties;

    @Override
    public void start() {
    }

    @Override
    public void stop() {
    }

    @Override
    public void destroy() throws Exception {
    }

    @Override
    public boolean isRunning() {
        return true;
    }

    @Override
    public void afterPropertiesSet() throws Exception {
        LOGGER.info("Start afterPropertiesSet()");
        dataSourceFactory = DataSourceBuilder.create(dataSourceProperties.getClassLoader())
                .driverClassName(dataSourceProperties.getDriverClassName())
                .url(dataSourceProperties.getUrl())
                .username(dataSourceProperties.getUsername())
                .password(dataSourceProperties.getPassword());
        LOGGER.info("dataSourceFactory created");
        LOGGER.info("Finish afterPropertiesSet()");
    }

    public static DataSource getDataSource() {
        return dataSourceFactory.build();
    }

}