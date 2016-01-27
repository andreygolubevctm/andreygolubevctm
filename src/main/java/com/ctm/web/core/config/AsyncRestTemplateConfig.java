package com.ctm.web.core.config;

import com.ctm.interfaces.common.util.SerializationMappers;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.nio.client.HttpAsyncClientBuilder;
import org.apache.http.impl.nio.client.HttpAsyncClients;
import org.apache.http.nio.conn.ssl.SSLIOSessionStrategy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.HttpComponentsAsyncClientHttpRequestFactory;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.web.client.AsyncRestTemplate;

import java.util.List;
import java.util.stream.Collectors;

@Configuration
public class AsyncRestTemplateConfig {

    @Autowired
    private SerializationMappers jacksonMappers;

    @Bean
    public AsyncRestTemplate asyncRestTemplate() {
        final HttpAsyncClientBuilder clientBuilder = HttpAsyncClients.custom();

        if (proxyAuthenticationRequired()) {
            clientBuilder.useSystemProperties()
                    .setDefaultCredentialsProvider(createCredentialsProvider());
        }

        final AsyncRestTemplate template = new AsyncRestTemplate(new HttpComponentsAsyncClientHttpRequestFactory(clientBuilder.build()));

        MappingJackson2HttpMessageConverter jsonMessageConverter = new MappingJackson2HttpMessageConverter();
        jsonMessageConverter.setObjectMapper(jacksonMappers.getJsonMapper());

        // Replace the default
        List<HttpMessageConverter<?>> converters = template.getMessageConverters().stream().filter(c -> !(c instanceof MappingJackson2HttpMessageConverter)).collect(Collectors.toList());
        converters.add(jsonMessageConverter);
        template.setMessageConverters(converters);

        return template;
    }

    @Bean
    public AsyncRestTemplate asyncRestTemplateDisabledCnCheck() {

        final HttpAsyncClientBuilder clientBuilder = HttpAsyncClients.custom();

        // set this outbound parameter disableCNCheck to true if the url fails to validate with the certificate CN
        clientBuilder.setHostnameVerifier(SSLIOSessionStrategy.ALLOW_ALL_HOSTNAME_VERIFIER);

        if (proxyAuthenticationRequired()) {
            clientBuilder.useSystemProperties()
                    .setDefaultCredentialsProvider(createCredentialsProvider());
        }
        return new AsyncRestTemplate(new HttpComponentsAsyncClientHttpRequestFactory(clientBuilder.build()));

    }

    /**
     * This is needed to get through the proxy dev machines sit behind.
     *
     * @return CredentialsProvider containing credentials to get through the proxy
     */
    private static CredentialsProvider createCredentialsProvider() {
        final CredentialsProvider credentialsProvider = new BasicCredentialsProvider();
        credentialsProvider.setCredentials(
                new AuthScope(System.getProperty("https.proxyHost"),
                        Integer.parseInt(System.getProperty("https.proxyPort", "8080"))),
                new UsernamePasswordCredentials(System.getProperty("https.proxyUser", "ittest"),
                        System.getProperty("https.proxyPassword", "1tt3st")));
        return credentialsProvider;
    }

    private static boolean proxyAuthenticationRequired() {
        return System.getProperty("https.proxyUser") != null;
    }
}
