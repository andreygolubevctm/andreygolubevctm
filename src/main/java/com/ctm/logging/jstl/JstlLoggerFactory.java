package com.ctm.logging.jstl;


import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JstlLoggerFactory {

    public static JstlLogger getLogger(String normalizedLoggerName){
        normalizedLoggerName = normalizeLoggerName(normalizedLoggerName);
        Logger logger = LoggerFactory.getLogger(normalizedLoggerName);
        return new JstlLogger(logger);
    }

    private static String normalizeLoggerName(String source) {
        final String suffix = FilenameUtils.getExtension(source);
        final String path = FilenameUtils.removeExtension(source);
        final String dottedPath = path.replaceAll("/", ".");
        final String loggerName = suffix + dottedPath;
        return loggerName.startsWith(".") ? loggerName.replace(".", "") : loggerName;
    }

}
