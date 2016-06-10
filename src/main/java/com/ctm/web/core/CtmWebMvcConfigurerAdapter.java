package com.ctm.web.core;

import com.ctm.web.core.intercepter.SpringFormParamMapInInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

@Configuration
@EnableWebMvc
public class CtmWebMvcConfigurerAdapter extends WebMvcConfigurerAdapter {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new SpringFormParamMapInInterceptor()).addPathPatterns("/rest/energy/**");
        registry.addInterceptor(new SpringFormParamMapInInterceptor()).addPathPatterns("/rest/car/**");
        registry.addInterceptor(new SpringFormParamMapInInterceptor()).addPathPatterns("/rest/home/**");
        registry.addInterceptor(new SpringFormParamMapInInterceptor()).addPathPatterns("/rest/travel/**");
    }

}
