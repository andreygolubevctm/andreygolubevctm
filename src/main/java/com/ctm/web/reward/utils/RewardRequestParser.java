package com.ctm.web.reward.utils;

import com.ctm.reward.model.*;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.health.apply.model.request.contactDetails.PostalMatch;
import com.ctm.web.health.model.form.Address;
import com.ctm.web.health.model.form.Application;
import com.ctm.web.health.model.form.HealthRequest;
import com.ctm.web.reward.services.RewardService;

import java.util.Optional;

public class RewardRequestParser {

    private static final String CURRENT_ROOT_ID = "current/rootId";
    private static final String PREFIX = "health/application/";

    public OrderForm adaptFromDatabucket(final Optional<AuthenticatedData> authenticatedData,
                                         final Data dataBucket, final SaleStatus saleStatus, final String campaignCode) {
        final Long rootId = Long.parseLong(dataBucket.getString(CURRENT_ROOT_ID));
        final Optional<String> encryptedOrderLineId = Optional.ofNullable(dataBucket.getString(RewardService.XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));

        final OrderAddress orderAddress = new OrderAddress();
        String ADDRESS_PREFIX = PREFIX.concat("Y".equals(dataBucket.getString(PREFIX + "postalMatch")) ? "address/" : "postal/");

        orderAddress.setAddressType(AddressType.P);
        orderAddress.setDpid(dataBucket.getInteger(ADDRESS_PREFIX + "dpId"));
        orderAddress.setState(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "state"))
                .orElse(dataBucket.getString("health/situation/state")));
        orderAddress.setPostcode(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "postCode"))
                .orElse(dataBucket.getString("health/situation/postCode")));
        orderAddress.setSuburb(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "suburbName"))
                .orElse(dataBucket.getString("health/situation/suburb")));
        orderAddress.setStreetName(dataBucket.getString(ADDRESS_PREFIX + "streetNum") + " "
                + Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "streetName"))
                .orElse(dataBucket.getString(ADDRESS_PREFIX + "nonStdStreet")));
        orderAddress.setUnitNumber(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "unitShop"))
                .orElse(dataBucket.getString(ADDRESS_PREFIX + "unitSel")));
        orderAddress.setUnitType(dataBucket.getString(ADDRESS_PREFIX + "unitType"));
        orderAddress.setFullAddress(dataBucket.getString(ADDRESS_PREFIX + "fullAddress"));

        final OrderLine orderLine = new OrderLine();
        orderLine.setCampaignCode(campaignCode);
        orderLine.setContactEmail(dataBucket.getString(PREFIX + "email"));
        orderLine.setEncryptedOrderLineId(encryptedOrderLineId.orElse(null));
        orderLine.setFirstName(dataBucket.getString(PREFIX + "primary/firstname"));
        orderLine.setLastName(dataBucket.getString(PREFIX + "primary/surname"));
        orderLine.setPhoneNumber(Optional.ofNullable(dataBucket.getString(PREFIX + "mobile"))
                .orElse(dataBucket.getString(PREFIX + "other")));
        orderLine.getOrderAddresses().add(orderAddress);

        authenticatedData.map(AuthenticatedData::getUid).ifPresent(orderLine::setCreatedByOperator);

        final OrderHeader orderHeader = new OrderHeader();
        orderHeader.setOrderLine(orderLine);
        orderHeader.setRootId(rootId);
        orderHeader.setSaleStatus(saleStatus);

        final OrderForm orderForm = new OrderForm();
        orderForm.setOrderHeader(orderHeader);

        return orderForm;
    }

 /*   private static OrderForm parseOrderFormRequest(final HealthRequest healthRequest, final Optional<AuthenticatedData> authenticatedSessionData, final Data dataBucket, final String saleStatus, final String campaignCode) {
        final Long rootId = Long.parseLong(dataBucket.getString(CURRENT_ROOT_ID));
        final Optional<String> encryptedOrderLineId = Optional.ofNullable(dataBucket.getString(RewardService.XPATH_CURRENT_ENCRYPTED_ORDER_LINE_ID));

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
        orderHeader.setRootId(rootId); // TODO: fix this
        orderHeader.setSaleStatus(saleStatus);

        final OrderForm orderForm = new OrderForm();
        orderForm.setOrderHeader(orderHeader);

        return orderForm;
    }*/
}
