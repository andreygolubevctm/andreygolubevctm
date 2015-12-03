package com.ctm.web.car.model.form;

import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.List;

public class Opts {

    private String opt00;

    private String opt02;

    public String getOpt00() {
        return opt00;
    }

    public void setOpt00(String opt00) {
        this.opt00 = opt00;
    }

    public String getOpt02() {
        return opt02;
    }

    public void setOpt02(String opt02) {
        this.opt02 = opt02;
    }

    public List<String> getOpts() {
        List<String> list = new ArrayList<>();
        addIfNotNull(getOpt00(), list);
        addIfNotNull(getOpt02(), list);
        return list;
    }

    private void addIfNotNull(String opt, List<String> opts) {
        if (StringUtils.isNotBlank(opt)) {
            opts.add(opt);
        }
    }
}
