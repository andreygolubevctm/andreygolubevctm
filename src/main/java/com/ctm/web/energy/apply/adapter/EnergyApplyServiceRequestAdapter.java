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
            energyApplicationDetailsBuilder = adaptApplicantDetails(energyApplicationDetailsBuilder, details);

            // - ContactDetails
            energyApplicationDetailsBuilder = adaptContactDetails(energyApplicationDetailsBuilder, details);

            // -- Supply address
            AddressDetails.Builder supplyAddressBuilder = adaptSupplyAddress(energyApplyPostRequestPayload);

            // -- Postal address
            Optional<AddressDetails> postalAddressBuilder = adaptPostal(energyApplyPostRequestPayload, YesNo.Y.equals(details.get().getPostalMatch()));

            // - Household
            energyApplicationDetailsBuilder = adaptHouseHold(energyApplyPostRequestPayload, energyApplicationDetailsBuilder, details, supplyAddressBuilder, postalAddressBuilder);
        }

        EnergyApplicationDetails energyApplicationDetails = energyApplicationDetailsBuilder.build();
        LOGGER.debug("energyApplicationDetails={}", MiscUtils.toJson(energyApplicationDetails));

        return energyApplicationDetails;
    }

    public String getProductId(EnergyApplyPostRequestPayload model) {
        return model.getUtilities().getApplication().getThingsToKnow().getHidden().getProductId();
    }

    private EnergyApplicationDetails.Builder adaptApplicantDetails(EnergyApplicationDetails.Builder energyApplicationDetailsBuilder, Optional<Details> details) {
        ApplicantDetails applicantDetails = ApplicantDetails.newBuilder()
                .firstName(details.get().getFirstName())
                .lastName(details.get().getLastName())
                .title(details.get().getTitle())
                .dateOfBirth(LocalDateUtils.parseAUSLocalDate(details.get().getDob()))
                .build();
        energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.applicantDetails(applicantDetails);
        return energyApplicationDetailsBuilder;
    }

    private EnergyApplicationDetails.Builder adaptContactDetails(EnergyApplicationDetails.Builder energyApplicationDetailsBuilder, Optional<Details> details) {
        ContactDetails contactDetails = ContactDetails.newBuilder()
                .email(details.get().getEmail())
                .mobileNumber(details.get().getMobileNumberinput())
                .otherPhoneNumber(details.get().getOtherPhoneNumberinput())
                .build();
        energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.contactDetails(contactDetails);
        return energyApplicationDetailsBuilder;
    }

    private AddressDetails.Builder adaptSupplyAddress(EnergyApplyPostRequestPayload energyApplyPostRequestPayload) {
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
        return supplyAddressBuilder;
    }

    private Optional<AddressDetails> adaptPostal(EnergyApplyPostRequestPayload energyApplyPostRequestPayload, boolean postalMatch) {
        Optional<Address> postalAddress = MiscUtils.resolve(() ->
                energyApplyPostRequestPayload.getUtilities().getApplication().getDetails().getPostal());
        AddressDetails.Builder postalAddressBuilder = AddressDetails.newBuilder();
        if (!postalMatch && postalAddress.isPresent()) {
            postalAddressBuilder.unitNumber(postalAddress.get().getUnitShop())
                    .streetNumber(postalAddress.get().getStreetNum())
                    .suburbName(postalAddress.get().getSuburbName())
                    .state(State.valueOf(postalAddress.get().getState()));
            postalAddressBuilder.unitType(postalAddress.get().getNonStdUnitType())
                    .postcode(postalAddress.get().getNonStdPostCode())
                    .streetName(postalAddress.get().getNonStdStreet());
            if (postalAddress.get().getUnitType() != null) {
                postalAddressBuilder.unitType(postalAddress.get().getUnitType());
            }
            if (postalAddress.get().getPostCode() != null) {
                postalAddressBuilder.postcode(postalAddress.get().getPostCode());
            }
            if (postalAddress.get().getStreetName() != null) {
                postalAddressBuilder.streetName(postalAddress.get().getStreetName());
            }
            return Optional.of(postalAddressBuilder.build());
        } else {
            return Optional.empty();
        }
    }

    private EnergyApplicationDetails.Builder adaptHouseHold(EnergyApplyPostRequestPayload energyApplyPostRequestPayload,
                                                            EnergyApplicationDetails.Builder energyApplicationDetailsBuilder, Optional<Details> details,
                                                            AddressDetails.Builder supplyAddressBuilder, Optional<AddressDetails> postalAddress) {
        Optional<HouseHoldDetailsWebRequest> householdDetails = MiscUtils.resolve(() -> energyApplyPostRequestPayload.getUtilities().getHouseholdDetails());
        if (householdDetails.isPresent()) {
            RelocationDetails.Builder relocationDetailsBuilder = RelocationDetails.newBuilder();
            relocationDetailsBuilder
                    .movingIn(YesNo.Y.equals(householdDetails.get().getMovingIn()));
            if (YesNo.Y.equals(householdDetails.get().getMovingIn())) {
                relocationDetailsBuilder.movingDate(LocalDateUtils.parseAUSLocalDate(details.get().getMovingDate()));
            }
            energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.relocationDetails(relocationDetailsBuilder.build());
        }

        ApplicationAddress address = ApplicationAddress.newBuilder()
                .supplyAddressDetails(supplyAddressBuilder.build())
                .postalAddressDetails(postalAddress)
                .postalMatch(YesNo.Y.equals(details.get().getPostalMatch()))
                .build();
        energyApplicationDetailsBuilder = energyApplicationDetailsBuilder.address(address);
        return energyApplicationDetailsBuilder;
    }
}
