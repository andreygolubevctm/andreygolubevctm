package com.ctm.web.core.model.session;

import com.ctm.web.core.model.Role;
import com.ctm.web.core.model.Rule;
import com.ctm.web.core.web.go.Data;
import org.apache.catalina.authenticator.SavedRequest;
import org.junit.Test;
import org.springframework.util.SerializationUtils;

import java.io.NotSerializableException;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class SessionDataSerializationTest {

    @Test(expected = NotSerializableException.class)
    public void givenCatalinaSavedRequest_thenCannotSerialize() throws Throwable {
        SavedRequest testInstance = new SavedRequest();
        try {
            SerializationUtils.serialize(testInstance);
        } catch (IllegalArgumentException ex) {
            throw ex.getCause();
        }
    }

    @Test
    public void givenSimpleSessionData_thenSerializeAndDeserialize() {

        SessionData testInstance = new SessionData();

        byte[] serializedInstance = SerializationUtils.serialize(testInstance);

        Object deserialize = SerializationUtils.deserialize(serializedInstance);
        assertEquals(testInstance, deserialize);
    }

    @Test
    public void givenSessionDataWithTransactionDate_thenSerializeAndDeserialize() {

        SessionData testInstance = new SessionData();
        Instant now = Instant.now();
        testInstance.setLastSessionTouch(Date.from(now));

        byte[] serializedInstance = SerializationUtils.serialize(testInstance);

        Object deserialize = SerializationUtils.deserialize(serializedInstance);
        assertEquals(testInstance, deserialize);
    }

    @Test
    public void givenSessionDataWithHealthXmlData_thenSerializeAndDeserialize() {

        SessionData testInstance = new SessionData();
        Data data = new Data();
        assertEquals("true", data.parse(SAMPLE_HEALTH_XML_DATA));
        testInstance.addTransactionData(data);
        Instant now = Instant.now();
        testInstance.setLastSessionTouch(Date.from(now));

        byte[] serializedInstance = SerializationUtils.serialize(testInstance);

        SessionData deserializedInstance = (SessionData) SerializationUtils.deserialize(serializedInstance);
        String expectedXMLString = data.getXML();
        String deserializedXMLString = deserializedInstance.getTransactionSessionData().get(0).getXML();
        assertEquals(expectedXMLString, deserializedXMLString);
        assertEquals(testInstance, deserializedInstance);
    }

    @Test
    public void givenAuth_thenSerializeAndDeserialize() {
        List<Rule> rules = new ArrayList<>();
        rules.add(new Rule());
        List<Role> userRoles = new ArrayList<>();
        userRoles.add(new Role());

        SessionData testInstance = new SessionData();
        AuthenticatedData data = new AuthenticatedData();
        assertEquals("true", data.parse(SAMPLE_HEALTH_XML_DATA));
        data.setSimplesUserRoles(userRoles);
        data.setGetNextMessageRules(rules);
        testInstance.addTransactionData(data);
        Instant now = Instant.now();
        testInstance.setLastSessionTouch(Date.from(now));

        byte[] serializedInstance = SerializationUtils.serialize(testInstance);

        SessionData deserializedInstance = (SessionData) SerializationUtils.deserialize(serializedInstance);
        String expectedXMLString = data.getXML();
        String deserializedXMLString = deserializedInstance.getTransactionSessionData().get(0).getXML();
        assertEquals(expectedXMLString, deserializedXMLString);
        assertEquals(testInstance, deserializedInstance);
    }


    String SAMPLE_HEALTH_XML_DATA =
            "<this>\n" +
                    "    <current>\n" +
                    "        <verticalCode>HEALTH</verticalCode>\n" +
                    "        <brandCode>ctm</brandCode>\n" +
                    "        <transactionId>2562912</transactionId>\n" +
                    "        <rootId>2562904</rootId>\n" +
                    "        <previousTransactionId>2562911</previousTransactionId>\n" +
                    "    </current>\n" +
                    "    <userData>\n" +
                    "        <emailSent>true</emailSent>\n" +
                    "    </userData>\n" +
                    "    <health>\n" +
                    "        <trackingKey>6420bd79f480083d12d3a9675b6b97e433638805</trackingKey>\n" +
                    "        <benefits>\n" +
                    "            <covertype>customise</covertype>\n" +
                    "            <benefitsExtras>\n" +
                    "                <Cardiac>Y</Cardiac>\n" +
                    "                <Rehabilitation>Y</Rehabilitation>\n" +
                    "                <DentalGeneral>Y</DentalGeneral>\n" +
                    "                <Palliative>Y</Palliative>\n" +
                    "                <GeneralHealth>Y</GeneralHealth>\n" +
                    "                <PlasticNonCosmetic>Y</PlasticNonCosmetic>\n" +
                    "                <PrHospital>Y</PrHospital>\n" +
                    "                <Hospital>Y</Hospital>\n" +
                    "            </benefitsExtras>\n" +
                    "            <HospitalSwitch>Y</HospitalSwitch>\n" +
                    "            <ExtrasSwitch>Y</ExtrasSwitch>\n" +
                    "        </benefits>\n" +
                    "        <application>\n" +
                    "            <address>\n" +
                    "                <elasticSearch>N</elasticSearch>\n" +
                    "                <houseNoSel>1</houseNoSel>\n" +
                    "                <type>R</type>\n" +
                    "                <streetNum>1</streetNum>\n" +
                    "                <suburbName>Toowong</suburbName>\n" +
                    "                <fullAddressLineOne>10 Golding St</fullAddressLineOne>\n" +
                    "                <streetName>Golding St</streetName>\n" +
                    "                <streetId>239459</streetId>\n" +
                    "                <dpId>81907205</dpId>\n" +
                    "                <fullAddress>10 Golding St.,Toowong QLD 4066</fullAddress>\n" +
                    "                <suburb>7984</suburb>\n" +
                    "            </address>\n" +
                    "            <optInEmail>Y</optInEmail>\n" +
                    "            <primary>\n" +
                    "                <gender>M</gender>\n" +
                    "            </primary>\n" +
                    "            <postal>\n" +
                    "                <suburb>7984</suburb>\n" +
                    "                <streetNum>11</streetNum>\n" +
                    "                <streetName>PO Box</streetName>\n" +
                    "                <elasticSearch>N</elasticSearch>\n" +
                    "                <type>P</type>\n" +
                    "                <suburbName>Toowong</suburbName>\n" +
                    "            </postal>\n" +
                    "            <other>0733334444</other>\n" +
                    "            <mobile>0444258369</mobile>\n" +
                    "            <partner>\n" +
                    "                <gender>F</gender>\n" +
                    "            </partner>\n" +
                    "        </application>\n" +
                    "        <loading>20</loading>\n" +
                    "        <filterBar>\n" +
                    "            <rebate>Y</rebate>\n" +
                    "            <benefitsExtras>29738</benefitsExtras>\n" +
                    "            <discount>Y</discount>\n" +
                    "            <benefitsHospital>29716</benefitsHospital>\n" +
                    "        </filterBar>\n" +
                    "        <lastFieldTouch>next-contact</lastFieldTouch>\n" +
                    "        <currentJourney>1</currentJourney>\n" +
                    "        <rebateChangeover>25.415</rebateChangeover>\n" +
                    "        <filter>\n" +
                    "            <priceMin>0</priceMin>\n" +
                    "            <frequency>M</frequency>\n" +
                    "        </filter>\n" +
                    "        <payment>\n" +
                    "            <bank>\n" +
                    "                <bsb>124001</bsb>\n" +
                    "                <claims>Y</claims>\n" +
                    "            </bank>\n" +
                    "            <medicare>\n" +
                    "                <cover>Y</cover>\n" +
                    "            </medicare>\n" +
                    "        </payment>\n" +
                    "        <situation>\n" +
                    "            <state>QLD</state>\n" +
                    "            <suburb>Toowong</suburb>\n" +
                    "            <location>Toowong 4066 QLD</location>\n" +
                    "            <postcode>4066</postcode>\n" +
                    "            <healthCvr>F</healthCvr>\n" +
                    "            <coverType>C</coverType>\n" +
                    "            <accidentOnlyCover>N</accidentOnlyCover>\n" +
                    "        </situation>\n" +
                    "        <healthCover>\n" +
                    "            <income>0</income>\n" +
                    "            <primary>\n" +
                    "                <dob>25/01/1967</dob>\n" +
                    "                <healthCoverLoading>N</healthCoverLoading>\n" +
                    "                <dobInputM>01</dobInputM>\n" +
                    "                <dobInputD>25</dobInputD>\n" +
                    "                <cover>Y</cover>\n" +
                    "                <dobInputY>1967</dobInputY>\n" +
                    "            </primary>\n" +
                    "            <incomelabel>$196,500 or less</incomelabel>\n" +
                    "            <partner>\n" +
                    "                <dobInputM>12</dobInputM>\n" +
                    "                <dobInputD>31</dobInputD>\n" +
                    "                <dobInputY>1979</dobInputY>\n" +
                    "                <cover>Y</cover>\n" +
                    "                <dob>31/12/1979</dob>\n" +
                    "                <healthCoverLoading>Y</healthCoverLoading>\n" +
                    "            </partner>\n" +
                    "            <rebate>Y</rebate>\n" +
                    "            <dependants>12</dependants>\n" +
                    "        </healthCover>\n" +
                    "        <contactDetails>\n" +
                    "            <flexiContactNumber>0444258369</flexiContactNumber>\n" +
                    "            <email>preload.testing@comparethemarket.com.au</email>\n" +
                    "            <optInEmail>Y</optInEmail>\n" +
                    "            <skippedContact>N</skippedContact>\n" +
                    "            <optin>Y</optin>\n" +
                    "            <contactNumber>\n" +
                    "                <mobile>0444258369</mobile>\n" +
                    "                <mobileinput>0444 258 369</mobileinput>\n" +
                    "                <other>0733334444</other>\n" +
                    "            </contactNumber>\n" +
                    "            <name>Guybrush</name>\n" +
                    "            <call>Y</call>\n" +
                    "        </contactDetails>\n" +
                    "        <altContactFormRendered>Y</altContactFormRendered>\n" +
                    "        <partnerCAE>30</partnerCAE>\n" +
                    "        <incrementTransactionId>Y</incrementTransactionId>\n" +
                    "        <primaryCAE>50</primaryCAE>\n" +
                    "        <gaclientid>1139575501.1515372592</gaclientid>\n" +
                    "        <previousfund>\n" +
                    "            <partner>\n" +
                    "                <memberID>12345</memberID>\n" +
                    "                <authority>Y</authority>\n" +
                    "                <fundName>BUPA</fundName>\n" +
                    "            </partner>\n" +
                    "            <primary>\n" +
                    "                <fundName>HCF</fundName>\n" +
                    "                <authority>Y</authority>\n" +
                    "                <memberID>12345</memberID>\n" +
                    "            </primary>\n" +
                    "        </previousfund>\n" +
                    "        <privacyoptin>Y</privacyoptin>\n" +
                    "        <renderingMode>lg</renderingMode>\n" +
                    "        <onResultsPage>Y</onResultsPage>\n" +
                    "        <journey>\n" +
                    "            <stage>results</stage>\n" +
                    "        </journey>\n" +
                    "        <excess>4</excess>\n" +
                    "        <rebate>25.934</rebate>\n" +
                    "        <previousRebate>26.791</previousRebate>\n" +
                    "        <popularProducts>\n" +
                    "            <purchased>0</purchased>\n" +
                    "        </popularProducts>\n" +
                    "        <showAll>Y</showAll>\n" +
                    "        <applyDiscounts>Y</applyDiscounts>\n" +
                    "        <clientIpAddress>0:0:0:0:0:0:0:1</clientIpAddress>\n" +
                    "        <clientUserAgent>Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36</clientUserAgent>\n" +
                    "        <transactionId>2562912</transactionId>\n" +
                    "    </health>\n" +
                    "</this>";
}