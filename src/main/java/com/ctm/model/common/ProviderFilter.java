package com.ctm.model.common;

import java.util.Collections;
import java.util.List;

public interface ProviderFilter {

    default String getAuthToken() {
        return "";
    };

    default List<String> getProviders() {
        return Collections.emptyList();
    }

    default String getProviderKey() {
        return "";
    }

    default void setSingleProvider(String singleProvider) {

    }

    default void setProviders(List<String> providers) {

    }

}
