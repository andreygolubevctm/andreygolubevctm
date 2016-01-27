package com.ctm.web.simples.phone.inin;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.model.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.commons.lang3.text.StrSubstitutor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import rx.Observable;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.Map;

@Service
public class InInIcwsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(InInIcwsService.class);

	public static final String ININ_CONNECTION_TYPE = "urn:inin.com:connection:icAuthConnectionRequestSettings";
	public static final String SESSION_ID = "ININ-ICWS-Session-ID";
	public static final String CSRF_TOKEN = "ININ-ICWS-CSRF-Token";

    @Autowired InInConfig inInConfig;
    @Autowired private Client<ConnectionReq, ConnectionResp> connectionClient;
    @Autowired private Client<SecurePause, String> securePauseClient;
	@Autowired private SerializationMappers jacksonMappers;

	private String connectionUrl;
	private String securePauseUrl;

	@PostConstruct
	public void initConfig() {
		this.connectionUrl = inInConfig.getCicUrl() + "/connection";
		this.securePauseUrl = inInConfig.getCicUrl() + "/${sessionId}/interactions/${interactionId}/secure-pause";
	}

	private Observable<ResponseEntity<ConnectionResp>> connection() {
		final ConnectionReq connectionReq = new ConnectionReq(ININ_CONNECTION_TYPE, inInConfig.getCicApplicationName(),
				inInConfig.getCicUserId(), inInConfig.getCicPassword());
		RestSettings<ConnectionReq> settings = RestSettings.<ConnectionReq>builder()
				.header("Accept-Language", "en")
				.header("Content-Type", "application/json;charset=UTF-8")
				.request(connectionReq)
				.response(ConnectionResp.class)
				.url(connectionUrl)
				.build();

		if (LOGGER.isDebugEnabled()) {
			try {
				LOGGER.debug(jacksonMappers.getJsonMapper().writeValueAsString(connectionReq));
			} catch (JsonProcessingException e) {
				LOGGER.error("Cannot serialize: {}\nbecause {}", connectionReq, e);
			}
		}

		return connectionClient.postWithResponseEntity(settings);
	}

	private Observable<PauseResumeResponse> securePause(final SecurePauseType securePauseType, final String interactionId) {
		return connection()
				.flatMap(connectionResp -> securePauseRequest(securePauseType, interactionId, connectionResp))
				.flatMap(pauseResp -> Observable.just(PauseResumeResponse.success()))
				.onErrorReturn(throwable -> {
					if (throwable instanceof HttpClientErrorException) {
						LOGGER.error("securePause failed. {}", ((HttpClientErrorException) throwable).getResponseBodyAsString());
					}
					return PauseResumeResponse.fail();
				});
	}

	private Observable<String> securePauseRequest(SecurePauseType securePauseType, String interactionId, ResponseEntity<ConnectionResp> connectionResp) {
		final HttpHeaders headers = connectionResp.getHeaders();
		final String cookie = headers.get("Set-Cookie").get(0);
		final String csrf = headers.get(CSRF_TOKEN).get(0);
		final String url = createSecurePauseUrl(interactionId, headers);
		final SecurePause securePause = new SecurePause(securePauseType, 0);
		RestSettings<SecurePause> settings = RestSettings.<SecurePause>builder()
				.header("Cookie", cookie)
				.header(CSRF_TOKEN, csrf)
				.header("Content-Type", "application/json;charset=UTF-8")
				.request(securePause)
				.response(String.class)
				.url(url)
				.build();
		return securePauseClient.post(settings);
	}

	private String createSecurePauseUrl(final String interactionId, final HttpHeaders headers) {
		final Map<String, Object> values = new HashMap<>();
		values.put("sessionId", headers.get(SESSION_ID).get(0));
		values.put("interactionId", interactionId);
		return StrSubstitutor.replace(securePauseUrl, values);
	}

	public Observable<PauseResumeResponse> pause() {
		return securePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, "test");
	}

	public Observable<PauseResumeResponse> resume() {
		return securePause(SecurePauseType.RESUME_RECORDING, "test");
	}
}
