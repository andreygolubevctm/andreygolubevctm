package com.ctm.web.simples.router;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.services.SessionDataServiceBean;
import com.ctm.web.core.services.SettingsService;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.model.BlacklistOutcome;
import com.ctm.web.simples.phone.inin.model.Data;
import com.ctm.web.simples.phone.inin.model.Insert;
import com.ctm.web.simples.services.SimplesBlacklistService;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.text.StrSubstitutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpServerErrorException;
import rx.Observable;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static java.util.Collections.singletonList;

@RestController
@RequestMapping("/rest/simples/blacklist")
public class BlacklistController {
    private static final String INSERT_RECORDS_URL = "${wsUrl}/InsertRecords";
    private static final Logger LOGGER = LoggerFactory.getLogger(BlacklistController.class);

    public static final String ADD = "/add.json";
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

        final PageSettings pageSettings = SettingsService.setVerticalAndGetSettingsForPage(request, "HEALTH");

        final Optional<String> outcome = Optional.ofNullable(simplesBlacklistService.addToBlacklist(request, channel, value, operator, comment));
        LOGGER.info("Simples blacklist outcome: {}", kv("simplesBlacklistOutcome", outcome));

        if(outcome.map(s -> s.equals("success")).orElse(false) && StringUtils.equalsIgnoreCase("phone", channel)) {
            insertIntoBlacklistCampaign(inInConfig.getWsPrimaryUrl(), value)
                .onErrorResumeNext(throwable -> failover(throwable, inInConfig.getCicFailoverUrl(), value))
                .toBlocking().first();
        }
        return new BlacklistOutcome(outcome.orElse(""));
    }

    private Observable<String> failover(Throwable throwable, final String wsUrl, final String value) {
        return isNotFound(throwable) ? insertIntoBlacklistCampaign(wsUrl, value) : Observable.error(throwable);
    }

    private boolean isNotFound(final Throwable throwable) {
        return throwable instanceof HttpServerErrorException && ((HttpServerErrorException) throwable).getStatusCode() == HttpStatus.NOT_FOUND;
    }

    private Observable<String> insertIntoBlacklistCampaign(final String wsUrl, final String value) {
        Insert insert = new Insert(blacklistCampaignName, new ArrayList<>());

        addPhone(insert, value);

        final String url = StrSubstitutor.replace(INSERT_RECORDS_URL, Collections.singletonMap("wsUrl", wsUrl));
        RestSettings<List<Insert>> settings = RestSettings.<List<Insert>>builder()
                .header("Content-Type", "application/json;charset=UTF-8")
                .request(singletonList(insert))
                .response(String.class)
                .url(url)
                .build();

        return blacklistClient.post(settings).retryWhen(this::retryWithDelay);
    }

    private Observable<? extends Throwable> retryWithDelay(final Observable<? extends Throwable> attempt) {
        return attempt.zipWith(Observable.range(1, ATTEMPTS), (a, n) -> a).delay(DELAY, TimeUnit.MILLISECONDS);
    }

    private void addPhone(final Insert insert, final String phone) {
        insert.getDatas().add(new Data("Phone", phone));
    }
}
