package com.ctm.web.energy.apply.adapter;

import com.ctm.energyapply.model.request.EnergyApplicationDetails;
import com.ctm.energyapply.model.request.application.address.AddressDetails;
import com.ctm.energyapply.model.request.application.address.ApplicationAddress;
import com.ctm.energyapply.model.request.application.address.State;
import com.ctm.energyapply.model.request.application.applicant.ApplicantDetails;
import com.ctm.energyapply.model.request.application.contact.ContactDetails;
import com.ctm.energyapply.model.request.relocation.RelocationDetails;
import com.ctm.web.core.model.formData.YesNo;
import com.ctm.web.core.utils.MiscUtils;
import com.ctm.web.core.utils.common.utils.LocalDateUtils;
import com.ctm.web.energy.apply.model.request.Address;
import com.ctm.web.energy.apply.model.request.Details;
import com.ctm.web.energy.apply.model.request.EnergyApplyPostRequestPayload;
import com.ctm.web.energy.apply.model.request.Partner;
import com.ctm.web.energy.form.model.HouseHoldDetailsWebRequest;
import com.ctm.web.energy.quote.adapter.WebRequestAdapter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.Optional;

/**
 * Created by lbuchanan on 30/11/2015.
 */
public class EnergyApplyServiceRequestAdapter implements WebRequestAdapter<EnergyApplyPostRequestPayload, EnergyApplicationDetails> {

    private static final Logger LOGGER = LoggerFactory.getLogger(EnergyApplyServiceRequestAdapter.class);


    @Override
    public EnergyApplicationDetails adapt(EnergyApplyPostRequestPayload energyApplyPostRequestPayload) {
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
            }

            // - Household
            Optional<HouseHoldDetailsWebRequest> householdDetails = MiscUtils.resolve(() -> energyApplyPostRequestPayload.getUtilities().getHouseholdDetails());
            if (householdDetails.isPresent()) {
                RelocationDetails.Builder relocationDetailsBuilder = RelocationDetails.newBuilder();
                if (YesNo.Y.equals(householdDetails.get().getMovingIn())) {
                    relocationDetailsBuilder = relocationDetailsBuilder
                            .movingIn(true)
                            .movingDate(LocalDateUtils.parseAUSLocalDate(details.get().getMovingDate()));
                }
                energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.relocationDetails(relocationDetailsBuilder.build());
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
}
