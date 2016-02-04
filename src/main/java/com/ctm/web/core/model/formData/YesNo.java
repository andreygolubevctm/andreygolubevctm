package com.ctm.web.core.model.formData;

import java.util.function.Function;

public enum YesNo {
    Y, N;

    public static Function<YesNo, Boolean> getYesNoBooleanFunction() {
        return value -> getYesNoBoolean(value);
    }

    public static Boolean getYesNoBoolean(YesNo value) {
        return YesNo.Y.equals(value);
    }
}