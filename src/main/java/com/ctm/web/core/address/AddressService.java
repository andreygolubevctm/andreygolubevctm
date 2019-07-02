package com.ctm.web.core.address;

import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class AddressService {

  @Value("${address.service.url}")
  private String url;

  private static final Logger LOGGER = LoggerFactory.getLogger(AddressService.class);

  public String getSuburbs(String postcode) {
    RestTemplate restTemplate = new RestTemplate();
    String requestUrl = url + "/suburbpostcode/" + postcode;
    ResponseEntity<String> response = restTemplate.getForEntity(requestUrl, String.class);

    return response.getBody();
  }
}