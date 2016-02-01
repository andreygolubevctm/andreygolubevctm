package com.ctm.web.simples.phone.inin;


import com.ctm.httpclient.Client;
import com.ctm.interfaces.common.types.ValueType;
import com.ctm.web.core.model.session.AuthenticatedData;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.inin.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import rx.Observable;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.regex.Pattern;

import static java.util.Collections.singletonList;
import static java.util.Collections.singletonMap;
import static java.util.stream.Collectors.toList;
import static org.apache.commons.lang3.text.StrSubstitutor.replace;
import static rx.Observable.just;

@Component
public class InInApi {
    public static final String T1 = "T1";
    public static final String T2 = "T2";
    public static final String I3_IDENTITY = "I3_IDENTITY";
    public static final String STATUS = "STATUS";
    public static final String PENDING_STATUS = "isPendingStatus";
    public static final String ZONE = "ZONE";
    public static final String BRAND_CODE = "brandCode";
    public static final String VERTICAL_CODE = "verticalCode";
    public static final String ROOT_ID = "rootId";
    public static final String SALESFORCE_ID = "salesForceId";
    public static final String TRANSACTION_ID = "transactionId";
    public static final String FIRST_NAME = "FirstName";
    public static final String LAST_NAME = "LastName";
    public static final String MOBILE = "Mobile";
    public static final String PHONE = "Home";
    public static final String EMAIL = "email";
    public static final String DOB = "DateOfBirth";
    public static final String STATE = "state";
    public static final String SUBURB = "suburb";
    public static final String POSTCODE = "postcode";
    public static final String GENDER = "gender";
    public static final String PARTNER_GENDER = "partnerGender";
    public static final String PARTNER_DOB = "partnerDateOfBirth";
    public static final String HEALTH_SITUATION = "healthSituation";
    public static final String HEALTH_LOOKING_TO = "healthLookingTo";
    public static final String HEALTH_PRIVATE_INSURANCE = "healthHasPrivate";
    public static final String HEALTH_PARTNER_PRIVATE_INSURANCE = "healthPartnerHasPrivate";
    public static final String HEALTH_APPLY_REBATE = "healthWantsToApplyRebate";
    public static final String HEALTH_SELECTED_BENEFITS = "healthSelectedBenefits";
    public static final String HEALTH_DEPENDANTS = "healthDependants";
    public static final String HEALTH_REBATE_TIER = "healthRebateTier";
    public static final String CAMPAIGN_ID = "CampaignID";
    public static final String DATE_IMPORTED = "DateImported";

    // search filters
    public static final String FILTER = "(brandCode='${brandCode}' AND verticalCode='${verticalCode}' AND status NOT IN ('I', 'E')" +
            " AND DateImported > Getdate()-${days}) AND (rootId='${rootId}'${mobileOrPhoneClause}) ORDER BY DateImported DESC";
    public static final String MOBILE_CLAUSE = " OR Mobile='${mobile}'";
    public static final String PHONE_CLAUSE = " OR Home='${home}'";
    private final Pattern LETTERS_ONLY = Pattern.compile("[a-zA-Z]+");
    private final Pattern NUMBERS_ONLY = Pattern.compile("[0-9]+");

    @Autowired
    private InInConfig inInConfig;
    @Autowired
    private Client<List<SearchWithFilter>, SearchWithFilterResults> searchClient;
    @Autowired
    private Client<List<InsertScheduleCall>, String> insertClient;
    @Autowired
    private Client<List<UpdateScheduleCall>, String> updateClient;
    @Autowired
    private Client<List<DeleteScheduleCall>, String> deleteClient;

    public Observable<Identity> searchScheduledCall(final Message message) {
        return searchFilter(message).flatMap(this::searchRequest);
    }

    public Observable<Boolean> insertScheduledCall(final Message message, final AuthenticatedData authenticatedData) {
        final List<Data> datas = createDatas(message);
        final InsertScheduleCall insert = new InsertScheduleCall(inInConfig.getCampaignName(), datas, message.getPhoneNumber1(), authenticatedData.getAgentId(), message.getWhenToAction().toString());
        return insertClient.post(singletonList(insert), String.class, inInConfig.getWsUrl() + "/InsertScheduleRecord")
                .flatMap(r -> {
                                    if (!r.equals("1 records success to insert.")) {
                                        return Observable.error(new IllegalStateException("Inserting dialler callback failed"));
                                    } else {
                                        return just(Boolean.TRUE);
                                    }
                                });
    }

