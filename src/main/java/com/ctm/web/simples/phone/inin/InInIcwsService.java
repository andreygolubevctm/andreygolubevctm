package com.ctm.web.simples.phone.inin;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.model.ConnectionReq;
import com.ctm.web.simples.phone.inin.model.ConnectionResp;
import com.ctm.web.simples.phone.inin.model.SecurePause;
import com.ctm.web.simples.phone.inin.model.SecurePauseType;
import org.apache.commons.lang3.text.StrSubstitutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import rx.Observable;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

@Service
public class InInIcwsService {
    private static final Logger LOGGER = LoggerFactory.getLogger(InInIcwsService.class);

    public static final String ININ_CONNECTION_TYPE = "urn:inin.com:connection:icAuthConnectionRequestSettings";
    public static final String SESSION_ID = "ININ-ICWS-Session-ID";

    @Autowired InInConfig inInConfig;
    @Autowired private Client<ConnectionReq, ConnectionResp> connectionClient;
    @Autowired private Client<SecurePause, String> securePauseClient;

    private String connectionUrl;
    private String securePauseUrl;

    @PostConstruct
    public void initConfig() {
        this.connectionUrl = inInConfig.getCicUrl() + "/connection";
        this.securePauseUrl = inInConfig.getCicUrl() + "/icws/${sessionId}/interactions/${interactionId}/secure-pause";
    }

    private Observable<ResponseEntity<ConnectionResp>> connection() {
        final ConnectionReq connectionReq = new ConnectionReq(ININ_CONNECTION_TYPE, inInConfig.getCicApplicationName(),
            inInConfig.getCicUserId(), inInConfig.getCicPassword());
        return connectionClient.postWithResponseEntity(connectionReq, ConnectionResp.class, connectionUrl);
    }

    private void securePause(final SecurePauseType securePauseType, final String interactionId) {
        connection().flatMap(connectionResp -> {
            final HttpHeaders headers = connectionResp.getHeaders();
            final String cookie = headers.get("Set-Cookie").get(0);
            final String csrf = headers.get("ININ-ICWS-Session-ID").get(0);
            final String url = createSecurePauseUrl(interactionId, headers);
            final SecurePause securePause = new SecurePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, 0);
            RestSettings<SecurePause> settings = RestSettings.<SecurePause>builder()
                .header("Cookie", cookie)
                .header("ININ-ICWS-CSRF-Token", csrf)
                .request(securePause)
                .response(String.class)
                .url(url).build();
            return securePauseClient.post(settings);
        }).subscribe(s -> LOGGER.info("secure pause returned {}", kv("securePauseResponse", s)));
    }

    private String createSecurePauseUrl(final String interactionId, final HttpHeaders headers) {
        final Map<String, Object> values = new HashMap<>();
        values.put("sessionId", headers.get(SESSION_ID).get(0));
        values.put("interactionId", interactionId);
        return StrSubstitutor.replace(securePauseUrl, values);
    }

    public void pause() {
        securePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, "");
    }

    public void resume() {
        securePause(SecurePauseType.RESUME_RECORDING, "");
    }
}
