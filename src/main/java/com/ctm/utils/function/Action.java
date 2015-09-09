package com.ctm.utils.function;

import java.util.function.Function;

public class Action {
    public static Function<Void, Void> action(Runnable runnable) {
        return (v) -> {
            runnable.run();
            return null;
        };
    }
}
