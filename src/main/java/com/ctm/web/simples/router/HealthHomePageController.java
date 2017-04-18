package com.ctm.web.simples.router;

import com.ctm.web.simples.admin.services.RemainingSalesService;
import com.ctm.web.simples.model.RemainingSale;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Api(basePath = "/rest/simples", value = "Health Quote")
@RestController
@RequestMapping("/rest/simples")
public class HealthHomePageController {

    @Autowired
    private RemainingSalesService remainingSalesService;

    @RequestMapping(value = "/remainingSales.json",
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    public List<RemainingSale> getRemainingSales() {
        return remainingSalesService.getRemainingSales();
    }

}
