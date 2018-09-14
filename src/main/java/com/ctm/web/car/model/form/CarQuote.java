package com.ctm.web.car.model.form;

import com.ctm.energy.apply.model.request.application.address.State;
import com.ctm.web.car.quote.model.request.Filter;
import com.ctm.web.core.leadfeed.model.Address;
import com.ctm.web.core.leadfeed.model.CTMCarLeadFeedRequestMetadata;
import com.ctm.web.core.leadfeed.model.Person;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.apache.commons.lang3.StringUtils;

import javax.validation.Valid;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

import static com.ctm.web.car.leadfeed.services.CTM.CTMCarLeadFeedService.getJsonString;

public class CarQuote {

    public static final int LEAD_FEED_INFO_SIZE_V1 = 4;
    public static final int LEAD_FEED_INFO_SIZE_V2 = 6;
    public static final String YYYY_MM_DD = "yyyy/MM/dd";
    private static final Logger LOGGER = LoggerFactory.getLogger(CarQuote.class);
    private Accs accs;

    private String excess;

    private String baseExcess;

    private Contact contact;

    @Valid
    private Drivers drivers;

    private String fsg;

    private Journey journey;

    private Options options;

    private Opts opts;

    private String paymentType;

    private String privacyoptin;

    private RiskAddress riskAddress;

    private String terms;

    private Vehicle vehicle;

    private String renderingMode;

    private Filter filter;

    private String typeOfCover;

    private String quoteReferenceNumber;

    public CarQuote() {
        filter = new Filter();
    }

    public Accs getAccs() {
        return accs;
    }

    public void setAccs(Accs accs) {
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

    public Opts getOpts() {
        return opts;
    }

    public void setOpts(Opts opts) {
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

    public String getTypeOfCover() {
        return typeOfCover;
    }

    public void setTypeOfCover(String typeOfCover) {
        this.typeOfCover = typeOfCover;
    }

    public String getQuoteReferenceNumber() {
        return quoteReferenceNumber;
    }

    public void setQuoteReferenceNumber(String quoteReferenceNumber) {
        this.quoteReferenceNumber = quoteReferenceNumber;
    }


    /**
     * builds a string with lead feed info
     *
     * Note: update LEAD_FEED_INFO_SIZE constant when adding/removing appends.
     *
     * {@linkplain com.ctm.web.core.leadfeed.dao.BestPriceLeadsDao} will use this info to send leads.
     *
     * @return
     */
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

        //additional info required by lead feeds send to `ctm-leads`
        //Validation will be done when we send the lead. We don't have all required fields here (e.g., propensityScore)
        sb.append(separator);
        if(okToCall)sb.append(getJsonString(getPerson(regular, contact, riskAddress)));
        sb.append(separator);
        if(okToCall)sb.append(getJsonString(getCtmCarLeadFeedRequestMetadata(regular, options, vehicle, typeOfCover)));

        return sb.toString();
    }

    protected static CTMCarLeadFeedRequestMetadata getCtmCarLeadFeedRequestMetadata(final Regular regular, final Options options, final Vehicle vehicle, final String typeOfCover) {

        final CTMCarLeadFeedRequestMetadata metadata = new CTMCarLeadFeedRequestMetadata();

        metadata.setType(CTMCarLeadFeedRequestMetadata.MetadataType.CAR);
        if(options != null) metadata.setAgeRestriction(options.getDriverOption());
        if(regular != null) metadata.setNcdRating(regular.getNcd());
        if(vehicle != null) metadata.setVehicleDescription(vehicle.getMakeDes());
        metadata.setCoverType(typeOfCover);
        //Below values will only be available after results, and ranking
        metadata.setProviderQuoteRef(null);
        metadata.setProviderCode(null);
        metadata.setPropensityScore(null);
        return metadata;
    }

    protected Person getPerson(final Regular regular, final Contact contact, final RiskAddress riskAddress) {

        final Person person = new Person();

        if (regular != null) {
            person.setFirstName(regular.getFirstname());
            person.setLastName(regular.getSurname());
            person.setDob(buildDob(regular.getDob()));
        }

        if(contact != null) {
            person.setEmail(contact.getEmail());
            //contact.getPhone is same as contact.getPhoneInput except prior is escaped.
            person.setPhone(contact.getPhone());
            person.setMobile(contact.getPhone());
        }

        if(riskAddress != null){
            final Address address = new Address();
            address.setState(riskAddress.getState() == null ? null : State.valueOf(riskAddress.getState()));
            address.setSuburb(riskAddress.getSuburbName());
            address.setPostcode(riskAddress.getPostCode());
            person.setAddress(address);
        }

        return person;
    }

    /**
     * parse string with format `yyyy/MM/dd` to LocalDate
     *
     * @param dob string
     * @return dob in LocalDate format or null if unable to parse.
     */
    private String buildDob(final String dob) {
        LocalDate converted;
        DateTimeFormatter dateFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        if(StringUtils.isBlank(dob)){
            return null;
        }

        try {
            converted = LocalDate.parse(dob, dateFormat);
            return converted.format(dateFormat);
        }catch (DateTimeParseException e){
            LOGGER.info("[CarQuote] dateformat for yyyy-MM-dd failed for {}.", dob);
            try {
                 converted = LocalDate.parse(dob, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
                 return converted.format(dateFormat);
            }catch (DateTimeParseException error) {
                LOGGER.info("[CarQuote] dateformat for dd/MM/yyyy failed for {}.", dob);
                return null;
            }
        }
    }

    private String fullName(Regular regular) {
        if (regular == null) return null;
        return StringUtils.trimToEmpty(regular.getFirstname() + " " + regular.getSurname());
    }

    public Filter getFilter() {
        return filter;
    }

    public void setFilter(Filter filter) {
        this.filter = filter;
    }
}
