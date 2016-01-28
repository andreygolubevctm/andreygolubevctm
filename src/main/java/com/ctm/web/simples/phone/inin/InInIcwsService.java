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
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import rx.Observable;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;

@Service
public class InInIcwsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(InInIcwsService.class);

	public static final String ININ_CONNECTION_TYPE = "urn:inin.com:connection:icAuthConnectionRequestSettings";
	public static final String SESSION_ID = "ININ-ICWS-Session-ID";
	public static final String CSRF_TOKEN = "ININ-ICWS-CSRF-Token";

	public static final List<String> SUBSCRIPTION_ATTRIBUTES = asList("Eic_CallIdKey", "Eic_State");

	@Autowired private SerializationMappers jacksonMappers;
	@Autowired InInConfig inInConfig;
	@Autowired private Client<ConnectionReq, ConnectionResp> connectionClient;
	@Autowired private Client<QueueSubscriptionReq, String> queueSubscriptionClient;
	@Autowired private Client<String, MessagesResp> messageClient;
	@Autowired private Client<SecurePause, String> securePauseClient;

	private String connectionUrl;
	private String queueSubscriptionUrl;
	private String messagesUrl;
	private String securePauseUrl;

	@PostConstruct
	public void initConfig() {
		this.connectionUrl = inInConfig.getCicUrl() + "/connection";
		this.queueSubscriptionUrl = inInConfig.getCicUrl() + "/${sessionId}/messaging/subscriptions/queues/${subscriptionName}";
		this.messagesUrl = inInConfig.getCicUrl() + "/${sessionId}/messaging/messages";
		this.securePauseUrl = inInConfig.getCicUrl() + "/${sessionId}/interactions/${interactionId}/secure-pause";
	}

	public Observable<PauseResumeResponse> pause() {
		return securePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, "lkauler", "foo");
	}

	public Observable<PauseResumeResponse> resume() {
		return securePause(SecurePauseType.RESUME_RECORDING, "lkauler", "foo");
	}

	private Observable<PauseResumeResponse> securePause(final SecurePauseType securePauseType, final String username, final String __interactionId) {
		// Get session connection
		return connection()
				.flatMap(connectionResp ->
								// Put a subscription on agent activity
								queueSubscription(username, connectionResp)
										// Get messages of agent activity (should give us the current phone call status)
										.flatMap(s -> getMessages(connectionResp))
										.map(this::messagesFilter)
										// Pause or resume the call
										.flatMap(interactionId -> securePauseRequest(securePauseType, interactionId, connectionResp))
										.flatMap(pauseResp -> Observable.just(PauseResumeResponse.success()))
										.onErrorReturn(throwable -> {
											if (throwable instanceof HttpClientErrorException) {
												LOGGER.error("securePause failed. {}", ((HttpClientErrorException) throwable).getResponseBodyAsString());
											}
											return PauseResumeResponse.fail();
										})
				)
				.onErrorReturn(throwable -> {
					if (throwable instanceof HttpClientErrorException) {
						LOGGER.error("securePause failed. {}", ((HttpClientErrorException) throwable).getResponseBodyAsString());
					}
					return PauseResumeResponse.fail();
				});
	}

	/**
	 * Make a connection to InIn ICWS to start a session. Use the response of this to continue the session in subsequent calls.
	 * @return ResponseEntity
	 */
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

	/**
	 * Put a subscription on an agent's activity.
	 * @param username Agent's username
	 * @param connectionResp ResponseEntity from the session connection
	 * @return "OK" if successful
	 */
	private Observable<String> queueSubscription(final String username, final ResponseEntity<ConnectionResp> connectionResp) {
		final QueueSubscriptionReq subscriptionReq = new QueueSubscriptionReq(singletonList(new QueueId(QueueType.USER, username)), SUBSCRIPTION_ATTRIBUTES);
		final String url = createQueueSubscriptionUrl(connectionResp.getHeaders().get(SESSION_ID).get(0), "PhoneStatusSubscription");

		RestSettings<QueueSubscriptionReq> settings = authenticatedRestSettings(RestSettings.<QueueSubscriptionReq>builder(), connectionResp)
				.request(subscriptionReq)
				.response(String.class)
				.url(url)
				.build();

		if (LOGGER.isDebugEnabled()) {
			try {
				LOGGER.debug(jacksonMappers.getJsonMapper().writeValueAsString(subscriptionReq));
			} catch (JsonProcessingException e) {
				LOGGER.error("Cannot serialize: {}\nbecause {}", subscriptionReq, e);
			}
		}

		return queueSubscriptionClient.put(settings);
	}

	private Observable<MessagesResp> getMessages(final ResponseEntity<ConnectionResp> connectionResp) {
		final String sessionId = connectionResp.getHeaders().get(SESSION_ID).get(0);
		final String url = createMessagesUrl(sessionId);

		RestSettings<String> settings = authenticatedRestSettings(RestSettings.<String>builder(), connectionResp)
				.request("")
				.response(new ParameterizedTypeReference<List<MessagesResp>>() {})
				.url(url)
				.build();
		return messageClient.put(settings);
	}

//	protected Observable<List<MessagesResp>> getMessages(final ResponseEntity<ConnectionResp> connectionResp, final Client<String, MessagesResp> client){
//	}

	private String messagesFilter(final MessagesResp messageResp) {
		return "intId";
	}

	/**
	 * Trigger the secure pause/resume.
	 */
	private Observable<String> securePauseRequest(final SecurePauseType securePauseType, final String interactionId, final ResponseEntity<ConnectionResp> connectionResp) {
		final HttpHeaders headers = connectionResp.getHeaders();
		final String url = createSecurePauseUrl(interactionId, headers);
		final SecurePause securePause = new SecurePause(securePauseType, 0);
		RestSettings<SecurePause> settings = authenticatedRestSettings(RestSettings.<SecurePause>builder(), connectionResp)
				.request(securePause)
				.response(String.class)
				.url(url)
				.build();
		return securePauseClient.post(settings);
	}

	private String createQueueSubscriptionUrl(final String sessionId, final String subscriptionName) {
		final Map<String, String> values = new HashMap<>();
		values.put("sessionId", sessionId);
		values.put("subscriptionName", subscriptionName);
		return StrSubstitutor.replace(queueSubscriptionUrl, values);
	}

	private String createMessagesUrl(final String sessionId) {
		final Map<String, String> values = new HashMap<>();
		values.put("sessionId", sessionId);
		return StrSubstitutor.replace(messagesUrl, values);
	}

	private String createSecurePauseUrl(final String interactionId, final HttpHeaders headers) {
		final Map<String, String> values = new HashMap<>();
		values.put("sessionId", headers.get(SESSION_ID).get(0));
		values.put("interactionId", interactionId);
		return StrSubstitutor.replace(securePauseUrl, values);
	}

	/**
	 * Take InIn authentication cookie/headers from a session connection and apply to settings for follow-up requests.
	 * @return Rest settings builder with InIn authentication
	 */
	private <T> RestSettings.Builder<T> authenticatedRestSettings(RestSettings.Builder<T> builder, final ResponseEntity<ConnectionResp> connectionResp) {
		final HttpHeaders headers = connectionResp.getHeaders();
		final String cookie = headers.get("Set-Cookie").get(0);
		final String csrf = headers.get(CSRF_TOKEN).get(0);
		return builder
				.header("Content-Type", "application/json;charset=UTF-8")
				.header("Cookie", cookie)
				.header(CSRF_TOKEN, csrf);
	}

}
