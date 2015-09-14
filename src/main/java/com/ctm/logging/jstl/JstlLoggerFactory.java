package com.ctm.logging.jstl;


import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JstlLoggerFactory {

    public static JstlLogger getLogger(String source){
        Logger logger = LoggerFactory.getLogger(source);
        return new JstlLogger(logger);
    }

}
