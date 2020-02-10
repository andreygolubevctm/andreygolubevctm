package com.ctm.web.simples.phone.inin.model;


import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * Response class to map the response from ICWS ( Interaction Center Web Services) ( Dialler API)
 */

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class DiallerResponse {

    private String interactionId;

    private String callSnippingDialerResponseMessage;
}
