package com.ctm.web.car.quote.model;

import com.ctm.web.car.model.form.*;
import com.ctm.web.car.quote.model.request.*;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;

public class RequestAdapter {

    public static CarQuoteRequest adapt(CarRequest carRequest) {

        CarQuoteRequest quoteRequest = new CarQuoteRequest();
        final CarQuote carQuote = carRequest.getQuote();
        final Options options = carQuote.getOptions();
        quoteRequest.setCommencementDate(parseAUSLocalDate(options.getCommencementDate()));

        if (StringUtils.isNotBlank(carQuote.getExcess())) {
            quoteRequest.setExcess(Integer.parseInt(carQuote.getExcess()));
        }
        if (StringUtils.isNotBlank(carQuote.getBaseExcess())) {
            quoteRequest.setBaseExcess(Integer.parseInt(carQuote.getBaseExcess()));
        }

        quoteRequest.setContact(createContact(carQuote.getContact()));
        quoteRequest.setDrivers(createDrivers(carQuote));
        quoteRequest.setRiskAddress(createRiskAddress(carQuote));
        quoteRequest.setVehicle(createVehicle(carQuote));

        if(carQuote.getFilter().getProviders() != null && !carQuote.getFilter().getProviders().isEmpty()){
            quoteRequest.setProviderFilter(carQuote.getFilter().getProviders());
        }

        return quoteRequest;
    }

    protected static com.ctm.web.car.quote.model.request.Vehicle createVehicle(CarQuote carQuote) {

        com.ctm.web.car.model.form.Vehicle quoteVehicle = carQuote.getVehicle();

        com.ctm.web.car.quote.model.request.Vehicle vehicle = new com.ctm.web.car.quote.model.request.Vehicle();
        vehicle.setMake(quoteVehicle.getMake());
        vehicle.setModel(quoteVehicle.getModel());
        vehicle.setYear(Integer.parseInt(quoteVehicle.getYear()));
        vehicle.setBody(quoteVehicle.getBody());
        vehicle.setTransmission(quoteVehicle.getTrans());
        vehicle.setFuelType(quoteVehicle.getFuel());
        vehicle.setRedbookCode(quoteVehicle.getRedbookCode());
        vehicle.setAnnualKilometres(quoteVehicle.getAnnualKilometres());
        vehicle.setHasDamage(convertToBoolean(quoteVehicle.getDamage()));
        vehicle.setFinanceType(quoteVehicle.getFinance());
        vehicle.setMarketValue(quoteVehicle.getMarketValue());
        vehicle.setHasModifications(convertToBoolean(quoteVehicle.getModifications()));
        vehicle.setRegistrationYear(quoteVehicle.getRegistrationYear());
        vehicle.setSecurityOption(quoteVehicle.getSecurityOption());
        vehicle.setUse(quoteVehicle.getUse());
        vehicle.setNonStandardAccessories(createNonStandardAccessories(carQuote));
        vehicle.setFactoryOptions(createFactoryOptions(carQuote));
        return vehicle;
    }

    private static List<String> createFactoryOptions(CarQuote carQuote) {
        List<String> options = new ArrayList<>();
        if (carQuote.getOpts() != null) {
            for (String s : carQuote.getOpts().values()) {
                options.add(s);
            }
        }
        return options;
    }

    private static List<NonStandardAccessory> createNonStandardAccessories(CarQuote carQuote) {
        List<NonStandardAccessory> accessories = new ArrayList<>();
        for (Acc acc : carQuote.getConvertedAccs().values()) {
            NonStandardAccessory accessory = new NonStandardAccessory();
            final boolean includedInPurchasePrice = convertToBoolean(acc.getInc());
            accessory.setIncludedInPurchasePrice(includedInPurchasePrice);
            if (!includedInPurchasePrice) {
                accessory.setPrice(new BigDecimal(acc.getPrc()));
            }
            accessory.setCode(acc.getSel());
            accessories.add(accessory);
        }
        return accessories;
    }


