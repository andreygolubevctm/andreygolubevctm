package com.ctm.web.homecontents.providers.model;

import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.homecontents.model.form.*;
import com.ctm.web.homecontents.providers.model.request.Address;
import com.ctm.web.homecontents.providers.model.request.BusinessActivity;
import com.ctm.web.homecontents.providers.model.request.*;
import com.ctm.web.homecontents.providers.model.request.LandlordDetails;
import com.ctm.web.homecontents.providers.model.request.Occupancy;
import com.ctm.web.homecontents.providers.model.request.PolicyHolder;
import com.ctm.web.homecontents.providers.model.request.Property;
import com.ctm.web.homecontents.providers.model.request.SecurityFeatures;
import com.ctm.web.homecontents.providers.model.request.WhenMovedIn;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;

public class RequestAdapter {

    public static HomeQuoteRequest adapt(HomeRequest homeRequest) {
        HomeQuoteRequest quoteRequest = new HomeQuoteRequest();
        final HomeQuote quote = homeRequest.getQuote();
        CoverTypeEnum coverType = CoverTypeEnum.fromDescription(quote.getCoverType());
        boolean isContentsCover = false;
        boolean isHomeCover = false;
        if (CoverTypeEnum.HOME_CONTENTS.equals(coverType)) {
            quoteRequest.setHomeCover(true);
            quoteRequest.setContentsCover(true);
            isContentsCover = true;
            isHomeCover = true;
        } else if (CoverTypeEnum.HOME.equals(coverType)) {
            quoteRequest.setHomeCover(true);
            isHomeCover = true;
        } else if (CoverTypeEnum.CONTENTS.equals(coverType)) {
            quoteRequest.setContentsCover(true);
            isContentsCover = true;
        }

        quoteRequest.setStartDate(parseAUSLocalDate(quote.getStartDate()));

        if (StringUtils.isNotBlank(quote.getHomeExcess())) {
            quoteRequest.setHomeExcess(Integer.parseInt(quote.getHomeExcess()));
        }
        if (StringUtils.isNotBlank(quote.getContentsExcess())) {
            quoteRequest.setContentsExcess(Integer.parseInt(quote.getContentsExcess()));
        }
        if (StringUtils.isNotBlank(quote.getBaseHomeExcess())) {
            quoteRequest.setHomeBaseExcess(Integer.parseInt(quote.getBaseHomeExcess()));
        }
        if (StringUtils.isNotBlank(quote.getBaseContentsExcess())) {
            quoteRequest.setContentsBaseExcess(Integer.parseInt(quote.getBaseContentsExcess()));
        }

        quoteRequest.setOccupancy(createOccupancy(quote.getOccupancy()));
        quoteRequest.setBusinessActivity(createBusinessActivity(quote.getBusinessActivity()));

        quoteRequest.setProperty(createProperty(quote.getProperty(), isContentsCover));
        if (isContentsCover) {
            quoteRequest.setContentsCoverAmounts(createContentsCoverAmounts(quote.getCoverAmounts()));
        }
        if (isHomeCover) {
            quoteRequest.setHomeCoverAmounts(createHomeCoverAmounts(quote.getCoverAmounts()));
        }

        quoteRequest.setMainPolicyHolder(createMainPolicyHolder(quote.getPolicyHolder()));

        if (StringUtils.isNotBlank(quote.getPolicyHolder().getJointDob())) {
            quoteRequest.setJointPolicyHolder(createJointPolicyHolder(quote.getPolicyHolder()));
        }

        quoteRequest.setRetiredResident(convertToOptionalBoolean(quote.getPolicyHolder().getRetired()));
        quoteRequest.setContact(createContact(quote.getPolicyHolder()));
        quoteRequest.setHadClaims(convertToBoolean(quote.hasDisclosures() ? quote.getDisclosures().getClaims() : "N"));
        quoteRequest.setUnderFinance(convertToOptionalBoolean(quote.isUnderFinance()));
        quoteRequest.setClientIp(homeRequest.getClientIpAddress());

        com.ctm.web.homecontents.model.form.LandlordDetails landlordDetails = quote.getLandlordDetails();

        if(landlordDetails != null){
            quoteRequest.setLandlordDetails(createLandlordDetails(landlordDetails));
        }

        return quoteRequest;
    }

