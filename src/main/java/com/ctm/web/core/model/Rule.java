package com.ctm.web.core.model;

import java.io.Serializable;
import java.util.Objects;

/**
 * Created by voba on 30/04/2015.
 */
public class Rule implements Serializable {
    private static final long serialVersionUID = 1L;
    private long id;
    private String description;
    private String value;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Rule)) return false;
        Rule rule = (Rule) o;
        return getId() == rule.getId() &&
                Objects.equals(getDescription(), rule.getDescription()) &&
                Objects.equals(getValue(), rule.getValue());
    }

    @Override
    public int hashCode() {

        return Objects.hash(getId(), getDescription(), getValue());
    }
}
