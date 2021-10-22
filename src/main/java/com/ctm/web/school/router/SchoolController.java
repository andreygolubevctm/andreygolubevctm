package com.ctm.web.school.router;

import com.ctm.web.school.services.SchoolService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/rest/school")
public class SchoolController {
    private static final Logger LOG = LoggerFactory.getLogger(SchoolController.class);

    @Autowired
    public SchoolService schoolService;

    @RequestMapping(value = "/get.json", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public String getSchools() {
        LOG.debug("About to obtain the list of Schools..");
        return schoolService.getSchoolsAsHtmlOptions();
    }
}

