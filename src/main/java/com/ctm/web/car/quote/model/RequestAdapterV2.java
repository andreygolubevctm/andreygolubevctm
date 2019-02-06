package com.ctm.web.car.quote.model;

import com.ctm.web.car.model.form.*;
import com.ctm.web.car.quote.model.request.*;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static com.ctm.web.core.utils.common.utils.LocalDateUtils.parseAUSLocalDate;
import static java.util.Collections.emptyList;
import static java.util.stream.Collectors.toList;

public class RequestAdapterV2 {

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


        if (quoteRequest.getVehicle().getPassengerPayment() != null && quoteRequest.getVehicle().getPassengerPayment().equals("Y")) {
            quoteRequest.getVehicle().setUse("13"); // CAR-1170
        } else {
            // CAR-1170. For vehicle use, two new radio button introduced. Override created here so that the data team still get Y/N values for their report
            if (quoteRequest.getVehicle().getGoodsPayment() != null && quoteRequest.getVehicle().getGoodsPayment().equals("Y")) {
                quoteRequest.getVehicle().setUse("15"); // CAR-1170
            }
        }

        quoteRequest.setTypeOfCover(TypeOfCover.valueOf(carRequest.getQuote().getTypeOfCover()));

        quoteRequest.setClientIp(carRequest.getClientIpAddress());

        quoteRequest.setQuoteReferenceNumber(carQuote.getQuoteReferenceNumber());

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
        vehicle.setNvicCode(quoteVehicle.getNvicCode());
        vehicle.setColour(quoteVehicle.getColour());
        vehicle.setAnnualKilometres(Integer.parseInt(quoteVehicle.getAnnualKilometres()));
        vehicle.setHasDamage(convertToBoolean(quoteVehicle.getDamage()));
        vehicle.setFinanceType(quoteVehicle.getFinance());
        vehicle.setMarketValue(quoteVehicle.getMarketValue());
        vehicle.setHasModifications(convertToBoolean(quoteVehicle.getModifications()));
        vehicle.setRegistrationYear(quoteVehicle.getRegistrationYear());
        vehicle.setSecurityOption(quoteVehicle.getSecurityOption());
        vehicle.setUse(quoteVehicle.getUse());
        vehicle.setPassengerPayment(quoteVehicle.getPassengerPayment());
        vehicle.setGoodsPayment(quoteVehicle.getGoodsPayment());
        vehicle.setNonStandardAccessories(createNonStandardAccessories(carQuote));
        vehicle.setFactoryOptions(createFactoryOptions(carQuote));
        return vehicle;
    }

    private static List<String> createFactoryOptions(CarQuote carQuote) {
        return Optional.ofNullable(carQuote)
                .map(CarQuote::getOpts)
                .map(Opts::getOpt)
                .orElse(emptyList())
                .stream()
                .filter(opt -> opt != null)
                .collect(toList());
    }

    private static List<NonStandardAccessory> createNonStandardAccessories(CarQuote carQuote) {
        return Optional.ofNullable(carQuote)
                .map(CarQuote::getAccs)
                .map(Accs::getAcc)
                .orElse(emptyList())
                .stream()
                .filter(acc -> StringUtils.isNotBlank(acc.getSel()))
                .map(RequestAdapterV2::createAccessory)
                .collect(toList());
    }

    private static NonStandardAccessory createAccessory(Acc acc) {
        NonStandardAccessory accessory = new NonStandardAccessory();
        accessory.setCode(acc.getSel());
        return accessory;
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
        youngestDriver.setAnnualKilometres(young.getAnnualKilometres());
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