    private static LandlordDetails createLandlordDetails(com.ctm.web.homecontents.model.form.LandlordDetails landlordDetails){
        LandlordDetails landlordDetailsProvider = new LandlordDetails();
        landlordDetailsProvider.setNumberOfTenants(landlordDetails.getNumberOfTenants());
        landlordDetailsProvider.setPropertyManagedBy(landlordDetails.getPropertyManagedBy());
        landlordDetailsProvider.setValidRentalLease(convertToBoolean(landlordDetails.isValidRentalLease()));
        landlordDetailsProvider.setWeeklyRentValue(landlordDetails.getWeeklyRentValue());
        landlordDetailsProvider.setPendingRentalLease(convertToBoolean(landlordDetails.getPendingRentalLease()));
        return landlordDetailsProvider;
    }

    private static Contact createContact(com.ctm.web.homecontents.model.form.PolicyHolder formPolicyHolder) {
        Contact contact = new Contact();
        contact.setEmail(formPolicyHolder.getEmail());
        contact.setPhone(formPolicyHolder.getPhone());
        return contact;
    }

    private static PolicyHolder createJointPolicyHolder(com.ctm.web.homecontents.model.form.PolicyHolder formPolicyHolder) {
        PolicyHolder policyHolder = new PolicyHolder();
        policyHolder.setTitle(formPolicyHolder.getJointTitle());
        policyHolder.setFirstName(formPolicyHolder.getJointFirstName());
        policyHolder.setSurname(formPolicyHolder.getJointLastName());
        policyHolder.setDateOfBirth(parseAUSLocalDate(formPolicyHolder.getJointDob()));
        return policyHolder;
    }

    private static PolicyHolder createMainPolicyHolder(com.ctm.web.homecontents.model.form.PolicyHolder formPolicyHolder) {
        PolicyHolder policyHolder = new PolicyHolder();
        policyHolder.setTitle(formPolicyHolder.getTitle());
        policyHolder.setFirstName(formPolicyHolder.getFirstName());
        policyHolder.setSurname(formPolicyHolder.getLastName());
        policyHolder.setDateOfBirth(parseAUSLocalDate(formPolicyHolder.getDob()));
        return policyHolder;
    }

    private static HomeCoverAmounts createHomeCoverAmounts(CoverAmounts coverAmounts) {
        HomeCoverAmounts homeCoverAmounts = new HomeCoverAmounts();
        homeCoverAmounts.setRebuildCost(new BigDecimal(coverAmounts.getRebuildCost()));
        return homeCoverAmounts;
    }

    private static ContentsCoverAmounts createContentsCoverAmounts(CoverAmounts coverAmounts) {
        ContentsCoverAmounts contentsCoverAmounts = new ContentsCoverAmounts();
        contentsCoverAmounts.setReplaceContentsCost(new BigDecimal(coverAmounts.getReplaceContentsCost()));
        contentsCoverAmounts.setContentsAbovePolicyLimits(convertToBoolean(coverAmounts.getAbovePolicyLimits()));
        if (convertToBoolean(coverAmounts.getItemsAway())) {
            contentsCoverAmounts.setPersonalEffects(createPersonalEffects(coverAmounts));
        }
        return contentsCoverAmounts;
    }

