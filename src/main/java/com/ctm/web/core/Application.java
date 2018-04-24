package com.ctm.web.core;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.web.client.RestTemplate;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;

@SpringBootApplication
@ComponentScan({"com.ctm.web.core.connectivity", "com.ctm.web.energy", "com.ctm.web.simples",
        "com.ctm.commonlogging", "com.ctm.web.core","com.ctm.web.factory", "com.ctm.httpclient",
        "com.ctm.web.car", "com.ctm.web.homecontents",
        "com.ctm.web.travel", "com.ctm.web.life", "com.ctm.web.health",
        "com.ctm.web.fuel", "com.ctm.web.bsb", "com.ctm.web.reward", "com.ctm.web.email",
        "com.ctm.web.lifebroker"})
@EnableAutoConfiguration(exclude = RabbitAutoConfiguration.class)
@Configuration
@EnableAsync
public class Application extends SpringBootServletInitializer {

    private static final Logger LOGGER = LoggerFactory.getLogger(Application.class);

    @Bean
    public RestTemplate restTemplate(){
        return new RestTemplate();
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        // Customize the application or call application.sources(...) to add sources
        // Since our example is itself a @Configuration class we actually don't
        // need to override this method.
        return application;
    }

    public void onStartup(ServletContext servletContext) throws ServletException {
        LOGGER.info("Override onStartup so that spring does not takeover the web context with its own listener");
    }

    public static void main(String[] args) throws Exception {
        SpringApplication.run(Application.class, args);
    }

}