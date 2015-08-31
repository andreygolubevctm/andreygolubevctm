package com.ctm.utils.jsp;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JspLoggerFactory {

    public static JspLogger getLogger(String source){
        Logger logger = LoggerFactory.getLogger(source);
        return new JspLogger(logger);
    }

}
