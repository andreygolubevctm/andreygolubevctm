package com.ctm.services;

import com.ctm.dao.ProviderFilterDao;
import com.ctm.exceptions.ConfigSettingException;
import com.ctm.exceptions.DaoException;
import com.ctm.exceptions.SessionException;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.model.settings.Vertical.VerticalType;
import com.disc_au.web.go.Data;
import org.custommonkey.xmlunit.XMLUnit;
import org.json.JSONException;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.xml.sax.SAXException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.io.IOException;

import static junit.framework.Assert.assertEquals;
import static org.custommonkey.xmlunit.XMLAssert.assertXMLEqual;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;


@RunWith(PowerMockRunner.class)
@PrepareForTest( { SettingsService.class})

public class ProviderFilterTest {
	private String transactionIdString = "100000";

	private HttpServletRequest request = mock(HttpServletRequest.class);
	private ProviderFilterDao providerFilterDAO = mock(ProviderFilterDao.class);
	private SessionDataService sessionDataService = mock(SessionDataService.class);
	private PageSettings pageSettings;

	private Data data;
	private String config = "<?xml version='1.0' encoding='UTF-8'?>\n" +
			"<aggregator xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://com.disc_au.soap.aggregator ../schema/config.xsd' xmlns='http://com.disc_au.soap.aggregator'>\n" +
			"\t<merge-root>soap-response</merge-root>\n" +
			"\t<merge-xsl>somemergesxlfile</merge-xsl>\n" +
			"\t<config-dir>someconfigdir</config-dir>\n" +
			"\t<error-dir>someerrordir</error-dir>\n" +
			"\t<debug-dir>somedebuglocation</debug-dir>\n" +
			"\t<validation-file>somevalidationlocation</validation-file>\n" +
			"\t<service name='AGIS' type='url-encoded'>\n" +
			"\t\t<soap-url>https://alocationurl/</soap-url>\n" +
			"\t\t<outbound-xsl>Aoutbound.xsl</outbound-xsl>\n" +
			"\t\t<outbound-xsl-parms>partnerId=CC00000001,sourceId=TEST000001</outbound-xsl-parms>\n" +
			"\t\t<inbound-xsl>Ainbound.xsl</inbound-xsl>\n" +
			"\t\t<inbound-xsl-parms>defaultProductId=NODEFAULT,service=Awebservice</inbound-xsl-parms>\n" +
			"\t\t<timeoutMillis>20000</timeoutMillis>\n" +
			"\t</service>\n" +
			"\t<service name='FAST' type='url-encoded'>\n" +
			"\t\t<soap-url>http://blocationurl/</soap-url>\n" +
			"\t\t<outbound-xsl>Boutbound.xsl</outbound-xsl>\n" +
			"\t\t<outbound-xsl-parms>partnerId=CC00000001,sourceId=TEST000001</outbound-xsl-parms>\n" +
			"\t\t<inbound-xsl>Binbound.xsl</inbound-xsl>\n" +
			"\t\t<inbound-xsl-parms>defaultProductId=NODEFAULT,service=Bwebservice</inbound-xsl-parms>\n" +
			"\t\t<timeoutMillis>200000</timeoutMillis>\n" +
			"\t</service>\n" +
			"\t<service name='VIRG' type='url-encoded'>\n" +
			"\t\t<soap-url>http://clocationurl/</soap-url>\n" +
			"\t\t<outbound-xsl>Coutbound.xsl</outbound-xsl>\n" +
			"\t\t<outbound-xsl-parms>partnerId=CC00000001,sourceId=TEST000001</outbound-xsl-parms>\n" +
			"\t\t<inbound-xsl>Cinbound.xsl</inbound-xsl>\n" +
			"\t\t<inbound-xsl-parms>defaultProductId=NODEFAULT,service=Cwebservice</inbound-xsl-parms>\n" +
			"\t\t<timeoutMillis>200000</timeoutMillis>\n" +
			"\t</service>\n" +
			"</aggregator>";

	@Before
	public void setUp() throws Exception {
		PowerMockito.mockStatic(SettingsService.class);
		XMLUnit.setIgnoreWhitespace(true);

		data = new Data();
		pageSettings = new PageSettings();

		// mock some of the services and params
		when(request.getParameter("transactionId")).thenReturn(transactionIdString);
		when(request.getSession()).thenReturn(mock(HttpSession.class));
		when(sessionDataService.getDataForTransactionId(request, transactionIdString, true)).thenReturn(data);
		PowerMockito.when(SettingsService.getPageSettingsForPage(request)).thenReturn(pageSettings);


		// setup the vertical as travel within pagesettings
		Vertical vertical = new Vertical();
		vertical.setType(VerticalType.TRAVEL);
		pageSettings.setVertical(vertical);
	}


