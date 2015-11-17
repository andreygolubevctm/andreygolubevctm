package com.ctm.web.core.logging;

import net.logstash.logback.argument.StructuredArgument;
import net.logstash.logback.argument.StructuredArguments;

import java.util.Map;
import java.util.regex.Pattern;

import static com.ctm.web.core.logging.WrappedLoggingArgument.wrappedLoggingArgument;

/**
 * A factory for creating {@link LoggingArgument}s. These are used for inserting key value pairs into log statements.
 *
 * This is facade around logstash-logback-encoder so there isn't a direct dependency on logback for our logging.
 */
public class LoggingArguments {
    private LoggingArguments() {}
    private static final Pattern KEYNAME_PATTERN = Pattern.compile("\\.");

    // remove all . in key name as elasticsearch 2 doesn't support .'s
    private static String clean(final String key) {
        return KEYNAME_PATTERN.matcher(key).replaceAll("");
    }

    private static LoggingArgument wrap(StructuredArgument structuredArgument) {
        return wrappedLoggingArgument(structuredArgument);
    }

    public static LoggingArgument keyValue(final String key, final Object value) {
        return wrap(StructuredArguments.keyValue(clean(key), value));
    }

    public static LoggingArgument kv(final String key, final Object value) {
        return wrap(StructuredArguments.kv(clean(key), value));
    }

    public static LoggingArgument value(final String key, final Object value) {
        return wrap(StructuredArguments.value(clean(key), value));
    }

    public static LoggingArgument v(final String key, final Object value) {
        return wrap(StructuredArguments.v(clean(key), value));
    }

    public static LoggingArgument entries(final Map<?, ?> map) {
        return wrap(StructuredArguments.entries(map));
    }

    public static LoggingArgument e(final Map<?, ?> map) {
        return wrap(StructuredArguments.e(map));
    }

    public static LoggingArgument fields(final Object object) {
        return wrap(StructuredArguments.fields(object));
    }

    public static LoggingArgument f(final Object object) {
        return wrap(StructuredArguments.f(object));
    }

    public static LoggingArgument array(final String fieldName, Object... objects) {
        return wrap(StructuredArguments.array(fieldName, objects));
    }

    public static LoggingArgument a(final String fieldName, Object... objects) {
        return wrap(StructuredArguments.a(fieldName, objects));
    }

    public static LoggingArgument raw(final String fieldName, String rawJsonValue) {
        return wrap(StructuredArguments.raw(fieldName, rawJsonValue));
    }

    public static LoggingArgument r(final String fieldName, final String rawJsonValue) {
        return wrap(StructuredArguments.r(fieldName, rawJsonValue));
    }

    public static String toString(final Object arg) {
        return StructuredArguments.toString(arg);
    }

}
