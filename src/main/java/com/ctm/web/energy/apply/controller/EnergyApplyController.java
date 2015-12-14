package com.ctm.web.energy.apply.controller;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.energyapply.model.request.application.address.AddressDetails;
import com.ctm.energyapply.model.request.application.address.ApplicationAddress;
import com.ctm.energyapply.model.request.application.address.State;
import com.ctm.energyapply.model.request.application.applicant.ApplicantDetails;
import com.ctm.energyapply.model.request.application.contact.ContactDetails;
import com.ctm.energyapply.model.request.relocation.RelocationDetails;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.ServiceRequestException;
import com.ctm.web.core.exceptions.ServiceConfigurationException;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.resultsData.model.ErrorInfo;
import com.ctm.web.core.resultsData.model.Info;
import com.ctm.web.core.router.CommonQuoteRouter;
import com.ctm.web.core.utils.MiscUtils;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.energy.apply.model.request.*;
import com.ctm.web.energy.apply.response.EnergyApplyWebResponseModel;
import com.ctm.web.energy.apply.services.EnergyApplyService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.validation.BindingResult;
import org.springframework.validation.ObjectError;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.util.Optional;

@Api(basePath = "/rest/energy", value = "Energy Apply")
@RestController
@RequestMapping("/rest/energy")
public class EnergyApplyController extends CommonQuoteRouter<EnergyApplyPostRequestPayload> {
    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyController.class);

    @Autowired
    EnergyApplyService energyService;

    @ApiOperation(value = "apply/apply.json", notes = "Submit an energy application", produces = "application/json")
    @RequestMapping(value = "/apply/apply.json",
            method = RequestMethod.POST,
            consumes = {MediaType.APPLICATION_FORM_URLENCODED_VALUE, "application/x-www-form-urlencoded;charset=UTF-8"},
            produces = MediaType.APPLICATION_JSON_VALUE)
    public EnergyApplyWebResponseModel getQuote(@ModelAttribute EnergyApplyPostRequestPayload applyPostReqestPayload,
                                                BindingResult result, HttpServletRequest request) throws IOException, ServiceConfigurationException, DaoException {
        LOGGER.info("Request parameters={}", MiscUtils.toJson(request.getParameterMap()));

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
        LOGGER.debug("energyApplyPostRequestPayload={}", MiscUtils.toJson(energyApplyPostRequestPayload));

        // Map EnergyApplicationDetails
        EnergyApplicationDetails.Builder energyApplicationDetailsBuilder = EnergyApplicationDetails.newBuilder();

        // - Partner
        Optional<Partner> partner = MiscUtils.resolve(() -> energyApplyPostRequestPayload.getUtilities().getPartner());
        if (partner.isPresent()) {
            energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.partnerUniqueCustomerId(partner.get().getUniqueCustomerId());
        }

        Optional<Details> details = MiscUtils.resolve(() ->
                energyApplyPostRequestPayload.getUtilities().getApplication().getDetails());


        if (details.isPresent()) {
            // - ApplicantDetails
            ApplicantDetails applicantDetails = ApplicantDetails.newBuilder()
                    .firstName(details.get().getFirstName())
                    .lastName(details.get().getLastName())
                    .title(details.get().getTitle())
                    .dateOfBirth(LocalDateUtils.parseAUSLocalDate(details.get().getDob()))
                    .build();
            energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.applicantDetails(applicantDetails);

            // - ContactDetails
            ContactDetails contactDetails = ContactDetails.newBuilder()
                    .email(details.get().getEmail())
                    .mobileNumber(details.get().getMobileNumberinput())
                    .otherPhoneNumber(details.get().getOtherPhoneNumberinput())
                    .build();
            energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.contactDetails(contactDetails);

            // -- Supply address
            Optional<Address> houseAddress = MiscUtils.resolve(() ->
                    energyApplyPostRequestPayload.getUtilities().getApplication().getDetails().getAddress());

            AddressDetails.Builder supplyAddressBuilder = AddressDetails.newBuilder();
            if (houseAddress.isPresent()) {
                supplyAddressBuilder.unitNumber(houseAddress.get().getUnitShop())
                        .streetNumber(houseAddress.get().getStreetNum())
                        .suburbName(houseAddress.get().getSuburbName())
                        .state(State.valueOf(houseAddress.get().getState()));
                if (YesNo.Y.equals(houseAddress.get().getNonStd())) {
                    supplyAddressBuilder.unitType(houseAddress.get().getNonStdUnitType())
                            .postcode(houseAddress.get().getNonStdPostCode())
                            .streetName(houseAddress.get().getNonStdStreet());
                } else {
                    supplyAddressBuilder.unitType(houseAddress.get().getUnitType())
                            .postcode(houseAddress.get().getPostCode())
                            .streetName(houseAddress.get().getStreetName());
                }
            }

            // -- Postal address
            Optional<Address> postalAddress = MiscUtils.resolve(() ->
                    energyApplyPostRequestPayload.getUtilities().getApplication().getDetails().getPostal());
            AddressDetails.Builder postalAddressBuilder = AddressDetails.newBuilder();
            if (postalAddress.isPresent()) {
                postalAddressBuilder.unitNumber(postalAddress.get().getUnitShop())
                        .streetNumber(postalAddress.get().getStreetNum())
                        .suburbName(postalAddress.get().getSuburbName())
                        .state(State.valueOf(postalAddress.get().getState()));

                // @TODO FIX ME !!! Bug in form, the postalAddress.nonStd field is not being set
                // if (YesNo.Y.equals(postalAddress.get().getNonStd()) {
                postalAddressBuilder.unitType(postalAddress.get().getNonStdUnitType())
                        .postcode(postalAddress.get().getNonStdPostCode())
                        .streetName(postalAddress.get().getNonStdStreet());
                //} else {
                if (postalAddress.get().getUnitType() != null) {
                    postalAddressBuilder.unitType(postalAddress.get().getUnitType());
                }
                if (postalAddress.get().getPostCode() != null) {
                    postalAddressBuilder.postcode(postalAddress.get().getPostCode());
                }
                if (postalAddress.get().getStreetName() != null) {
                    postalAddressBuilder.streetName(postalAddress.get().getStreetName());
                }
                // }

                // - Household
                Optional<HouseholdDetails> householdDetails = MiscUtils.resolve(() -> energyApplyPostRequestPayload.getUtilities().getHouseholdDetails());
                if (householdDetails.isPresent()) {
                    RelocationDetails.Builder relocationDetailsBuilder = RelocationDetails.newBuilder();
                    if (YesNo.Y.equals(householdDetails.get().getMovingIn())) {
                        relocationDetailsBuilder = relocationDetailsBuilder
                                .movingIn(true)
                                .movingDate(LocalDateUtils.parseAUSLocalDate(details.get().getMovingDate()));
                    }
                    energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.relocationDetails(relocationDetailsBuilder.build());
                }

            }

            ApplicationAddress address = ApplicationAddress.newBuilder()
                    .supplyAddressDetails(supplyAddressBuilder.build())
                    .postalAddressDetails(postalAddressBuilder.build())
                    .postalMatch(YesNo.Y.equals(details.get().getPostalMatch()))
                    .build();
            energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.address(address);
        }

        EnergyApplicationDetails energyApplicationDetails = energyApplicationDetailsBuilder.build();
        LOGGER.debug("energyApplicationDetails={}", MiscUtils.toJson(energyApplicationDetails));

        return energyApplicationDetails;
    }


    //@TODO Run the service request through the hibernate validator and then throw a ServiceRequestException
    @ExceptionHandler
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public ErrorInfo handleException(final ServiceRequestException e) {
        LOGGER.error("Failed to handle request", e);
        ErrorInfo errorInfo = new ErrorInfo();
        errorInfo.setTransactionId(e.getTransactionId());
        errorInfo.setErrors(e.getErrors());
        return errorInfo;
    }

}
