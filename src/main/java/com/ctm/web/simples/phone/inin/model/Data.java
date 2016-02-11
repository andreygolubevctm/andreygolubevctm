package com.ctm.web.simples.phone.inin.model;

import java.util.Objects;

public class Data {
    private String key;
    private String value;

    public Data(final String key, final String value) {
        this.key = key;
        this.value = value;
    }

    private Data() {
    }

    public String getKey() {
        return key;
    }

    public String getValue() {
        return value;
    }

    @Override
    public boolean equals(final Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        final Data data = (Data) o;
        return Objects.equals(key, data.key) &&
                Objects.equals(value, data.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(key, value);
    }

    @Override
    public String toString() {
        return "Data{" +
                "key='" + key + '\'' +
                ", value='" + value + '\'' +
                '}';
    }
}
