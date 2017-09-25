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
        resultsProperties.forEach(resultProperty -> {
            System.out.println("" + resultProperty.getProperty() + ":" +  resultProperty.getValue());
        } );
        emailRequest.setProvider(providerName);
        emailRequest.setProviderPhoneNumber(providerPhoneNumber);
        String email = getEmail(data);
        if(!StringUtils.isBlank(email)) emailRequest.setEmailAddress(email);
    }

    private List<String> getAllResultProperties(List<ResultProperty> resultProperties, String property){
        return resultProperties.stream().filter(resultProperty -> resultProperty.getProperty().equals(property))
                .map(resultProperty -> resultProperty.getValue()).collect(Collectors.toList());
    }

    public String getEmail(Data data){
        return emailUtils.getParamSafely(data,  "/contact/email");
    }
}
