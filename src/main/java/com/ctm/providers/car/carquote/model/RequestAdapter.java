package com.ctm.providers.car.carquote.model;

import com.ctm.model.car.form.*;
import com.ctm.providers.car.carquote.model.request.*;
import com.ctm.providers.car.carquote.model.request.Contact;
import com.ctm.providers.car.carquote.model.request.Drivers;
import com.ctm.providers.car.carquote.model.request.RiskAddress;
import com.ctm.providers.car.carquote.model.request.Vehicle;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class RequestAdapter {

    private static final DateTimeFormatter AUS_FORMAT = DateTimeFormatter.ofPattern("dd/MM/yyyy");

    public static CarQuoteRequest adapt(CarRequest carRequest) {

        CarQuoteRequest quoteRequest = new CarQuoteRequest();
        final CarQuote carQuote = carRequest.getQuote();
        final Options options = carQuote.getOptions();
        quoteRequest.setCommencementDate(LocalDate.parse(options.getCommencementDate(), AUS_FORMAT));

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

    protected static Vehicle createVehicle(CarQuote carQuote) {

        com.ctm.model.car.form.Vehicle quoteVehicle = carQuote.getVehicle();

        Vehicle vehicle = new Vehicle();
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


    private static RiskAddress createRiskAddress(CarQuote carQuote) {
        RiskAddress riskAddress = new RiskAddress();
        final com.ctm.model.car.form.RiskAddress quoteAddress = carQuote.getRiskAddress();
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

    private static Drivers createDrivers(CarQuote carQuote) {
        Drivers drivers = new Drivers();
        final com.ctm.model.car.form.Drivers quoteDrivers = carQuote.getDrivers();
        drivers.setRegularDriver(createRegularDriver(quoteDrivers.getRegular()));
        drivers.setYoungestDriver(createYoungestDriver(quoteDrivers.getYoung()));
        drivers.setDriversRestriction(carQuote.getOptions().getDriverOption());
        return drivers;
    }

    private static YoungestDriver createYoungestDriver(Young young) {
        if (young == null || !convertToBoolean(young.getExists())) return null;
        YoungestDriver youngestDriver = new YoungestDriver();
        youngestDriver.setDateOfBirth(LocalDate.parse(young.getDob(), AUS_FORMAT));
        youngestDriver.setLicenceAge(Integer.parseInt(young.getLicenceAge()));
        youngestDriver.setGender(GenderType.fromValue(young.getGender()));
        return youngestDriver;
    }

    private static RegularDriver createRegularDriver(Regular regular) {
        RegularDriver regularDriver = new RegularDriver();
        regularDriver.setFirstName(regular.getFirstname());
        regularDriver.setSurname(regular.getSurname());
        regularDriver.setDateOfBirth(LocalDate.parse(regular.getDob(), AUS_FORMAT));
        regularDriver.setHasClaims(regular.getClaims());
        regularDriver.setGender(GenderType.fromValue(regular.getGender()));
        regularDriver.setEmploymentStatus(regular.getEmploymentStatus());
        regularDriver.setLicenceAge(Integer.parseInt(regular.getLicenceAge()));
        regularDriver.setNoClaimsDiscount(Integer.parseInt(regular.getNcd()));
        regularDriver.setOwnsAnotherCar(convertToBoolean(regular.getOwnsAnotherCar()));
        return regularDriver;
    }

    private static Contact createContact(com.ctm.model.car.form.Contact carContact) {
        Contact contact = new Contact();
        contact.setEmail(carContact.getEmail());
        contact.setPhone(carContact.getPhone());
        return contact;
    }

}

