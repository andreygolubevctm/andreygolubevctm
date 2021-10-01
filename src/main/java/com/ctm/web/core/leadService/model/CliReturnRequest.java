package com.ctm.web.core.leadService.model;

import com.ctm.web.core.model.settings.Vertical;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@ToString
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class CliReturnRequest {

    private String phone;

    private Integer styleCodeId;

    private Vertical.VerticalType vertical;
}