    private static PersonalEffects createPersonalEffects(CoverAmounts coverAmounts) {
        PersonalEffects personalEffects = new PersonalEffects();
        personalEffects.setUnspecifiedTotalCover(new BigDecimal(coverAmounts.getUnspecifiedCoverAmount()));
        if (convertToBoolean(coverAmounts.getSpecifyPersonalEffects())) {
            final SpecifiedPersonalEffect specifiedPersonalEffects = new SpecifiedPersonalEffect();
            final SpecifiedPersonalEffects formSpecifiedPersonalEffects = coverAmounts.getSpecifiedPersonalEffects();
            specifiedPersonalEffects.setBicycles(convertToBigDecimal(formSpecifiedPersonalEffects.getBicycle()));
            specifiedPersonalEffects.setMusicalInstruments(convertToBigDecimal(formSpecifiedPersonalEffects.getMusical()));
            specifiedPersonalEffects.setClothing(convertToBigDecimal(formSpecifiedPersonalEffects.getClothing()));
            specifiedPersonalEffects.setJewelleries(convertToBigDecimal(formSpecifiedPersonalEffects.getJewellery()));
            specifiedPersonalEffects.setSportingEquipment(convertToBigDecimal(formSpecifiedPersonalEffects.getSporting()));
            specifiedPersonalEffects.setPhotographicEquipment(convertToBigDecimal(formSpecifiedPersonalEffects.getPhoto()));
            personalEffects.setSpecifiedPersonalEffects(specifiedPersonalEffects);
        }
        return personalEffects;
    }

    private static BigDecimal convertToBigDecimal(String value) {
        if (value == null) return null;
        return new BigDecimal(value);
    }

    private static BusinessActivity createBusinessActivity(com.ctm.web.homecontents.model.form.BusinessActivity formBusinessActivity) {
        if (convertToBoolean(formBusinessActivity.getConducted())) {
            BusinessActivity businessActivity;
            if ("Home office".equals(formBusinessActivity.getBusinessType()) ||
                    "Surgery/consulting rooms".equals(formBusinessActivity.getBusinessType())) {
                BusinessActivityWithRoomQuantity businessActivityWithRoomQuantity = new BusinessActivityWithRoomQuantity();
                businessActivityWithRoomQuantity.setRoomsUsed(Integer.parseInt(formBusinessActivity.getRooms()));
                if (StringUtils.isNotBlank(formBusinessActivity.getEmployeeAmount())) {
                    businessActivityWithRoomQuantity.setNumberOfEmployees(Integer.parseInt(formBusinessActivity.getEmployeeAmount()));
                }
                businessActivity = businessActivityWithRoomQuantity;
            } else if ("Day care".equalsIgnoreCase(formBusinessActivity.getBusinessType())) {
                BusinessActivityWithPersonCapacity businessActivityWithPersonCapacity = new BusinessActivityWithPersonCapacity();
                businessActivityWithPersonCapacity.setNumberOfOccupants(Integer.parseInt(formBusinessActivity.getChildren()));
                businessActivityWithPersonCapacity.setRegistered(convertToBoolean(formBusinessActivity.getRegisteredDayCare()));
                businessActivity = businessActivityWithPersonCapacity;
            } else {
                businessActivity = new BusinessActivity();
            }
            businessActivity.setBusinessType(formBusinessActivity.getBusinessType());
            return businessActivity;
        }
        return null;
    }

    private static Occupancy createOccupancy(com.ctm.web.homecontents.model.form.Occupancy formOccupancy) {
        Occupancy occupancy = new Occupancy();
        occupancy.setOwnProperty(convertToBoolean(formOccupancy.getOwnProperty()));
        occupancy.setPrincipalResidence(convertToBoolean(formOccupancy.getPrincipalResidence()));
        occupancy.setHowOccupied(formOccupancy.getHowOccupied());
        occupancy.setWhenMovedIn(createWhenMovedIn(formOccupancy.getWhenMovedIn()));
        return occupancy;
    }

    private static WhenMovedIn createWhenMovedIn(com.ctm.web.homecontents.model.form.WhenMovedIn formWhenMovedIn) {
        WhenMovedIn whenMovedIn = null;
        if (formWhenMovedIn != null) {
            whenMovedIn = new WhenMovedIn();
            if (StringUtils.isNotBlank(formWhenMovedIn.getYear())) {
                whenMovedIn.setYear(formWhenMovedIn.getYear());
            }
            if (StringUtils.isNotBlank(formWhenMovedIn.getMonth())) {
                whenMovedIn.setMonth(Integer.parseInt(formWhenMovedIn.getMonth()) - 1);
            }
        }
        return whenMovedIn;
    }

