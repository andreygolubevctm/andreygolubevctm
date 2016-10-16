package com.ctm.web.health.apply.model.request.fundData.benefits;

import com.fasterxml.jackson.annotation.JsonInclude;

import java.util.ArrayList;
import java.util.List;

import static com.fasterxml.jackson.annotation.JsonInclude.Include.NON_EMPTY;

@JsonInclude(NON_EMPTY)
public class Benefits {

    private List<String> benefits = new ArrayList<>();

    public Benefits(List<String> benefits) {
        this.benefits = benefits;
    }

    public List<String> getBenefits() {
        return benefits;
    }
}