	@Test
	public void testShouldShouldFilterProviderFromDropdown() throws JSONException, SessionException, DaoException, ConfigSettingException, IOException, SAXException {
		data.put("travel/filter/singleProvider", "VIRG");
		data.put("travel/transactionId", transactionIdString);

		// execute the call to parse the XML Config
		ProviderFilter pf = new ProviderFilter(pageSettings, sessionDataService, providerFilterDAO);
		String actualResult = pf.getXMLConfig(data, config, "travel");

		// setup what the xmlConfig should be
		String expectedResult = "<?xml version='1.0' encoding='UTF-8'?>\n" +
				"<aggregator xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://com.disc_au.soap.aggregator ../schema/config.xsd' xmlns='http://com.disc_au.soap.aggregator'>\n" +
				"\t<merge-root>soap-response</merge-root>\n" +
				"\t<merge-xsl>somemergesxlfile</merge-xsl>\n" +
				"\t<config-dir>someconfigdir</config-dir>\n" +
				"\t<error-dir>someerrordir</error-dir>\n" +
				"\t<debug-dir>somedebuglocation</debug-dir>\n" +
				"\t<validation-file>somevalidationlocation</validation-file>\n" +
				"\t<service name='VIRG' type='url-encoded'>\n" +
				"\t\t<soap-url>http://clocationurl/</soap-url>\n" +
				"\t\t<outbound-xsl>Coutbound.xsl</outbound-xsl>\n" +
				"\t\t<outbound-xsl-parms>partnerId=CC00000001,sourceId=TEST000001</outbound-xsl-parms>\n" +
				"\t\t<inbound-xsl>Cinbound.xsl</inbound-xsl>\n" +
				"\t\t<inbound-xsl-parms>defaultProductId=NODEFAULT,service=Cwebservice</inbound-xsl-parms>\n" +
				"\t\t<timeoutMillis>200000</timeoutMillis>\n" +
				"\t</service>\n" +
				"</aggregator>";

		// run the assertion
		assertXMLEqual(expectedResult, actualResult);
	}

	@Test
	public void testShouldShouldFilterProviderFromProviderKey() throws JSONException, SessionException, DaoException, ConfigSettingException, IOException, SAXException {
		data.put("travel/filter/providerKey", "virg_eZ45QZm7Y2");
		data.put("travel/transactionId", transactionIdString);

		when(providerFilterDAO.getProviderDetails("virg_eZ45QZm7Y2")).thenReturn("VIRG");

		// execute the call to parse the XML Config
		ProviderFilter pf = new ProviderFilter(pageSettings, sessionDataService, providerFilterDAO);
		String actualResult = pf.getXMLConfig(data, config, "travel");

		// setup what the xmlConfig should be
		String expectedResult = "<?xml version='1.0' encoding='UTF-8'?>\n" +
				"<aggregator xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='http://com.disc_au.soap.aggregator ../schema/config.xsd' xmlns='http://com.disc_au.soap.aggregator'>\n" +
				"\t<merge-root>soap-response</merge-root>\n" +
				"\t<merge-xsl>somemergesxlfile</merge-xsl>\n" +
				"\t<config-dir>someconfigdir</config-dir>\n" +
				"\t<error-dir>someerrordir</error-dir>\n" +
				"\t<debug-dir>somedebuglocation</debug-dir>\n" +
				"\t<validation-file>somevalidationlocation</validation-file>\n" +
				"\t<service name='VIRG' type='url-encoded'>\n" +
				"\t\t<soap-url>http://clocationurl/</soap-url>\n" +
				"\t\t<outbound-xsl>Coutbound.xsl</outbound-xsl>\n" +
				"\t\t<outbound-xsl-parms>partnerId=CC00000001,sourceId=TEST000001</outbound-xsl-parms>\n" +
				"\t\t<inbound-xsl>Cinbound.xsl</inbound-xsl>\n" +
				"\t\t<inbound-xsl-parms>defaultProductId=NODEFAULT,service=Cwebservice</inbound-xsl-parms>\n" +
				"\t\t<timeoutMillis>200000</timeoutMillis>\n" +
				"\t</service>\n" +
				"</aggregator>";

		// run the assertion
		assertXMLEqual(expectedResult, actualResult);
	}

    @Test
    public void testShouldRetrieveProviderCode() throws DaoException {
        when(providerFilterDAO.getProviderDetails("virg_eZ45QZm7Y2")).thenReturn("VIRG");
        ProviderFilter pf = new ProviderFilter(pageSettings, sessionDataService, providerFilterDAO);
		String vertical = "travel";

        data.put("travel/filter/providerKey", "virg_eZ45QZm7Y2");
        assertEquals("only providerKey", "VIRG", pf.getProviderCode(data, vertical));

        data.clear();
        data.put("travel/filter/singleProvider", "FAST");
        assertEquals("only singleProvider", "FAST", pf.getProviderCode(data, vertical));

        data.clear();
        data.put("travel/filter/providerKey", "virg_eZ45QZm7Y2");
        data.put("travel/filter/singleProvider", "FAST");
        assertEquals("bot providerKey and singleProvider", "VIRG", pf.getProviderCode(data, vertical));

        data.clear();
        assertEquals("no provider filter", "", pf.getProviderCode(data, vertical));

        data.clear();
        data.put("travel/filter/providerKey", "virg_hacking_the_mainframe");
        assertEquals("invalid provider key", "", pf.getProviderCode(data, vertical));
    }

}