    private static Property createProperty(com.ctm.web.homecontents.model.form.Property formProperty, boolean isContentsCover) {
        Property property = new Property();
        property.setAddress(createAddress(formProperty.getAddress()));
        property.setPropertyType(formProperty.getPropertyType());
        property.setOtherPropertyTypeDescription(formProperty.getBestDescribesHome());
        property.setWallMaterial(formProperty.getWallMaterial());
        property.setRoofMaterial(formProperty.getRoofMaterial());
        property.setYearBuilt(formProperty.getYearBuilt());
        property.setHeritageListed(convertToOptionalBoolean(formProperty.getIsHeritage()));
        property.setBodyCorporate(convertToBoolean(formProperty.getBodyCorp()));
        if (isContentsCover) {
            property.setSecurityFeatures(createSecurityFeatures(formProperty.getSecurityFeatures()));
        }
        return property;
    }

    private static SecurityFeatures createSecurityFeatures(com.ctm.web.homecontents.model.form.SecurityFeatures formSecurityFeatures) {
        if (formSecurityFeatures != null) {
            SecurityFeatures securityFeatures = new SecurityFeatures();
            securityFeatures.setInternalSiren(convertToOptionalBoolean(formSecurityFeatures.getInternalSiren()));
            securityFeatures.setExternalSiren(convertToOptionalBoolean(formSecurityFeatures.getExternalSiren()));
            securityFeatures.setBackToBase(convertToOptionalBoolean(formSecurityFeatures.getBackToBase()));
            securityFeatures.setStrobeLight(convertToOptionalBoolean(formSecurityFeatures.getStrobeLight()));
            return securityFeatures;
        }
        return null;
    }

    private static Address createAddress(com.ctm.web.homecontents.model.form.Address formAddress) {
        Address address = new Address();
        address.setFullAddress(formAddress.getFullAddressLineOne());
        if (StringUtils.isNotBlank(formAddress.getStreetNum())) {
            address.setStreetNumber(formAddress.getStreetNum());
        } else if (StringUtils.isNotBlank(formAddress.getHouseNoSel())) {
            address.setStreetNumber(formAddress.getHouseNoSel());
        }

        if (convertToBoolean(formAddress.getNonStd())) {
            address.setStreetName(formAddress.getNonStdStreet());
        } else {
            address.setStreetName(formAddress.getStreetName());
        }

        address.setPostCode(formAddress.getPostCode());
        address.setState(formAddress.getState());
        address.setSuburb(formAddress.getSuburbName());

        if (convertToBoolean(formAddress.getNonStd())) {
            address.setUnitNumber(formAddress.getUnitShop());
        } else if (StringUtils.isNotBlank(formAddress.getUnitSel())) {
            address.setUnitNumber(formAddress.getUnitSel());
        } else {
            address.setUnitNumber(formAddress.getUnitShop());
        }
        return address;
    }

    private static boolean convertToBoolean(String value) {
        if (value == null) return false;
        switch (value) {
            case "Y": return true;
            case "N": return false;
            default:
                throw new IllegalArgumentException("Can not convert [" + value + "] to boolean");
        }
    }

    private static Boolean convertToOptionalBoolean(String value) {
        if (value == null) return null;
        switch (value) {
            case "Y": return true;
            case "N": return false;
            default:
                throw new IllegalArgumentException("Can not convert [" + value + "] to boolean");
        }
    }

    public static MoreInfoRequest adapt(Brand brand, MoreInfoRequest moreInfoRequest, Optional<LocalDateTime> requestAt) {
        moreInfoRequest.setBrandCode(brand.getCode());
        requestAt.ifPresent(moreInfoRequest::setRequestAt);
        return moreInfoRequest;
    }


}
