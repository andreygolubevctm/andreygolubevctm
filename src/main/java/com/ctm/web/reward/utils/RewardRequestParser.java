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
        orderAddress.setStreetName(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "streetName"))
                .orElse(dataBucket.getString(ADDRESS_PREFIX + "nonStdStreet")));
        orderAddress.setStreetNumber(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "streetNum"))
                .orElse(dataBucket.getString(ADDRESS_PREFIX + "houseNoSel")));
        orderAddress.setUnitNumber(Optional.ofNullable(dataBucket.getString(ADDRESS_PREFIX + "unitSel"))
                .orElse(dataBucket.getString(ADDRESS_PREFIX + "unitShop")));
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
}
