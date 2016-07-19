package com.ctm.web.health.services;

import com.ctm.httpclient.Client;
import com.ctm.httpclient.RestSettings;
import com.ctm.web.core.competition.services.CompetitionService;
import com.ctm.web.core.content.model.Content;
import com.ctm.web.core.content.services.ContentService;
import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.email.exceptions.EmailDetailsException;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.exceptions.RouterException;
import com.ctm.web.core.model.CompetitionEntry;
import com.ctm.web.core.model.ProviderFilter;
import com.ctm.web.core.model.QuoteServiceProperties;
import com.ctm.web.core.model.settings.Brand;
import com.ctm.web.core.providers.model.RatesheetOutgoingRequest;
import com.ctm.web.core.services.CommonRequestServiceV2;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.ServiceConfigurationServiceBean;
import com.ctm.web.core.web.go.Data;
import com.ctm.web.core.web.go.xml.XmlNode;
import com.ctm.web.health.model.form.*;
import com.ctm.web.health.quote.model.RequestAdapter;
import com.ctm.web.health.quote.model.ResponseAdapter;
import com.ctm.web.health.quote.model.ResponseAdapterModel;
import com.ctm.web.health.quote.model.request.HealthQuoteRequest;
import com.ctm.web.health.quote.model.response.HealthResponse;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;

import javax.servlet.http.HttpServletRequest;
import java.util.Optional;

import static com.ctm.web.core.model.settings.Vertical.VerticalType.HEALTH;

@Component
public class HealthQuoteService extends CommonRequestServiceV2 {

    @Autowired
    private CompetitionService competitionService;

    @Autowired
    private Client<RatesheetOutgoingRequest<HealthQuoteRequest>, HealthResponse> clientQuotes;

    @Autowired
    public HealthQuoteService(ProviderFilterDao providerFilterDAO, ServiceConfigurationServiceBean serviceConfigurationServiceBean) {
        super(providerFilterDAO, serviceConfigurationServiceBean);
    }

    public ResponseAdapterModel getQuotes(Brand brand, HealthRequest data, Content alternatePricingContent, boolean isSimples) throws Exception {
        setFilter(data.getQuote().getSituation());
        final HealthQuoteRequest quoteRequest = RequestAdapter.adapt(data, alternatePricingContent, isSimples);

        final RatesheetOutgoingRequest<HealthQuoteRequest> request = RatesheetOutgoingRequest.<HealthQuoteRequest>newBuilder()
                .transactionId(data.getTransactionId())
                .brandCode(brand.getCode())
                .requestAt(data.getRequestAt())
                .payload(quoteRequest)
                .build();

        final QuoteServiceProperties properties = getQuoteServiceProperties("healthQuoteServiceBER", brand, HEALTH.getCode(), Optional.ofNullable(data.getEnvironmentOverride()));

        final HealthResponse healthResponse = clientQuotes.post(RestSettings.<RatesheetOutgoingRequest<HealthQuoteRequest>>builder()
                .request(request)
                .jsonHeaders()
                .url(properties.getServiceUrl()+"/quote")
                .timeout(properties.getTimeout())
                .responseType(MediaType.APPLICATION_JSON)
                .response(HealthResponse.class)
                .build())
//                TODO: what to do on error
                .doOnError(t -> t.printStackTrace())
                .single().toBlocking().single();

        return ResponseAdapter.adapt(data, healthResponse, alternatePricingContent);
    }

    public Data healthCompetitionEntry(HttpServletRequest request, HealthRequest data, HealthQuote quote, boolean competitionEnabled, Data dataBucket) throws ConfigSettingException, DaoException, EmailDetailsException {
        ContactDetails contactDetails = quote.getContactDetails();
        String firstName = StringUtils.trim(contactDetails.getName());
        String email = StringUtils.trim(contactDetails.getEmail());
        String phoneNumber;
        if (contactDetails.getContactNumber() != null) {
            ContactNumber contactNumber = contactDetails.getContactNumber();
            if (StringUtils.isNotBlank(contactNumber.getMobile())) {
                phoneNumber = StringUtils.trim(contactNumber.getMobile());
            } else {
                phoneNumber = StringUtils.trim(contactNumber.getOther());
            }
        } else {
            phoneNumber = contactDetails.getFlexiContactNumberinput();
        }
        String concat = firstName + "::" + email + "::" + phoneNumber;

        XmlNode health = dataBucket.getFirstChild("health");
        XmlNode contactDetailsNode = health.getFirstChild("contactDetails");
        XmlNode competitionNode = contactDetailsNode.getFirstChild("competition");

        // Check for competition
        if (competitionEnabled && optInCompetition(quote) && notEntered(competitionNode, concat)) {

            CompetitionEntry entry = new CompetitionEntry();

            entry.setFirstName(firstName);
            entry.setEmail(email);
            entry.setPhoneNumber(phoneNumber);
            updateCompetitionEntry(request, entry);
            competitionService.addToCompetitionEntry(request, data.getTransactionId(), entry);
            // add to the data bucket competition/previous

            if (competitionNode == null) {
                competitionNode = new XmlNode("competition");
                contactDetailsNode.addChild(competitionNode);
            }

            competitionNode.addChild(new XmlNode("previous", concat));
        }
        return dataBucket;
    }


