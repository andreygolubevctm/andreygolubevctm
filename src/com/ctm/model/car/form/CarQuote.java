package com.ctm.model.car.form;

import org.apache.commons.lang3.StringUtils;

import java.lang.reflect.Method;
import java.util.Map;
import java.util.TreeMap;

public class CarQuote {

    private Map<String, String> accs;

    private String excess;

    private String baseExcess;

    private Contact contact;

    private Drivers drivers;

    private String fsg;

    private Journey journey;

    private Options options;

    private Map<String, String> opts;

    private String paymentType;

    private String privacyoptin;

    private RiskAddress riskAddress;

    private String terms;

    private Vehicle vehicle;

    private String renderingMode;

    private Map<String, Acc> convertedAccs;

    public Map<String, String> getAccs() {
        return accs;
    }

    public void setAccs(Map<String, String> accs) {
        this.accs = accs;
    }

    public String getExcess() {
        return excess;
    }

    public void setExcess(String excess) {
        this.excess = excess;
    }

    public String getBaseExcess() {
        return baseExcess;
    }

    public void setBaseExcess(String baseExcess) {
        this.baseExcess = baseExcess;
    }

    public Contact getContact() {
        return contact;
    }

    public void setContact(Contact contact) {
        this.contact = contact;
    }

    public Drivers getDrivers() {
        return drivers;
    }

    public void setDrivers(Drivers drivers) {
        this.drivers = drivers;
    }

    public String getFsg() {
        return fsg;
    }

    public void setFsg(String fsg) {
        this.fsg = fsg;
    }

    public Journey getJourney() {
        return journey;
    }

    public void setJourney(Journey journey) {
        this.journey = journey;
    }

    public Options getOptions() {
        return options;
    }

    public void setOptions(Options options) {
        this.options = options;
    }

    public Map<String, String> getOpts() {
        return opts;
    }

    public void setOpts(Map<String, String> opts) {
        this.opts = opts;
    }

    public String getPaymentType() {
        return paymentType;
    }

    public void setPaymentType(String paymentType) {
        this.paymentType = paymentType;
    }

    public String getPrivacyoptin() {
        return privacyoptin;
    }

    public void setPrivacyoptin(String privacyoptin) {
        this.privacyoptin = privacyoptin;
    }

    public RiskAddress getRiskAddress() {
        return riskAddress;
    }

    public void setRiskAddress(RiskAddress riskAddress) {
        this.riskAddress = riskAddress;
    }

    public String getTerms() {
        return terms;
    }

    public void setTerms(String terms) {
        this.terms = terms;
    }

    public Vehicle getVehicle() {
        return vehicle;
    }

    public void setVehicle(Vehicle vehicle) {
        this.vehicle = vehicle;
    }

    public String getRenderingMode() {
        return renderingMode;
    }

    public void setRenderingMode(String renderingMode) {
        this.renderingMode = renderingMode;
    }

    public Map<String, Acc> getConvertedAccs() {
        if (convertedAccs == null) {

            Map<String, Acc> result = new TreeMap<>();

            if (getAccs() != null) {
                for (String key : getAccs().keySet()) {
                    String[] params = StringUtils.split(key, ".");
                    String accName = params[0];
                    Acc acc = result.get(accName);
                    if (acc == null) {
                        acc = new Acc();
                        result.put(accName, acc);
                    }
                    String field = params[1];
                    try {
                        Method method = Acc.class.getDeclaredMethod("set" + StringUtils.capitalize(field), String.class);
                        method.invoke(acc, getAccs().get(key));
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                }
            }

            convertedAccs = result;

        }
        return convertedAccs;
    }

    public String createLeadFeedInfo() {
        String separator = "||";

        boolean okToCall = StringUtils.equals(contact.getOktocall(), "Y");

        Regular regular = null;
        if (drivers != null) {
            regular = drivers.getRegular();
        }

        // Create leadFeedInfo
        StringBuilder sb = new StringBuilder();
        if (okToCall && regular != null) {
            sb.append(fullName(regular));
        }
        sb.append(separator);
        if (okToCall && contact != null) {
            sb.append(StringUtils.trimToEmpty(contact.getPhone()));
        }
        sb.append(separator);
        if (okToCall && vehicle != null) {
            sb.append(StringUtils.trimToEmpty(vehicle.getRedbookCode()));
        }
        sb.append(separator);
        if (okToCall && riskAddress != null) {
            sb.append(StringUtils.trimToEmpty(riskAddress.getState()));
        }
        return sb.toString();
    }

    private String fullName(Regular regular) {
        if (regular == null) return null;
        return StringUtils.trimToEmpty(regular.getFirstname() + " " + regular.getSurname());
    }

}
