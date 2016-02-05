package com.ctm.web.simples.phone.inin;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.interfaces.common.util.SerializationMappers;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.phone.inin.model.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import org.apache.commons.lang3.StringUtils;
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
import java.util.Optional;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

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
	@Autowired private Client<String, List<Message>> messageClient;
	@Autowired private Client<SecurePause, String> securePauseClient;

	private String connectionUrl;
	private String queueSubscriptionUrl;
	private String messagesUrl;
	private String securePauseUrl;

	@PostConstruct
	public void initConfig() {
		this.connectionUrl = inInConfig.getCicUrl() + "/connection";
		this.queueSubscriptionUrl = inInConfig.getCicUrl()+ "/${sessionId}/messaging/subscriptions/queues/${subscriptionName}";
		this.messagesUrl = inInConfig.getCicUrl() + "/${sessionId}/messaging/messages";
		this.securePauseUrl = inInConfig.getCicUrl() + "/${sessionId}/interactions/${interactionId}/secure-pause";
	}

	public Observable<PauseResumeResponse> pause(final String agentUsername, final Optional<String> interactionId) {
		return securePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, agentUsername, interactionId);
	}

	public Observable<PauseResumeResponse> resume(final String agentUsername, final Optional<String> interactionId) {
		return securePause(SecurePauseType.RESUME_RECORDING, agentUsername, interactionId);
	}

	private Observable<PauseResumeResponse> securePause(final SecurePauseType securePauseType, final String agentUsername, final Optional<String> interactionId) {
		// Get session connection
		return connection()
				.flatMap(connectionResp ->
								// Put a subscription on agent activity
								queueSubscription(agentUsername, connectionResp)
										.delay(1, TimeUnit.SECONDS)
										// Get messages of agent activity (should give us the current phone call status)
										.flatMap(s -> getInteractionId(connectionResp))
										// Pause or resume the call
										.flatMap(iId -> securePauseRequest(securePauseType, iId, connectionResp))
										.flatMap(pauseResp -> Observable.just(PauseResumeResponse.success()))
										.onErrorReturn(throwable -> handleSecurePauseError(securePauseType, agentUsername, throwable))
				)
				.onErrorReturn(throwable -> handleSecurePauseError(securePauseType, agentUsername, throwable));
	}

	private PauseResumeResponse handleSecurePauseError(final SecurePauseType securePauseType, final String agentUsername, final Throwable throwable) {
		if (throwable instanceof HttpClientErrorException) {
			LOGGER.error("securePause failed. {}, {}, {}", kv("agentUsername",agentUsername), kv("securePauseType",securePauseType), ((HttpClientErrorException) throwable).getResponseBodyAsString());
		} else {
			LOGGER.error("securePause failed. {}, {}", kv("agentUsername",agentUsername), kv("securePauseType",securePauseType), throwable);
		}
		return PauseResumeResponse.fail(throwable.getMessage());
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
				.header("Content-Type", APPLICATION_JSON_VALUE)
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
				LOGGER.debug("PUT queue subscription: " + jacksonMappers.getJsonMapper().writeValueAsString(subscriptionReq));
			} catch (JsonProcessingException e) {
				LOGGER.error("Cannot serialize: {}\nbecause {}", subscriptionReq, e);
			}
		}

		return queueSubscriptionClient.put(settings);
	}

	private Observable<Message> getMessages(final ResponseEntity<ConnectionResp> connectionResp) {
		final String sessionId = connectionResp.getHeaders().get(SESSION_ID).get(0);
		final String url = createMessagesUrl(sessionId);

		LOGGER.debug("Get messages: " + url);

		RestSettings<String> settings = authenticatedRestSettings(RestSettings.<String>builder(), connectionResp)
				.request(null)
				.response(new ParameterizedTypeReference<List<Message>>() {})
				.url(url)
				.build();
		return messageClient.get(settings).flatMap(Observable::<Message>from);
	}

	private Observable<String> getInteractionId(final ResponseEntity<ConnectionResp> connectionResp) {
		final Observable<Message> messages = getMessages(connectionResp);
		Observable<Optional<String>> interactionId = messages
				// Look at messages that have added or changed interactions
				.filter(message -> message.getInteractionsAdded().size() > 0 || message.getInteractionsChanged().size() > 0)
				// Look at messages that have a valid call state
				.filter(message -> message.getInteractionsAdded().stream().filter(i -> i.getAttributes().callState != null).count() > 0
						|| message.getInteractionsChanged().stream().filter(i -> i.getAttributes().callState != null).count() > 0)
				.map(message -> {
					LOGGER.debug("Checking message: " + message.toString());
					return message;
				})
				// Stream the two interaction arrays and get the first ID
				.map(message -> Stream.concat(message.getInteractionsAdded().stream(), message.getInteractionsChanged().stream())
							.findFirst()
							.map(Interaction::getInteractionId));

		return interactionId
				.defaultIfEmpty(Optional.empty())
				.flatMap(s -> {
					LOGGER.debug("getInteractionId: {}", s);
					if (s.isPresent()) {
						return Observable.just(s.get());
					} else {
						return Observable.error(new Exception("Could not find valid interactionId"));
					}
				});
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
		final String cookie = StringUtils.substringBefore(headers.get("Set-Cookie").get(0), ";");
		final String csrf = headers.get(CSRF_TOKEN).get(0);
		return builder
				.header("Content-Type", APPLICATION_JSON_VALUE)
				.header("Cookie", cookie)
				.header(CSRF_TOKEN, csrf);
	}

}
