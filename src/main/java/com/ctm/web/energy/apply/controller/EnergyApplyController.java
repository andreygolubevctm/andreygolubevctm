package com.ctm.web.energy.apply.controller;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.energyapply.model.request.application.address.Address;
import com.ctm.energyapply.model.request.application.address.AddressDetails;
import com.ctm.energyapply.model.request.application.address.State;
import com.ctm.energyapply.model.request.application.applicant.ApplicantDetails;
import com.ctm.energyapply.model.request.application.contact.ContactDetails;
import com.ctm.energyapply.model.request.household.HouseholdDetails;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.services.ApplicationService;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.energy.apply.model.request.Details;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.model.request.Partner;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.apply.services.EnergyApplyService;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

@Api(basePath = "/rest/energy", value = "Energy Apply")
@RestController
@RequestMapping("/rest/energy")
public class EnergyApplyController extends CommonQuoteRouter<EnergyApplyPostRequestPayload> {
    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyController.class);

    @Autowired
    EnergyApplyService energyService;

    @Autowired
    ApplicationService applicationService;

    @ApiOperation(value = "apply/apply.json", notes = "Submit an energy application", produces = "application/json")
    @RequestMapping(value = "/apply/apply.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyApplyWebResponseModel getQuote(@ModelAttribute EnergyApplyPostRequestPayload applyPostReqestPayload,
                                                BindingResult result, HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        if (result.hasErrors()) {
            for (ObjectError e : result.getAllErrors()) {
                LOGGER.error("FORM POST MAPPING ERROR: {},", e.toString());
            }
        }

        EnergyApplicationDetails energyApplicationDetails = mapPostRequestToModel(applyPostReqestPayload);

        Brand brand = initRouter(request, Vertical.VerticalType.ENERGY);
        updateTransactionIdAndClientIP(request, applyPostReqestPayload);
        EnergyApplyWebResponseModel outcome = energyService.apply(applyPostReqestPayload, brand);
        if (outcome != null) {
            Data dataBucket = getDataBucket(request, applyPostReqestPayload.getTransactionId());
            Info info = new Info();
            info.setTrackingKey(dataBucket.getString("data/utilities/trackingKey"));
            info.setTransactionId(applyPostReqestPayload.getTransactionId());
            outcome.setTransactionId(applyPostReqestPayload.getTransactionId());
        }
        return outcome;
    }


    private EnergyApplicationDetails mapPostRequestToModel(EnergyApplyPostRequestPayload energyApplyPostRequestPayload) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            LOGGER.info("EnergyApplyPostReqestPayload={}", mapper.writeValueAsString(energyApplyPostRequestPayload));
        } catch (Exception ex) {
            LOGGER.error("Exception occurred:", ex);
        }

        Details details = energyApplyPostRequestPayload.getUtilities().getApplication().getDetails();
        Partner partner = energyApplyPostRequestPayload.getUtilities().getPartner();
        ApplicantDetails applicantDetails = ApplicantDetails.newBuilder()
                .firstName(details.getFirstName())
                .lastName(details.getLastName())
                .title(details.getTitle())
                        //.dateOfBirth(energyApplyPostReqestPayload.getUtilities().getApplication().getDetails().getDob())
                .build();

        ContactDetails contactDetails = ContactDetails.newBuilder()
                .email(details.getEmail())
                .mobileNumber(details.getMobileNumberinput())
                .otherPhoneNumber(details.getOtherPhoneNumberinput())
                .build();

        HouseholdDetails householdDetails = HouseholdDetails.newBuilder()
                .location("")
                .movingDate(null)
                .movingIn(true)
                .postcode(null)
                .build();

        AddressDetails supplyAddress = AddressDetails.newBuilder()
                .streetNumber("")
                .addressType("")
                .lastSearch("")
                .fullAddress("")
                .dpId("")
                .unitType("")
                .unitNumber("")
                .streetName("")
                .suburbName("")
                .postcode("")
                .state(State.QLD)
                .postalMatch(true)
                .build();

        AddressDetails postalAddress = AddressDetails.newBuilder()
                .streetNumber("")
                .addressType("")
                .lastSearch("")
                .fullAddress("")
                .dpId("")
                .unitType("")
                .unitNumber("")
                .streetName("")
                .suburbName("")
                .postcode("")
                .state(State.QLD)
                .postalMatch(true)
                .build();

        Address address = Address.newBuilder()
                .postalAddressDetails(postalAddress)
                .supplyAddressDetails(supplyAddress)
                .postalMatch(true)
                .build();

        EnergyApplicationDetails energyApplicationDetails = EnergyApplicationDetails.newBuilder()
                .applicantDetails(applicantDetails)
                .contactDetails(contactDetails)
                .householdDetails(householdDetails)
                .address(address)
                .partnerUniqueCustomerId(partner.getUniqueCustomerId())
                .build();
        return energyApplicationDetails;
    }

}