    private boolean optInCompetition(HealthQuote quote) {
        Competition competition = quote.getContactDetails().getCompetition();
        return competition != null && StringUtils.equalsIgnoreCase(competition.getOptin(), "Y");
    }

    private boolean notEntered(XmlNode competitionNode, String concat) {
        if (competitionNode != null) {
            XmlNode previous = competitionNode.getFirstChild("previous");
            if (previous != null && StringUtils.equalsIgnoreCase(previous.getText(), concat)) {
                return false;
            }
        }
        return true;
    }

    private void updateCompetitionEntry(HttpServletRequest request, CompetitionEntry entry) throws ConfigSettingException, DaoException {
        String competitionSecret = StringUtils.defaultIfEmpty(ContentService.getContentValue(request, "competitionSecret"), "");

        switch (competitionSecret) {
            case "vU9CD4NjT3S6p7a83a4t":
                entry.setCompetitionId(26);
                entry.setSource("AugustHealthPromo2015$5000");
                break;
            case "kSdRdpu5bdM5UkKQ8gsK":
                entry.setCompetitionId(24);
                entry.setSource("AugustHealthPromo2015$1000");
                break;
            case "C7F9FILY0qe02X98rXCH":
                entry.setCompetitionId(19);
                entry.setSource("MayHealthPromo2015$1000");
                break;
            case "1NjmJ507mwUnX81Lj96b":
                entry.setCompetitionId(20);
                entry.setSource("YHOO-MayPromo2015$1000");
                break;
            case "1F6F87144375AD8BAED4D53F8CF5B":
                entry.setCompetitionId(15);
                entry.setSource("Feb2015HealthJEEPPromo");
                break;
        }
    }

    // TODO: move providerKeys to the database and use CommonQuoteService.setFilter
    protected void setFilter(ProviderFilter providerFilter) throws Exception {
        if (providerFilter != null && StringUtils.isNotBlank(providerFilter.getProviderKey())) {
            switch (providerFilter.getProviderKey()) {
                case "au_74815263":
                    providerFilter.setSingleProvider("1");
                    break;
                case "hcf_7895123":
                    providerFilter.setSingleProvider("2");
                    break;
                case "nib_784512":
                    providerFilter.setSingleProvider("3");
                    break;
                case "gmhba_74851253":
                    providerFilter.setSingleProvider("5");
                    break;
                case "frank_7152463":
                    providerFilter.setSingleProvider("8");
                    break;
                case "ahm_685347":
                    providerFilter.setSingleProvider("9");
                    break;
                case "cbhs_597125":
                    providerFilter.setSingleProvider("10");
                    break;
                case "hif_87364556":
                    providerFilter.setSingleProvider("11");
                    break;
                case "cua_089105165":
                    providerFilter.setSingleProvider("12");
                    break;
                case "ctm_123456789":
                    providerFilter.setSingleProvider("14");
                    break;
                case "bup_744568719":
                    providerFilter.setSingleProvider("15");
                    break;
                case "bud_296587056":
                    providerFilter.setSingleProvider("54");
                    break;
                case "qchf_63422354":
                    providerFilter.setSingleProvider("16");
                    break;
                case "nhb_42694269":
                    providerFilter.setSingleProvider("17");
                    break;
                case "hbf_89564575":
                    providerFilter.setSingleProvider("18");
                    break;
                default:
                    throw new RouterException("Invalid providerKey");
            }
        } else if(EnvironmentService.getEnvironmentAsString().equalsIgnoreCase("nxs")) {
            throw new RouterException("Provider Key required in '" + EnvironmentService.getEnvironmentAsString() + "' environment");
        }
    }

}
