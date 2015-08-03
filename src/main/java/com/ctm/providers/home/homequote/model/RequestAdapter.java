package com.ctm.providers.home.homequote.model;

import com.ctm.model.home.form.CoverAmounts;
import com.ctm.model.home.form.HomeQuote;
import com.ctm.model.home.form.HomeRequest;
import com.ctm.model.home.form.SpecifiedPersonalEffects;
import com.ctm.providers.home.homequote.model.request.*;
import org.apache.commons.lang3.StringUtils;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import java.math.BigDecimal;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormat.forPattern("dd/MM/yyyy");

    public final static HomeQuoteRequest adapt(HomeRequest homeRequest) {
        HomeQuoteRequest quoteRequest = new HomeQuoteRequest();
        final HomeQuote quote = homeRequest.getHome();
        CoverTypeEnum coverType = CoverTypeEnum.fromCode(quote.getCoverType());
        boolean isContentsCover = false;
        boolean isHomeCover = false;
        if (CoverTypeEnum.HOME_CONTENTS.equals(coverType)) {
            quoteRequest.setHomeCover(true);
            quoteRequest.setContentsCover(true);
            isContentsCover = true;
        } else if (CoverTypeEnum.HOME.equals(coverType)) {
            quoteRequest.setHomeCover(true);
            isHomeCover = true;
        } else if (CoverTypeEnum.CONTENTS.equals(coverType)) {
            quoteRequest.setContentsCover(true);
            isContentsCover = true;
            isHomeCover = true;
        }

        quoteRequest.setStartDate(AUS_FORMAT.parseLocalDate(quote.getStartDate()));

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

//        quoteRequest.setContact(createContact(quote.getc));

        return quoteRequest;

    }

    private static PolicyHolder createJointPolicyHolder(com.ctm.model.home.form.PolicyHolder formPolicyHolder) {
        PolicyHolder policyHolder = new PolicyHolder();
        policyHolder.setTitle(formPolicyHolder.getJointTitle());
        policyHolder.setFirstName(formPolicyHolder.getJointFirstName());
        policyHolder.setSurname(formPolicyHolder.getJointLastName());
        policyHolder.setDateOfBirth(AUS_FORMAT.parseLocalDate(formPolicyHolder.getJointDob()));
        return policyHolder;
    }

    private static PolicyHolder createMainPolicyHolder(com.ctm.model.home.form.PolicyHolder formPolicyHolder) {
        PolicyHolder policyHolder = new PolicyHolder();
        policyHolder.setTitle(formPolicyHolder.getTitle());
        policyHolder.setFirstName(formPolicyHolder.getFirstName());
        policyHolder.setSurname(formPolicyHolder.getLastName());
        policyHolder.setDateOfBirth(AUS_FORMAT.parseLocalDate(formPolicyHolder.getDob()));
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
            specifiedPersonalEffects.setBicycles(convertToBigDecimal(formSpecifiedPersonalEffects.getBicycleentry()));
            specifiedPersonalEffects.setMusicalInstruments(convertToBigDecimal(formSpecifiedPersonalEffects.getMusicalentry()));
            specifiedPersonalEffects.setClothing(convertToBigDecimal(formSpecifiedPersonalEffects.getClothingentry()));
            specifiedPersonalEffects.setJewelleries(convertToBigDecimal(formSpecifiedPersonalEffects.getJewelleryentry()));
            specifiedPersonalEffects.setSportingEquipment(convertToBigDecimal(formSpecifiedPersonalEffects.getSportingentry()));
            specifiedPersonalEffects.setPhotographicEquipment(convertToBigDecimal(formSpecifiedPersonalEffects.getPhotoentry()));
            personalEffects.setSpecifiedPersonalEffects(specifiedPersonalEffects);
        }
        return personalEffects;
    }

    private static BigDecimal convertToBigDecimal(String value) {
        if (value == null) return null;
        return new BigDecimal(value);
    }

    private static BusinessActivity createBusinessActivity(com.ctm.model.home.form.BusinessActivity formBusinessActivity) {
        if (convertToBoolean(formBusinessActivity.getConducted())) {
            BusinessActivity businessActivity;
            if ("Home office".equals(formBusinessActivity.getBusinessType()) ||
                    "Surgery/consulting rooms".equals(formBusinessActivity.getBusinessType())) {
                BusinessActivityWithRoomQuantity businessActivityWithRoomQuantity = new BusinessActivityWithRoomQuantity();
                if (StringUtils.isNotBlank(formBusinessActivity.getEmployeeAmount())) {
                    businessActivityWithRoomQuantity.setNumberOfEmployees(Integer.parseInt(formBusinessActivity.getEmployeeAmount()));
                }
                businessActivity = businessActivityWithRoomQuantity;
            } else if ("Day care".equals(formBusinessActivity.getBusinessType())) {
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

    private static Occupancy createOccupancy(com.ctm.model.home.form.Occupancy formOccupancy) {
        Occupancy occupancy = new Occupancy();
        occupancy.setOwnProperty(convertToBoolean(formOccupancy.getOwnProperty()));
        occupancy.setPrincipalResidence(convertToBoolean(formOccupancy.getPrincipalResidence()));
        occupancy.setHowOccupied(formOccupancy.getHowOccupied());
        occupancy.setWhenMovedIn(createWhenMovedIn(formOccupancy.getWhenMovedIn()));
        return occupancy;
    }

    private static WhenMovedIn createWhenMovedIn(com.ctm.model.home.form.WhenMovedIn formWhenMovedIn) {
        WhenMovedIn whenMovedIn = new WhenMovedIn();
        whenMovedIn.setYear(formWhenMovedIn.getYear());
        if (StringUtils.isNotBlank(formWhenMovedIn.getMonth())) {
            whenMovedIn.setMonth(Integer.parseInt(formWhenMovedIn.getMonth()));
        }
        return whenMovedIn;
    }

    private static Property createProperty(com.ctm.model.home.form.Property formProperty, boolean isContentsCover) {
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

    private static SecurityFeatures createSecurityFeatures(com.ctm.model.home.form.SecurityFeatures formSecurityFeatures) {
        SecurityFeatures securityFeatures = new SecurityFeatures();
        securityFeatures.setInternalSiren(convertToOptionalBoolean(formSecurityFeatures.getInternalSiren()));
        securityFeatures.setExternalSiren(convertToOptionalBoolean(formSecurityFeatures.getExternalSiren()));
        securityFeatures.setBackToBase(convertToOptionalBoolean(formSecurityFeatures.getBackToBase()));
        securityFeatures.setStrobeLight(convertToOptionalBoolean(formSecurityFeatures.getStrobeLight()));
        return securityFeatures;
    }

    private static Address createAddress(com.ctm.model.home.form.Address formAddress) {
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


}
