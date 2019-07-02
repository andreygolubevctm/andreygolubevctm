package com.ctm.web.address.services;

import org.springframework.http.HttpEntity;
import org.springframework.web.client.RestTemplate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;

import java.util.Arrays;

import com.ctm.web.address.model.Address;
import com.ctm.web.address.model.AddressSuburb;
import com.ctm.web.address.model.AddressSuburbRequest;

@Service
public class AddressService {

  @Value("${address.service.url}")
  private String url;

  public Address[] getSuburbs(String postcode) {
    RestTemplate restTemplate = new RestTemplate();
    String requestUrl = url + "/suburbpostcode/" + postcode;
    Address[] response = restTemplate.getForObject(requestUrl, Address[].class);

    return response;
  }

  public AddressSuburb[] getStreetSuburb(AddressSuburbRequest request) {
    RestTemplate restTemplate = new RestTemplate();
    HttpHeaders headers = new HttpHeaders();
    headers.setAccept(Arrays.asList(MediaType.APPLICATION_JSON));
    headers.setContentType(MediaType.APPLICATION_JSON);

    HttpEntity<AddressSuburbRequest> requestEntity = new HttpEntity<AddressSuburbRequest>(request, headers);

    String requestUrl = url + "/streetsuburb";
    AddressSuburb[] response = restTemplate.postForObject(requestUrl, requestEntity, AddressSuburb[].class);

    return response;
  }
}