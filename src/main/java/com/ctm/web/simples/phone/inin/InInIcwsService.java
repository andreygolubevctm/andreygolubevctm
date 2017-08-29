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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.HttpStatusCodeException;
import rx.Observable;

import java.net.ConnectException;
import java.net.UnknownHostException;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.TimeoutException;

import static com.ctm.commonlogging.common.LoggingArguments.kv;
import static java.util.Arrays.asList;
import static java.util.Collections.singletonList;
import static org.springframework.http.HttpStatus.NOT_FOUND;
import static org.springframework.http.HttpStatus.SERVICE_UNAVAILABLE;
import static org.springframework.http.MediaType.APPLICATION_JSON_VALUE;

@Service
public class InInIcwsService {
	private static final Logger LOGGER = LoggerFactory.getLogger(InInIcwsService.class);

	public static final String ININ_CONNECTION_TYPE = "urn:inin.com:connection:icAuthConnectionRequestSettings";
	public static final String SESSION_ID = "ININ-ICWS-Session-ID";
	public static final String CSRF_TOKEN = "ININ-ICWS-CSRF-Token";

	public static final List<String> SUBSCRIPTION_ATTRIBUTES = asList("Eic_CallIdKey", "Eic_State", "Eic_CallStateString");
	public static final String CIC_URL = "cicUrl";
	private static final String CONNECTION_URL = "${cicUrl}/connection";
	private static final String QUEUE_SUBSCRIPTION_URL = "${cicUrl}/${sessionId}/messaging/subscriptions/queues/${subscriptionName}";
	private static final String MESSAGES_URL = "${cicUrl}/${sessionId}/messaging/messages";
	private static final String SECURE_PAUSE_URL = "${cicUrl}/${sessionId}/interactions/${interactionId}/secure-pause";
	public static final int DELAY = 500;
	public static final int ATTEMPTS = 2;
	public static final String XPATH_CURRENT_INTERACTION_ID = "current/icwsInteractionId";
	public static final int XPATH_SEQUENCE_INTERACTION_ID = -99;

	private SerializationMappers jacksonMappers;
	private InInConfig inInConfig;
	private Client<ConnectionReq, ConnectionResp> connectionClient;
	private Client<QueueSubscriptionReq, String> queueSubscriptionClient;
	private Client<String, List<Message>> messageClient;
	private Client<SecurePause, String> securePauseClient;

	@Autowired
	public InInIcwsService(SerializationMappers jacksonMappers, InInConfig inInConfig,
						   Client<ConnectionReq, ConnectionResp> connectionClient,
						   Client<QueueSubscriptionReq, String> queueSubscriptionClient,
						   Client<String, List<Message>> messageClient,
						   Client<SecurePause, String> securePauseClient) {
		this.jacksonMappers = jacksonMappers;
		this.inInConfig = inInConfig;
		this.connectionClient = connectionClient;
		this.queueSubscriptionClient = queueSubscriptionClient;
		this.messageClient = messageClient;
		this.securePauseClient = securePauseClient;
	}

	public Observable<PauseResumeResponse> pause(final String agentUsername, final Optional<String> interactionId) {
		return securePause(SecurePauseType.PAUSE_WITH_INFINITE_TIMEOUT, agentUsername, interactionId);
	}

	public Observable<PauseResumeResponse> resume(final String agentUsername, final Optional<String> interactionId) {
		return securePause(SecurePauseType.RESUME_RECORDING, agentUsername, interactionId);
	}

	private Observable<PauseResumeResponse> securePause(final SecurePauseType securePauseType, final String agentUsername, final Optional<String> interactionId) {
		return securePause(inInConfig.getCicPrimaryUrl(), securePauseType, agentUsername)
				.onErrorResumeNext(t -> failover(t, inInConfig.getCicFailoverUrl(), securePauseType, agentUsername))
				.onErrorReturn(throwable -> handleSecurePauseError(securePauseType, agentUsername, throwable));
	}

