package com.ctm.web.core.utils.common.utils;

public class StringUtils {

    public static final String LAST_3_BYTE_UTF_CHAR = "\uFFFF";
    public static final String REPLACEMENT_CHAR = "\uFFFD";

    public static String toValid3ByteUTF8String(String str)  {
        final int length = str.length();
        StringBuilder validStringBuilder = new StringBuilder(length);
        for (int offset = 0; offset < length; ) {
            final int codepoint = str.codePointAt(offset);

            // do something with the codepoint
            if (codepoint > StringUtils.LAST_3_BYTE_UTF_CHAR.codePointAt(0)) {
                validStringBuilder.append(StringUtils.REPLACEMENT_CHAR);
            } else {
                if (Character.isValidCodePoint(codepoint)) {
                    validStringBuilder.appendCodePoint(codepoint);
                } else {
                    validStringBuilder.append(StringUtils.REPLACEMENT_CHAR);
                }
            }
            offset += Character.charCount(codepoint);
        }
        return validStringBuilder.toString();
    }

    public static String sqlQuestionMarkStringBuilder(int repeatNumber){
        String csvString="";
        for (int i = 0; i < repeatNumber; i++) {
            csvString += "?,";
        }
        return csvString.length()>0?csvString.substring(0,csvString.length()-1):null;
    }
}
