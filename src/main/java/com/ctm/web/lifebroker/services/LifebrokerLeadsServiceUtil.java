package com.ctm.web.lifebroker.services;

import com.ctm.web.core.leadService.model.CliReturnRequest;
import com.ctm.web.core.leadService.model.LeadOutcome;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.lifebroker.model.LifebrokerLead;
import com.ctm.web.lifebroker.model.LifebrokerLeadOutcome;
import com.ctm.web.core.utils.ObjectMapperUtil;
import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.util.concurrent.ListenableFuture;
import org.springframework.util.concurrent.ListenableFutureCallback;
import org.springframework.http.converter.xml.SimpleXmlHttpMessageConverter;
import org.springframework.web.client.AsyncRestTemplate;

import java.net.URI;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LifebrokerLeadsServiceUtil {
	private static final Logger LOGGER = LoggerFactory.getLogger(LifebrokerLeadsServiceUtil.class);

	private static AsyncRestTemplate restTemplate;

	static {
		restTemplate = new AsyncRestTemplate();

		List<HttpMessageConverter<?>> messageConverters = new ArrayList<>();
		MappingJackson2HttpMessageConverter jsonMessageConverter = new MappingJackson2HttpMessageConverter();
		jsonMessageConverter.setObjectMapper(ObjectMapperUtil.getObjectMapper());
		messageConverters.add(new SimpleXmlHttpMessageConverter());
		restTemplate.setMessageConverters(messageConverters);
	}

	public static ListenableFuture<ResponseEntity<LifebrokerLeadOutcome>> sendLifebrokerLeadRequest(final LifebrokerLead request, final String url) throws Exception {
		LOGGER.info("Sending request to LifebrokerLeadService {}", request);

		HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.APPLICATION_XML);
		headers.setAccept(Collections.singletonList(MediaType.APPLICATION_XML));
		headers.add("Authorization", "Basic " + getCredentials());
		HttpEntity<LifebrokerLead> entity = new HttpEntity<>(request, headers);

		return restTemplate.postForEntity(URI.create(url), entity, LifebrokerLeadOutcome.class);
	}

	private static String getCredentials() {
		String plainCreds = "UATcompthemkt:lI9hW2qIlx2f4G";
		if(EnvironmentService.getEnvironment() == EnvironmentService.Environment.PRO) {
			plainCreds = "compthemkt:lI9hW2qIlx2f4G";
		}
		byte[] plainCredsBytes = plainCreds.getBytes();
		byte[] base64CredsBytes = Base64.encodeBase64(plainCredsBytes);
		return new String(base64CredsBytes);
	}
}
