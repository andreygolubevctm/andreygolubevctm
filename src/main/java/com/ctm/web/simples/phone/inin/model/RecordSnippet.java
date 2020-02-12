package com.ctm.web.simples.phone.inin.model;

import lombok.AllArgsConstructor;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Parameters required by Dialler API
 */

@AllArgsConstructor
@NoArgsConstructor
@Getter
@EqualsAndHashCode
public class RecordSnippet {

    private boolean on;
    private boolean supervisor;

    @Override
    public String toString() {
        return "RecordSnippet{" +
                "isSnippingOn=" + on +
                ", isSupervisor=" + supervisor +
                '}';
    }
}