    public Observable<Boolean> updateScheduledCall(final Identity identity, final Message message, final AuthenticatedData authenticatedData) {

        final UpdateScheduleCall update = new UpdateScheduleCall(inInConfig.getCampaignName(), new Data(I3_IDENTITY, identity.get()), "", authenticatedData.getAgentId(), message.getWhenToAction().toString());
        return updateClient.post(singletonList(update), String.class, inInConfig.getWsUrl() + "/InsertOrUpdateScheduleCallBacks")
                .flatMap(r -> {
                                if (!r.equals("1 records success to update.")) {
                                    return Observable.error(new IllegalStateException("Updating dialler callback failed"));
                                } else {
                                    return just(Boolean.TRUE);
                                }
                            });
    }

    public Observable<Boolean> deleteScheduledCall(final Identity identity) {

        final DeleteScheduleCall delete = new DeleteScheduleCall(inInConfig.getCampaignName(), new Data(I3_IDENTITY, identity.get()));
        return deleteClient.post(singletonList(delete), String.class, inInConfig.getWsUrl() + "/DeleteScheduleCallBacks")
                .flatMap(r -> {
                    if (!r.equals("1 records success to update.")) {
                        return Observable.error(new IllegalStateException("Updating dialler callback failed"));
                    } else {
                        return just(Boolean.TRUE);
                    }
                });

    }

//    public Observable<String> exclude(final List<Identity> identities) {
//        if (identities.isEmpty()) {
//            return Observable.empty();
//        } else {
//            final Observable<Identity> from = Observable.from(identities);
//            final Observable<Update> updates = from.map(i -> {
//                final List<Data> datas = new ArrayList<>();
//                addData(datas, STATUS, Status.E);
//                return new Update(inInConfig.getCampaignName(), new Data(I3_IDENTITY, i.get()), datas);
//            });
//            return updates.toList().flatMap(u -> updateClient.put(u, String.class, inInConfig.getWsUrl() + "/UpdateRecords"));
//        }
//    }

    private Observable<? extends Identity> searchRequest(final String f) {
        final List<SearchWithFilter> searches = Collections.singletonList(new SearchWithFilter(inInConfig.getCampaignName(), f));
        final String searchUrl = inInConfig.getWsUrl() + "/SearchRecordsWithFilter";
        final Observable<SearchWithFilterResults> results = searchClient.post(searches, SearchWithFilterResults.class, searchUrl);
        return results.flatMap(this::identity);
    }

    protected Observable<String> searchFilter(final Message message) {
        return Observable.create(s -> {
            try {
                final Map<String, Object> values = new HashMap<>();
                values.put("rootId", message.getTransactionId());
                values.put("days", inInConfig.getExpiry());
                values.put("mobileOrPhoneClause", mobileOrPhoneClause(message).toString());
                s.onNext(replace(FILTER, values));
                s.onCompleted();
            } catch (final Exception e) {
                s.onError(e);
            }
        });
    }

//    private String valididateString(final String s) throws IllegalArgumentException {
//        return validate(s, LETTERS_ONLY, "letters only");
//    }

    private String validateNumber(final String s) throws IllegalArgumentException {
        return validate(s, NUMBERS_ONLY, "numbers");
    }

    private String validate(final String s, final Pattern pattern, final String expectedType) {
        if (!pattern.matcher(s).matches()) {
            throw new IllegalArgumentException("Invalid search argument expected " + expectedType + " got " + s);
        }
        return s;
    }

    private StringBuilder mobileOrPhoneClause(final Message message) {

        final StringBuilder clauses = new StringBuilder();
        createMobile(message.getPhoneNumber1(), message.getPhoneNumber2())
                .ifPresent(mobile -> clauses.append(replace(MOBILE_CLAUSE, singletonMap("mobile", validateNumber(mobile)))));
        createPhone(message.getPhoneNumber1(), message.getPhoneNumber2())
                .ifPresent(phone -> clauses.append(replace(PHONE_CLAUSE, singletonMap("home", validateNumber(phone)))));
        return clauses;
    }

