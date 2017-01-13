package com.ctm.web.reward.utils;

import com.ctm.reward.model.OrderAddress;
import com.ctm.reward.model.OrderForm;
import com.ctm.reward.model.OrderHeader;
import com.ctm.reward.model.OrderLine;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.model.form.Address;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthRequest;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;
import java.util.Set;

public class RewardRequestParser {

    private static final String CURRENT_ROOT_ID = "current/rootId";
    private static final String XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID = "current/encryptedOrderLineId";
    private static final String PREFIX = "health/application/";

    private static OrderForm parseOrderFormRequest(final HttpServletRequest request, final Data dataBucket, final String saleStatus, final String campaignCode) {
        final Long rootId = Long.parseLong(dataBucket.getString(CURRENT_ROOT_ID));
        final Optional<String> encryptedOrderLineId = Optional.ofNullable(dataBucket.getString(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));

        final OrderLine orderLine = new OrderLine();
        orderLine.setCampaignCode(campaignCode);
        orderLine.setContactEmail(dataBucket.getString(PREFIX + "email"));
        orderLine.setEncryptedOrderLineId(encryptedOrderLineId.orElse(null));
        orderLine.setFirstName(dataBucket.getString(PREFIX + "primary/firstname"));
        orderLine.setLastName(dataBucket.getString(PREFIX + "primary/surname"));
        orderLine.setPhoneNumber(Optional.ofNullable(dataBucket.getString(PREFIX + "mobile"))
                .orElse(dataBucket.getString(PREFIX + "other")));

        final OrderHeader orderHeader = new OrderHeader();
        orderHeader.setOrderLine(orderLine);
        orderHeader.setRootId((int)(long)rootId); // TODO: fix this
        orderHeader.setSaleStatus(saleStatus);

        final OrderForm orderForm = new OrderForm();
        orderForm.setOrderHeader(orderHeader);

        return orderForm;

    }


    private static OrderForm parseOrderFormRequest(final HealthRequest healthRequest, final Optional<AuthenticatedData> authenticatedSessionData, final Data dataBucket, final String saleStatus, final String campaignCode) {
        final Long rootId = Long.parseLong(dataBucket.getString(CURRENT_ROOT_ID));
        final Optional<String> encryptedOrderLineId = Optional.ofNullable(dataBucket.getString(XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));

        final Application healthApplication = healthRequest.getHealth().getApplication();
        final Address healthPostalAddress =  healthApplication.getPostal();

        final OrderAddress orderAddress = new OrderAddress();
        orderAddress.setAddressType("P");
        orderAddress.setDpid(Integer.parseInt(healthPostalAddress.getDpId()));
        orderAddress.setPostcode(healthPostalAddress.getPostCode());
        orderAddress.setState(healthPostalAddress.getState());
        orderAddress.setSuburb(healthPostalAddress.getSuburb());
        orderAddress.setStreetName(healthPostalAddress.getStreetName());
        orderAddress.setUnitNumber(healthPostalAddress.getUnitSel());
        orderAddress.setUnitType(healthPostalAddress.getUnitType());

        final OrderLine orderLine = new OrderLine();
        orderLine.setCampaignCode(campaignCode);
        orderLine.setContactEmail(healthApplication.getEmail());
        orderLine.setEncryptedOrderLineId(encryptedOrderLineId.orElse(null));
        orderLine.setFirstName(healthApplication.getPrimary().getFirstname());
        orderLine.setLastName(healthApplication.getPrimary().getSurname());
        orderLine.setPhoneNumber(Optional.ofNullable(healthApplication.getMobile())
                .orElse(healthApplication.getOther()));
        orderLine.getOrderAddresses().add(orderAddress);

        final OrderHeader orderHeader = new OrderHeader();
        orderHeader.setOrderLine(orderLine);
        orderHeader.setRootId((int)(long)rootId); // TODO: fix this
        orderHeader.setSaleStatus(saleStatus);

        final OrderForm orderForm = new OrderForm();
        orderForm.setOrderHeader(orderHeader);

        return orderForm;
    }
}
