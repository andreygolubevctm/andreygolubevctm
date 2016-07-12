package com.ctm.web.core.model.formData;

import java.util.function.Function;

public enum YesNo {
    Y, N;

    public static Function<YesNo, Boolean> getYesNoBooleanFunction() {
        return value -> getBooleanValue(value);
    }

    public static Boolean getBooleanValue(YesNo value) {
        return value.getBooleanValue();
    }

    public boolean getBooleanValue() {
        return YesNo.Y.equals(this);
    }
}