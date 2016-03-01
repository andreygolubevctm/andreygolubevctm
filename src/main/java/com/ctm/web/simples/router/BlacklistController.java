package com.ctm.web.simples.router;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.model.BlacklistOutcome;
import com.ctm.web.simples.phone.inin.model.Data;
import com.ctm.web.simples.phone.inin.model.Insert;
import com.ctm.web.simples.services.SimplesBlacklistService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import rx.Observable;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static java.util.Collections.singletonList;

@RestController
@RequestMapping("/rest/simples/blacklist")
public class BlacklistController {
    private static final Logger LOGGER = LoggerFactory.getLogger(BlacklistController.class);

    public static final String ADD = "/add.json";
    public static final String DELETE = "/delete.json";
    public static final String UNSUBSCRIBE = "/unsubscribe.json";
    public static final int DELAY = 500;
    public static final int ATTEMPTS = 2;

    private SimplesBlacklistService simplesBlacklistService = new SimplesBlacklistService();

    @Value("${ctm.web.simples.inin.blacklist.campaignName}")
    private String blacklistCampaignName;

    @Autowired InInConfig inInConfig;
    @Autowired private Client<List<Insert>, String> blacklistClient;
    @Autowired private SessionDataServiceBean sessionDataServiceBean;

    @RequestMapping(
            value = ADD,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public BlacklistOutcome addToBlacklist(@Valid @RequestParam final String channel,
                                           @Valid @RequestParam final String value,
                                           @Valid @RequestParam final String comment,
                                           final HttpServletRequest request) throws ConfigSettingException, DaoException {
        final AuthenticatedData authenticatedData = sessionDataServiceBean.getAuthenticatedSessionData(request);
        final String operator = authenticatedData.getUid();

        LOGGER.info("Adding to blacklist: {}, {}, {}, {}", kv("channel", channel), kv("value", value), kv("operator", operator), kv("comment", comment));

        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "SIMPLES");
        final boolean inInEnabled = StringUtils.equalsIgnoreCase("true", pageSettings.getSetting("inInEnabled"));

        final Optional<String> outcome = Optional.ofNullable(simplesBlacklistService.addToBlacklist(request, channel, value, operator, comment));
        LOGGER.info("Simples blacklist outcome: {}", kv("simplesBlacklistOutcome", outcome));

        if(inInEnabled && outcome.map(s -> s.equals("success")).orElse(false) && StringUtils.equalsIgnoreCase("phone", channel)) {
            insertIntoBlacklistCampaign(inInConfig.getWsPrimaryUrl(), inInConfig.getWsFailoverUrl(), value).toBlocking().first();
        }
        return new BlacklistOutcome(outcome.orElse(""));
    }

    @RequestMapping(
            value = DELETE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public BlacklistOutcome deleteFromBlacklist(@Valid @RequestParam final String channel,
                                                @Valid @RequestParam final String value,
                                                @Valid @RequestParam final String comment,
                                                final HttpServletRequest request) throws ConfigSettingException, DaoException {
        final AuthenticatedData authenticatedData = sessionDataServiceBean.getAuthenticatedSessionData(request);
        final String operator = authenticatedData.getUid();

        LOGGER.info("Deleting from blacklist: {}, {}, {}, {}", kv("channel", channel), kv("value", value), kv("operator", operator), kv("comment", comment));

        ApplicationService.setVerticalCodeOnRequest(request, "SIMPLES");

        final Optional<String> outcome = Optional.ofNullable(simplesBlacklistService.deleteFromBlacklist(request, channel, value, operator, comment));
        LOGGER.info("Simples blacklist outcome: {}", kv("simplesBlacklistOutcome", outcome));

        return new BlacklistOutcome(outcome.orElse(""));
    }

    @RequestMapping(
            value = UNSUBSCRIBE,
            method = RequestMethod.POST,
            consumes = MediaType.APPLICATION_FORM_URLENCODED_VALUE,
            produces = MediaType.APPLICATION_JSON_VALUE
    )
    public BlacklistOutcome unsubscribeEmail(@Valid @RequestParam final String email,
                                             @Valid @RequestParam final String comment,
                                             final HttpServletRequest request) throws ConfigSettingException, DaoException {
        final AuthenticatedData authenticatedData = sessionDataServiceBean.getAuthenticatedSessionData(request);
        final String operator = authenticatedData.getUid();

        LOGGER.info("Unsubscribe email: {}, {}, {}", kv("email", email), kv("operator", operator), kv("comment", comment));

        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "SIMPLES");

        final Optional<String> outcome = Optional.ofNullable(simplesBlacklistService.unsubscribeFromSimples(request, pageSettings, email, operator, comment));
        LOGGER.info("Simples blacklist outcome: {}", kv("simplesBlacklistOutcome", outcome));

        return new BlacklistOutcome(outcome.orElse(""));
    }

    private Observable<String> insertIntoBlacklistCampaign(final String wsUrl, final String failoverWsUrl, final String value) {
        Insert insert = new Insert(blacklistCampaignName, new ArrayList<>());

        addPhone(insert, value);

        RestSettings<List<Insert>> settings = RestSettings.<List<Insert>>builder()
                .jsonRequest(singletonList(insert), String.class, wsUrl + "/InsertRecords")
                .retryAttempts(ATTEMPTS).retryDelay(DELAY).failoverUrl(failoverWsUrl + "/InsertRecords")
                .build();
        return blacklistClient.post(settings);
    }

    private void addPhone(final Insert insert, final String phone) {
        insert.getDatas().add(new Data("Phone", phone));
    }
}