    protected Optional<String> createMobile(final String phoneNumber1, final String phoneNumber2) {
        if (phoneNumber1 != null && (phoneNumber1.startsWith("04") || phoneNumber1.startsWith("05"))) {
           return Optional.of(phoneNumber1);
        } else {
            return Optional.ofNullable(phoneNumber2);
        }
    }
    protected Optional<String> createPhone(final String phoneNumber1, final String phoneNumber2) {
        if (phoneNumber1 != null && !(phoneNumber1.startsWith("04") || phoneNumber1.startsWith("05"))) {
            return Optional.of(phoneNumber1);
        } else {
            return Optional.ofNullable(phoneNumber2);
        }
    }


    private Observable<Identity> identity(final SearchWithFilterResults searchResults) {
        final Observable<SearchResult> allSearchResults = Observable.from(searchResults.getResults()).flatMap(Observable::from);
        return allSearchResults.flatMap(this::getIdentity);
    }

    private Observable<Identity> getIdentity(final SearchResult searchResult) {
        final String i3_identity = searchResult.get().get(I3_IDENTITY);
        return i3_identity != null ?
            just(Identity.instanceOf(i3_identity))
            : Observable.error(new IllegalStateException("No I3 Identity key found"));
    }

    private List<Data> createDatas(final Message leadRequest) {
        final List<Data> datas = new ArrayList<>();
//        final Person person = leadRequest.getPerson();
//        final Address address = person.getAddress();
//
//        addData(datas, STATUS, Status.J); // records are always inserted with a J status
//        addData(datas, ZONE, address.getState());
//        addData(datas, SALESFORCE_ID, leadRequest.getSalesforceId().map(SalesforceId::get).orElse(""));
//        addData(datas, PENDING_STATUS, leadRequest.getStatus() == LeadStatus.PENDING);
//        addData(datas, VERTICAL_CODE, leadRequest.getVerticalType());
//        addData(datas, BRAND_CODE, leadRequest.getBrandCode());
//        addData(datas, CAMPAIGN_ID, inInConfig.getCampaignId());
//        addData(datas, T1, inInConfig.getDefaultT1());
//        addData(datas, T2, inInConfig.getDefaultT2());
//        addData(datas, ROOT_ID, leadRequest.getRootId().get());
//        addData(datas, TRANSACTION_ID, leadRequest.getTransactionId().get());
//        addData(datas, FIRST_NAME, person.getFirstName());
//        addData(datas, LAST_NAME, person.getLastName());
//        addData(datas, MOBILE, person.getMobile());
//        addData(datas, PHONE, person.getPhone());
//        addData(datas, EMAIL, person.getEmail());
//        addData(datas, DOB, person.getDob());
//        addData(datas, STATE, address.getState());
//        addData(datas, SUBURB, address.getSuburb());
//        addData(datas, POSTCODE, address.getPostcode());

        return datas;
    }

//    private void addData(final List<Data> datas, final String field, final Optional<?> value) {
//        value.ifPresent(v -> addData(datas, field, v));
//    }

    private void addData(final List<Data> datas, final String field, final Object value) {
        datas.add(createData(field, value));
    }

    @SuppressWarnings("unchecked")
    private Data createData(final String field, final Object v) {
        if (v instanceof String) {
            return new Data(field, (String) v);
        } else if (v instanceof Boolean) {
            final String s = (Boolean) v ? "1" : "0";
            return new Data(field, s);
        } else if (v instanceof List) {
            final List<Object> list = (List<Object>) v;
            final List<String> listOfStrings = list.stream().map(Object::toString).collect(toList());
            return new Data(field, String.join(",", listOfStrings));
        } else if (v instanceof ValueType) {
            return new Data(field, ((ValueType) v).get().toString());
        } else if (v instanceof Enum) {
            final Enum e = (Enum) v;
            return new Data(field, e.name());
        } else {
            return new Data(field, v.toString());
        }
    }

}
