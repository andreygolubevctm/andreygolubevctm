package com.ctm.utils.jsp;

import org.slf4j.Logger;

public class JspLogger {

    private Logger logger;

    public JspLogger(Logger logger) {
        this.logger = logger;
    }

    public void trace(String msg) {
        logger.trace(msg);
    }

    public void trace(String format, Object arg) {
        // hack for JSP
        if(arg instanceof Throwable) {
            logger.trace(format, (Throwable) arg);
        } else {
            logger.trace(format, arg);
        }
    }

    public void trace(String format, Object arg1, Object arg2) {
        logger.trace(format,  arg1, arg2);
    }

    public void trace(String format, Object arg1, Object arg2, Object arg3) {
        logger.trace(format, arg1, arg2, arg3);
    }

    public void debug(String msg) {
        logger.debug(msg);
    }

    public void debug(String format, Object arg) {
        // hack for JSP
        if(arg instanceof Throwable) {
            logger.debug(format, (Throwable) arg);
        } else {
            logger.debug(format, arg);
        }
    }

    public void debug(String format, Object arg1, Object arg2) {
        logger.debug(format, arg1, arg2);
    }

    public void debug(String format, Object arg1, Object arg2, Object arg3) {
        logger.debug(format, arg1, arg2, arg3);
    }

    public void debug(String format, Object arg1, Object arg2, Object arg3, Object arg4) {
        logger.debug(format, arg1, arg2, arg3, arg4);
    }


    public void debug(String format, Object arg1, Object arg2, Object arg3, Object arg4, Object arg5) {
        logger.debug(format, arg1, arg2, arg3, arg4, arg5);
    }

    public void info(String msg) {
        logger.info(msg);
    }

    public void info(String format, Object arg) {
        // hack for JSP
        if(arg instanceof Throwable) {
            logger.info(format, (Throwable)arg);
        } else {
            logger.info(format, arg);
        }
    }

    public void info(String format, Object arg1, Object arg2) {
        logger.info(format ,arg1, arg2);
    }

    public void info(String format, Object arg1, Object arg2, Object arg3) {
        logger.info(format, arg1, arg2, arg3);
    }

    public void info(String format, Object arg1, Object arg2, Object arg3, Object arg4) {
        logger.info(format, arg1, arg2, arg3, arg4);
    }


    public void warn(String msg) {
        logger.warn(msg);
    }

    public void warn(String format, Object arg) {
        // hack for JSP
        if(arg instanceof Throwable) {
            logger.warn(format, (Throwable) arg);
        } else {
            logger.warn(format, arg);
        }
    }

    public void warn(String format, Object arg1, Object arg2, Object arg3) {
        logger.warn( format,  arg1,  arg2,  arg3);
    }

    public void warn(String format, Object arg1, Object arg2, Object arg3, Object arg4) {
        logger.warn( format,  arg1,  arg2,  arg3, arg4);
    }

    public void warn(String format, Object arg1, Object arg2, Object arg3, Object arg4, Object arg5) {
        logger.warn(format, arg1, arg2, arg3, arg4, arg5);
    }

    public void warn(String format, Object arg1, Object arg2) {
        logger.warn(format, arg1, arg2);
    }


    public void error(String msg) {
        logger.error(msg);
    }

    public void error(String format, Object arg) {
        // hack for JSP
        if(arg instanceof Throwable) {
            logger.error(format, (Throwable) arg);
        } else {
            logger.error(format, arg);
        }
    }

    public void error(String format, Object arg1, Object arg2) {
        logger.error(format,arg1,arg2);
    }

    public void error(String format, Object arg1, Object arg2, Object arg3) {
        logger.error(format,arg1,arg2,arg3);
    }

    public void error(String format, Object arg1, Object arg2, Object arg3, Object arg4) {
        logger.error(format,arg1,arg2,arg3, arg4);
    }

    public void error(String format, Object arg1, Object arg2, Object arg3, Object arg4, Object arg5) {
        logger.error(format,arg1,arg2,arg3, arg4, arg5);
    }


}
