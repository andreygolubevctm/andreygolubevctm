package com.ctm.web.simples.phone.inin;


import com.ctm.httpclient.Client;
import com.ctm.interfaces.common.types.ValueType;
import com.ctm.interfaces.common.types.VerticalType;
import com.ctm.web.simples.config.InInConfig;
import com.ctm.web.simples.model.Message;
import com.ctm.web.simples.phone.inin.model.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Component;
import rx.Observable;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.*;
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
    public static final String FILTER = "(verticalCode='${verticalCode}' AND status NOT IN ('I', 'E')" +
            " AND DateImported > Getdate()-${days}) AND (rootId='${rootId}'${mobileOrPhoneClause}) ORDER BY DateImported DESC";
    public static final String MOBILE_CLAUSE = " OR Mobile='${mobile}'";
    public static final String PHONE_CLAUSE = " OR Home='${home}'";
    private final Pattern LETTERS_ONLY = Pattern.compile("[a-zA-Z]+");
    private final Pattern NUMBERS_ONLY = Pattern.compile("[0-9]+");

    @Autowired private InInConfig inInConfig;
    @Autowired private Client<List<SearchWithFilter>, SearchWithFilterResults> searchClient;
    @Autowired private Client<List<Insert>, String> insertContactClient;
    @Autowired private Client<List<InsertScheduleCall>, List<String>> insertScheduleCallClient;
    @Autowired private Client<List<UpdateScheduleCall>, List<String>> updateScheduleCallClient;
    @Autowired private Client<List<DeleteScheduleCall>, List<String>> deleteScheduleCallClient;

    public Observable<I3Identity> searchLead(final Message message) {
        return searchFilter(message).flatMap(this::searchRequest);
    }

    public Observable<Boolean> insertLead(final Message message) {
        final List<Data> datas = createLeadDatas(message);
        addData(datas, DATE_IMPORTED, LocalDateTime.now());
        final Insert insert = new Insert(inInConfig.getCampaignName(), datas);
        return insertContactClient.post(singletonList(insert), String.class, inInConfig.getWsUrl() + "/InsertRecords").flatMap(r -> {
            if (!r.equals("1 records success to insert.")) {
                return Observable.error(new IllegalStateException("Inserting dialler record failed"));
            } else {
                return just(Boolean.TRUE);
            }
        });
    }

    public Observable<Boolean> insertScheduledCall(final Message message, final String agentUsername) {
        final List<Data> datas = createLeadDatas(message);
        final InsertScheduleCall insert = new InsertScheduleCall(inInConfig.getCampaignName(), datas, message.getPhoneNumber1(), agentUsername, message.getWhenToAction().toString());
        return insertScheduleCallClient.post(singletonList(insert), new ParameterizedTypeReference<List<String>>() {}, inInConfig.getWsUrl() + "/InsertScheduleRecord")
            .flatMap(r -> {
                if (r.size() != 1) {
                    return Observable.error(new IllegalStateException("Inserting dialler callback failed"));
                } else {
                    return just(Boolean.TRUE);
                }
            });
    }

    public Observable<Boolean> updateScheduledCall(final Message message, final String agentUsername) {
        final Data identity = new Data(ROOT_ID, Long.toString(message.getTransactionId()));
        final String phoneNumber = determinePhoneNumber(message);
        final String scheduleTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(message.getWhenToAction());
        final UpdateScheduleCall update = new UpdateScheduleCall(inInConfig.getCampaignName(), identity, phoneNumber, agentUsername, scheduleTime);
        return updateScheduleCallClient.post(singletonList(update), new ParameterizedTypeReference<List<String>>() {}, inInConfig.getWsUrl() + "/InsertOrUpdateScheduleCallBacks")
            .flatMap(r -> {
                if (r.size() != 1) {
                    return Observable.error(new IllegalStateException("Updating dialler callback failed"));
                } else {
                    return just(Boolean.TRUE);
                }
            });
    }

    public Observable<Boolean> deleteScheduledCall(final I3Identity i3Identity) {
        final DeleteScheduleCall delete = new DeleteScheduleCall(inInConfig.getCampaignName(), singletonList(i3Identity.get()));
        return deleteScheduleCallClient.post(singletonList(delete),  new ParameterizedTypeReference<List<String>>() {}, inInConfig.getWsUrl() + "/DeleteScheduleCallBacks")
            .flatMap(r -> {
                if (r.size() != 1) {
                    return Observable.error(new IllegalStateException("Deleting dialler callback failed"));
                } else {
                    return just(Boolean.TRUE);
                }
            });
    }

    private Observable<? extends I3Identity> searchRequest(final String f) {
        final List<SearchWithFilter> searches = singletonList(new SearchWithFilter(inInConfig.getCampaignName(), f));
        final String searchUrl = inInConfig.getWsUrl() + "/SearchRecordsWithFilter";
        final Observable<SearchWithFilterResults> results = searchClient.post(searches, SearchWithFilterResults.class, searchUrl);
        return results.flatMap(this::identity);
    }

    protected Observable<String> searchFilter(final Message message) {
        return Observable.create(s -> {
            try {
                final Map<String, Object> values = new HashMap<>();
                values.put("verticalCode", VerticalType.HEALTH.name());
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

    private String determinePhoneNumber(final Message message) {
        final Optional<String> mobile = createMobile(message.getPhoneNumber1(), message.getPhoneNumber2());
        final Optional<String> phone = createPhone(message.getPhoneNumber1(), message.getPhoneNumber2());
        return mobile.orElseGet(() -> phone.orElse(""));
    }

    protected Optional<String> createMobile(final String phoneNumber1, final String phoneNumber2) {
        return isMobile(phoneNumber1) ? Optional.of(phoneNumber1) : isMobile(phoneNumber2) ? Optional.of(phoneNumber2) : Optional.empty();
    }

    protected Optional<String> createPhone(final String phoneNumber1, final String phoneNumber2) {
        return !isMobile(phoneNumber1) ? Optional.of(phoneNumber1) : !isMobile(phoneNumber2) ? Optional.of(phoneNumber2) : Optional.empty();
    }

    private boolean isMobile(final String phoneNumber1) {
        return phoneNumber1 != null && (phoneNumber1.startsWith("04") || phoneNumber1.startsWith("05"));
    }

    private Observable<I3Identity> identity(final SearchWithFilterResults searchResults) {
        final Observable<SearchResult> allSearchResults = Observable.from(searchResults.getResults()).flatMap(Observable::from);
        return allSearchResults.flatMap(this::getIdentity);
    }

    private Observable<I3Identity> getIdentity(final SearchResult searchResult) {
        final String i3_identity = searchResult.get().get(I3_IDENTITY);
        return i3_identity != null ?
            just(I3Identity.instanceOf(i3_identity))
            : Observable.error(new IllegalStateException("No I3 Identity key found"));
    }

    private List<Data> createLeadDatas(final Message message) {
        final List<Data> datas = new ArrayList<>();
        addData(datas, STATUS, Status.J); // records are always inserted with a J status
        addData(datas, ZONE, message.getState());
        addData(datas, ROOT_ID, message.getTransactionId());
        addData(datas, STATE, message.getState());
        addData(datas, PHONE, createPhone(message.getPhoneNumber1(), message.getPhoneNumber2()));
        addData(datas, MOBILE, createMobile(message.getPhoneNumber1(), message.getPhoneNumber2()));
        addData(datas, VERTICAL_CODE, VerticalType.HEALTH.name());
        return datas;
    }

    private void addData(final List<Data> datas, final String field, final Object value) {
        datas.add(createData(field, value));
    }

    private void addData(final List<Data> datas, final String field, final Optional<?> value) {
        value.ifPresent(v -> addData(datas, field, v));
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
