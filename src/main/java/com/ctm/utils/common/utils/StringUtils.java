package com.ctm.utils.common.utils;

public class StringUtils {

    public static String sqlQuestionMarkStringBuilder(int repeatNumber){
        String csvString="";
        for (int i = 0; i < repeatNumber; i++) {
            csvString += "?,";
        }
        return csvString.length()>0?csvString.substring(0,csvString.length()-1):null;
    }
}
