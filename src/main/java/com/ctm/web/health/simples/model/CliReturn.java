package com.ctm.web.health.simples.model;

import com.ctm.web.core.model.settings.Vertical;
import lombok.Getter;
import lombok.Setter;

import javax.validation.constraints.NotNull;

@Getter
@Setter
public class CliReturn {

    @NotNull
    private String value;

    @NotNull
    private Integer styleCodeId;

    @NotNull
    private Vertical.VerticalType vertical;

    @Override
    public String toString() {
        return "CliReturn{" +
                "value='" + value + '\'' +
                "styleCodeId=" + styleCodeId +
                "vertical=" + vertical +
                '}';
    }
}
