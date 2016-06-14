package com.ctm.web.life.apply.adapter;

import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.life.apply.model.request.*;

public class LifeBrokerApplyServiceRequestAdapterTestUtils {

    public static void setRequestType(LifeApplyWebRequest lifeApplyWebRequest, String requestType) {
        LifeApplyRequest request = new LifeApplyRequest();
        lifeApplyWebRequest.setRequest(request);
        request.setType(requestType);
    }

    public static void setProductId(LifeApplyWebRequest request, String PRODUCT_ID) {
        Client client = request.getClient();
        if(client == null) {
            client = new Client();
        }
        LifeApplyProduct product = new LifeApplyProduct();
        product.setId(PRODUCT_ID);
        client.setProduct(product);
        request.setClient(client);
    }

    public static  void setPartnerQuote(LifeApplyWebRequest request, YesNo yn) {
        LifeApplyPartner partner = request.getPartner();
        if(partner == null) {
            partner = new LifeApplyPartner();
        }
        partner.setQuote(yn);
        request.setPartner(partner);
    }

    public static void setPartnerProductId(LifeApplyWebRequest request, String partnerProductId) {
        LifeApplyPartner partner = request.getPartner();
        if(partner == null) {
            partner = new LifeApplyPartner();
        }
        LifeApplyProduct product = new LifeApplyProduct();
        product.setId(partnerProductId);
        partner.setProduct(product);
        request.setPartner(partner);

    }
}