	private Observable<PauseResumeResponse> failover(Throwable throwable, final String cicUrl, final SecurePauseType securePauseType, final String agentUsername) {
		if (shouldFailover(throwable)) {
			LOGGER.info("securepause failed switching to failover");
			return securePause(cicUrl, securePauseType, agentUsername);
		}
		return Observable.error(throwable);
	}

	private boolean shouldFailover(Throwable throwable) {
		return isHttpStatusException(throwable, SERVICE_UNAVAILABLE)
			|| isHttpStatusException(throwable, NOT_FOUND)
			|| throwable instanceof TimeoutException
			|| throwable instanceof UnknownHostException
			|| throwable instanceof ConnectException;
	}

	public static boolean isHttpStatusException(final Throwable throwable, final HttpStatus httpStatus) {
		return throwable instanceof HttpStatusCodeException && ((HttpStatusCodeException) throwable).getStatusCode() == httpStatus;
	}

	private Observable<PauseResumeResponse> securePause(final String cicUrl, final SecurePauseType securePauseType, final String agentUsername) {
		// Get session connection
		return connection(cicUrl)
				.flatMap(connectionResp ->
						// Put a subscription on agent activity
						queueSubscription(cicUrl, agentUsername, connectionResp)
								.delay(1, TimeUnit.SECONDS)
								// Get messages of agent activity (should give us the current phone call status)
								.flatMap(s -> getInteractionId(cicUrl, connectionResp))
								// Pause or resume the call
								.flatMap(interaction -> securePauseRequest(cicUrl, securePauseType, interaction , connectionResp ))
							    .flatMap(pauseResp -> Observable.just(PauseResumeResponse.success(pauseResp.getInteractionId())))
								.onErrorReturn(throwable -> handleSecurePauseError(securePauseType, agentUsername, throwable))
				);
	}


