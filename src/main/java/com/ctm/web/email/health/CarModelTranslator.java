package com.ctm.web.email.health;

import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.results.model.ResultProperty;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.email.EmailRequest;
import com.ctm.web.email.EmailUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Created by akhurana on 25/09/17.
 */
@Component
public class CarModelTranslator {

    @Autowired
    private EmailUtils emailUtils;

    public void setCarFields(EmailRequest emailRequest, String tranId, Data data) throws DaoException {
        List<ResultProperty> resultsProperties =  emailUtils.getResultPropertiesForTransaction(tranId);

        List<String> providerName = getAllResultProperties(resultsProperties, "productDes");
        List<String> providerPhoneNumber = getAllResultProperties(resultsProperties, "telNo");
        emailRequest.setProviders(providerName);
        emailRequest.setProviderPhoneNumbers(providerPhoneNumber);
        String email = emailUtils.getParamSafely(data,  "/quote/contact/email");
        if(!StringUtils.isBlank(email)) emailRequest.setEmailAddress(email);
    }

    private List<String> getAllResultProperties(List<ResultProperty> resultProperties, String property){
        return resultProperties.stream().filter(resultProperty -> resultProperty.getProperty().equals(property))
                .map(resultProperty -> resultProperty.getValue()).collect(Collectors.toList());
    }
}