    private static com.ctm.web.car.quote.model.request.RiskAddress createRiskAddress(CarQuote carQuote) {
        com.ctm.web.car.quote.model.request.RiskAddress riskAddress = new com.ctm.web.car.quote.model.request.RiskAddress();
        final com.ctm.web.car.model.form.RiskAddress quoteAddress = carQuote.getRiskAddress();
        riskAddress.setFullAddressLineOne(quoteAddress.getFullAddressLineOne());
        if (StringUtils.isNotBlank(quoteAddress.getStreetNum())) {
            riskAddress.setStreetNum(quoteAddress.getStreetNum());
        } else if (StringUtils.isNotBlank(quoteAddress.getHouseNoSel())) {
            riskAddress.setStreetNum(quoteAddress.getHouseNoSel());
        }

        if (convertToBoolean(quoteAddress.getNonStd())) {
            riskAddress.setStreetName(quoteAddress.getNonStdStreet());
        } else {
            riskAddress.setStreetName(quoteAddress.getStreetName());
        }

        riskAddress.setPostCode(quoteAddress.getPostCode());
        riskAddress.setState(quoteAddress.getState());
        riskAddress.setSuburb(quoteAddress.getSuburbName());

        if (convertToBoolean(quoteAddress.getNonStd())) {
            riskAddress.setUnitNumber(quoteAddress.getUnitShop());
        } else if (StringUtils.isNotBlank(quoteAddress.getUnitSel())) {
            riskAddress.setUnitNumber(quoteAddress.getUnitSel());
        } else {
            riskAddress.setUnitNumber(quoteAddress.getUnitShop());
        }

        riskAddress.setParkingType(carQuote.getVehicle().getParking());
        return riskAddress;
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

    private static com.ctm.web.car.quote.model.request.Drivers createDrivers(CarQuote carQuote) {
        com.ctm.web.car.quote.model.request.Drivers drivers = new com.ctm.web.car.quote.model.request.Drivers();
        final com.ctm.web.car.model.form.Drivers quoteDrivers = carQuote.getDrivers();
        drivers.setRegularDriver(createRegularDriver(quoteDrivers.getRegular()));
        drivers.setYoungestDriver(createYoungestDriver(quoteDrivers.getYoung()));
        drivers.setDriversRestriction(carQuote.getOptions().getDriverOption());
        return drivers;
    }

    private static YoungestDriver createYoungestDriver(Young young) {
        if (young == null || !convertToBoolean(young.getExists())) return null;
        YoungestDriver youngestDriver = new YoungestDriver();
        youngestDriver.setDateOfBirth(parseAUSLocalDate(young.getDob()));
        youngestDriver.setLicenceAge(Integer.parseInt(young.getLicenceAge()));
        youngestDriver.setGender(GenderType.fromValue(young.getGender()));
        return youngestDriver;
    }

    private static RegularDriver createRegularDriver(Regular regular) {
        RegularDriver regularDriver = new RegularDriver();
        regularDriver.setFirstName(regular.getFirstname());
        regularDriver.setSurname(regular.getSurname());
        regularDriver.setDateOfBirth(parseAUSLocalDate(regular.getDob()));
        regularDriver.setHasClaims(regular.getClaims());
        regularDriver.setGender(GenderType.fromValue(regular.getGender()));
        regularDriver.setEmploymentStatus(regular.getEmploymentStatus());
        regularDriver.setLicenceAge(Integer.parseInt(regular.getLicenceAge()));
        regularDriver.setNoClaimsDiscount(Integer.parseInt(regular.getNcd()));
        regularDriver.setOwnsAnotherCar(convertToBoolean(regular.getOwnsAnotherCar()));
        return regularDriver;
    }

    private static com.ctm.web.car.quote.model.request.Contact createContact(com.ctm.web.car.model.form.Contact carContact) {
        com.ctm.web.car.quote.model.request.Contact contact = new com.ctm.web.car.quote.model.request.Contact();
        contact.setEmail(carContact.getEmail());
        contact.setPhone(carContact.getPhone());
        return contact;
    }

}