	public Observable<String> getCallId(final String agentUserName){
		String cicUrl = inInConfig.getCicPrimaryUrl();
		return connection(cicUrl)
				.flatMap(connectionResp ->
						// Put a subscription on agent activity
						queueSubscription(cicUrl, agentUserName, connectionResp)
								.delay(1, TimeUnit.SECONDS)
								// Get messages of agent activity (should give us the current phone call status)
								.flatMap(s -> getInteractionId(cicUrl, connectionResp))
								.flatMap(interaction -> Observable.just(interaction.getAttributes()))
								.flatMap(interactionAttributes -> Observable.just(interactionAttributes.getCallIdKey()))
								.onErrorReturn(throwable ->  throwable.getMessage())
				);
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
	private Observable<ResponseEntity<ConnectionResp>> connection(final String cicUrl) {
		final ConnectionReq connectionReq = new ConnectionReq(ININ_CONNECTION_TYPE, inInConfig.getCicApplicationName(),
				inInConfig.getCicUserId(), inInConfig.getCicPassword());
		final String url =  StrSubstitutor.replace(CONNECTION_URL, Collections.singletonMap(CIC_URL, cicUrl));
		RestSettings<ConnectionReq> settings = RestSettings.<ConnectionReq>builder()
				.header("Accept-Language", "en")
				.header("Content-Type", APPLICATION_JSON_VALUE)
				.request(connectionReq)
				.response(ConnectionResp.class)
				.retryAttempts(ATTEMPTS).retryDelay(DELAY)
				.url(url)
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
	private Observable<String> queueSubscription(final String cicUrl, final String username, final ResponseEntity<ConnectionResp> connectionResp) {
		final QueueSubscriptionReq subscriptionReq = new QueueSubscriptionReq(singletonList(new QueueId(QueueType.USER, username)), SUBSCRIPTION_ATTRIBUTES);
		final String url = createQueueSubscriptionUrl(cicUrl, connectionResp.getHeaders().get(SESSION_ID).get(0), "PhoneStatusSubscription");

		RestSettings<QueueSubscriptionReq> settings = authenticatedRestSettings(RestSettings.<QueueSubscriptionReq>builder(), connectionResp)
				.request(subscriptionReq)
				.response(String.class)
				.url(url)
				.retryAttempts(ATTEMPTS).retryDelay(DELAY)
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

	private Observable<Message> getMessages(final String cicUrl, final ResponseEntity<ConnectionResp> connectionResp) {
		final String sessionId = connectionResp.getHeaders().get(SESSION_ID).get(0);
		final String url = createMessagesUrl(cicUrl, sessionId);

		LOGGER.debug("Get messages: " + url);

		RestSettings<String> settings = authenticatedRestSettings(RestSettings.<String>builder(), connectionResp)
				.request(null)
				.response(new ParameterizedTypeReference<List<Message>>() {})
				.url(url)
				.retryAttempts(ATTEMPTS).retryDelay(DELAY)
				.build();
		return messageClient.get(settings).flatMap(Observable::<Message>from);
	}

	private Observable<Interaction> getInteractionId(final String cicUrl, final ResponseEntity<ConnectionResp> connectionResp) {
		final Observable<Message> messages = getMessages(cicUrl, connectionResp);
		final Observable<Optional<Interaction>> interaction = messages
				// Look at messages that have added or changed interactions
				.filter(message -> message.getInteractionsAdded().size() > 0 || message.getInteractionsChanged().size() > 0)
				// Smoosh all those interactions into a new stream
				.flatMap(msgs -> Observable.merge(Observable.from(msgs.getInteractionsAdded()), Observable.from(msgs.getInteractionsChanged())))
				.map(interactionDetails -> {
					LOGGER.info("Possible interaction: {}", interactionDetails);
					return interactionDetails;
				})
				// Find interaction with valid call state
				.filter(this::isValidInteractionState)
				.map(Optional::of)
				.firstOrDefault(Optional.empty());

		return interaction
				.flatMap(s -> {
					LOGGER.debug("getInteractionId: {}", s.get().getInteractionId());
					if (s.isPresent()) {
						return Observable.just(s.get());
					} else {
						return Observable.error(new Exception("Could not find valid interactionId"));
					}
				});
	}

	private boolean isValidInteractionState(final Interaction i) {
		// C = Connected - the call object is connected to a user at the Client level.
		return StringUtils.equalsIgnoreCase("C", i.getAttributes().callState);
	}

	/**
     * Trigger the secure pause/resume.
	 * @return InteractionId
	 */
	private Observable<SecurePauseResult> securePauseRequest(final String cicUrl, final SecurePauseType securePauseType, final Interaction interaction, final ResponseEntity<ConnectionResp> connectionResp) {
		final HttpHeaders headers = connectionResp.getHeaders();
		final String url = createSecurePauseUrl(cicUrl, interaction.getInteractionId(), headers);
		final SecurePause securePause = new SecurePause(securePauseType, 0);
		RestSettings<SecurePause> settings = authenticatedRestSettings(RestSettings.<SecurePause>builder(), connectionResp)
				.request(securePause)
				.response(String.class)
				.url(url)
				.retryAttempts(ATTEMPTS).retryDelay(DELAY)
				.build();
		return securePauseClient.post(settings).flatMap(body -> Observable.just(new SecurePauseResult(interaction.getAttributes().getCallIdKey(), body)));
	}

	private String createQueueSubscriptionUrl(final String cicUrl, final String sessionId, final String subscriptionName) {
		final Map<String, String> values = new HashMap<>();
		values.put(CIC_URL, cicUrl);
		values.put("sessionId", sessionId);
		values.put("subscriptionName", subscriptionName);
		return StrSubstitutor.replace(QUEUE_SUBSCRIPTION_URL, values);
	}

	private String createMessagesUrl(final String cicUrl, final String sessionId) {
		final Map<String, String> values = new HashMap<>();
		values.put(CIC_URL, cicUrl);
		values.put("sessionId", sessionId);
		return StrSubstitutor.replace(MESSAGES_URL, values);
	}

	private String createSecurePauseUrl(final String cicUrl, final String interactionId, final HttpHeaders headers) {
		final Map<String, String> values = new HashMap<>();
		values.put(CIC_URL, cicUrl);
		values.put("sessionId", headers.get(SESSION_ID).get(0));
		values.put("interactionId", interactionId);
		return StrSubstitutor.replace(SECURE_PAUSE_URL, values);
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
