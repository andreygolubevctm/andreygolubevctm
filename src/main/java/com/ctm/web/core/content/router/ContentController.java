package com.ctm.web.core.content.router;

import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.model.ContentSupplement;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.services.ApplicationService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.constraints.NotNull;

/**
 * Created by msmerdon on 5/12/2016.
 */
@Api(basePath = "/", value = "content")
@RestController
public class ContentController {

    @Resource
    private ContentService contentService;

    @ApiOperation(value = "/content/get.json", notes = "Get Content", produces = "application/json")
    @RequestMapping(value = "/content/get.json", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Content get(@RequestParam @NotNull final String vertical, @RequestParam @NotNull final String key, HttpServletRequest request) throws DaoException, ConfigSettingException {
        ApplicationService.setVerticalCodeOnRequest(request, vertical.toUpperCase());
        return contentService.getContent(request, key);
    }

    @ApiOperation(value = "/content/getsupplementary.json", notes = "Get Content with Supplementary Values", produces = "application/json")
    @RequestMapping(value = "/content/getsupplementary.json", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public Content getSupplementary(@RequestParam @NotNull final String vertical, @RequestParam @NotNull final String key, HttpServletRequest request) throws DaoException, ConfigSettingException {
        ApplicationService.setVerticalCodeOnRequest(request, vertical.toUpperCase());
        return contentService.getContentWithSupplementary(request, key);
    }

    @ApiOperation(value = "/content/getsupplementaryvalue.json", notes = "Get Supplementary Content Value", produces = "application/json")
    @RequestMapping(value = "/content/getsupplementaryvalue.json", method = RequestMethod.GET, produces = MediaType.APPLICATION_JSON_VALUE)
    public ContentSupplement getSupplementaryValue(@RequestParam @NotNull final String vertical, @RequestParam @NotNull final String key, @RequestParam @NotNull final String supp, HttpServletRequest request) throws DaoException, ConfigSettingException {
        ApplicationService.setVerticalCodeOnRequest(request, vertical.toUpperCase());
        Content content = contentService.getContentWithSupplementary(request, key);
        return content.getSupplementaryByKey(supp);
    }
}
