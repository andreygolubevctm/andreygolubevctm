package com.ctm.web.simples.phone.inin.model;

import java.util.Objects;

public class SecurePause {
    private SecurePauseType securePauseType;
    private int duration;

    private SecurePause() {
    }

    public SecurePause(final SecurePauseType securePauseType, final int duration) {
        this.securePauseType = securePauseType;
        this.duration = duration;
    }

    public SecurePauseType getSecurePauseType() {
        return securePauseType;
    }

    public int getDuration() {
        return duration;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final SecurePause that = (SecurePause) o;
        return Objects.equals(duration, that.duration) &&
                Objects.equals(securePauseType, that.securePauseType);
    }

    @Override
    public int hashCode() {
        return Objects.hash(securePauseType, duration);
    }

    @Override
    public String toString() {
        return "SecurePause{" +
                "securePauseType=" + securePauseType +
                ", duration=" + duration +
                '}';
    }
}
