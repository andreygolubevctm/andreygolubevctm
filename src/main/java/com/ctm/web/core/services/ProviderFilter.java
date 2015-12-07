package com.ctm.web.core.services;

import com.ctm.web.core.dao.ProviderFilterDao;
import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.exceptions.DaoException;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.web.go.Data;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import javax.xml.stream.*;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class ProviderFilter {
	private static final Logger LOGGER = LoggerFactory.getLogger(ProviderFilter.class);
	private static XMLStreamWriter writer;
	private PageSettings pageSettings;
	private SessionDataService sessionDataService;
	private ProviderFilterDao providerFilterDAO;

	@SuppressWarnings("UnusedDeclaration")
	public ProviderFilter() {
		sessionDataService = new SessionDataService();
		providerFilterDAO = new ProviderFilterDao();
	}

	public ProviderFilter(PageSettings pageSettings, SessionDataService sessionDataService, ProviderFilterDao providerFilterDAO) {
		this.pageSettings = pageSettings;
		this.sessionDataService = sessionDataService;
		this.providerFilterDAO = providerFilterDAO;
	}

	/**
	 * Used for the xml based configs
	 */
	public String getXMLConfig(Data data, String config, String vertical) {
		return filterConfigByProvider(data, config, vertical);
	}

    public String getProviderCode(Data data, String vertical) {
        try {

            final String code = providerCode(data, vertical);
            return code == null || code.equals("invalid") ? "" : code;
        }
        catch (Exception e) {
            LOGGER.error("Error getting provider code {}", kv("vertical", vertical), e);
        }

        return "";
    }

	/**
	 * filters the config by provider
	 */
	private String filterConfigByProvider(Data data, String config, String vertical) {
		// first validate the provider against a whitelist to make sure no hacks are happening
		try {
			// filter out the config based on either the provider key or partner id being sent
			config = getFilteredConfig(data, config, vertical);
		}
		catch (Exception e) {
			LOGGER.error("Error filtering config {},{}", kv("config", config), kv("vertical", vertical), e);
		}

		return config;
	}

    private String verticalCode(HttpServletRequest request) throws DaoException, ConfigSettingException {
        if (this.pageSettings == null) {
            // grab the vertical we're working on
            pageSettings = SettingsService.getPageSettingsForPage(request); // grab this current page's settings
        }

        Vertical vert = pageSettings.getVertical(); // grab the vertical details
        return vert.getType().toString().toLowerCase();
    }

    /**
	 * retrieve the providerCode if it's an xml based config otherwise retrieve the id
	 */
	private String getFilteredConfig(Data data, String config, String vertical) throws Exception {
		// check if the filter node is set which means either it's a partner testing on NXS or a staff member has selected a partner from the dropdown
		if (data.get(vertical + "/filter/") != null) {
            String providerCode = providerCode(data, vertical);

			// parse the xml config and return the new config
			if (config != null) {
				config = filterXMLConfig(config, providerCode);
			} else {
				// return the provider id
				config = providerCode.equals("invalid") ? "0" : providerCode;
			}
		}

		return config;
	}

    private String providerCode(Data data, String vertical) throws Exception {
        String providerCode = "";
        String providerKey = data.getString(vertical + "/filter/providerKey");

        if (providerKey == null) {
            providerCode = data.getString(vertical + "/filter/singleProvider");
        }

        // verify the provider key
        if (providerKey != null) {
            providerCode = getProviderDetails(providerKey);
        }
        return providerCode;
    }

    /**
	 * Traverse the xml config and create a new config with the matched service name via the passed in providerCode
	 */
	private static String filterXMLConfig(String config, String providerCode) throws XMLStreamException {
		try {
			// read in the xml config
			XMLInputFactory factory = XMLInputFactory.newInstance();
			Reader reader = new StringReader(config);
			XMLStreamReader xmlReader = factory.createXMLStreamReader(reader);

			// setup for xml output
			StringWriter out = new StringWriter();
			writer = XMLOutputFactory.newInstance().createXMLStreamWriter(out);

			// build the <?xml and aggregator node
			writer.writeStartDocument("UTF-8", "1.0");
			writer.writeStartElement("aggregator");
			writer.writeAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
			writer.writeAttribute("xsi:schemaLocation", "http://com.disc_au.soap.aggregator ../schema/config.xsd");
			writer.writeAttribute("xmlns", "http://com.disc_au.soap.aggregator");

			String xmlValue = "";
			int attrCount = 0;
			boolean serviceNodeFound = false;

			while(xmlReader.hasNext()) {
				int event = xmlReader.next();

				switch (event) {
					case XMLStreamConstants.START_ELEMENT:
							switch(xmlReader.getLocalName()) {
								case "merge-root":
								case "merge-xsl":
								case "config-dir":
								case "debug-dir":
								case "validation-file":
										writer.writeStartElement(xmlReader.getLocalName());
										attrCount = xmlReader.getAttributeCount();
									break;
								case "service":
										// check if the service name matches the providerCode and if so, signal the start of saving the child nodes
										String serviceName = mapTravelProviderCodes(xmlReader.getAttributeValue("", "name"));
										if (serviceName.equals(providerCode) || "CTMT".equals(serviceName)) {
											serviceNodeFound = true;
											writer.writeStartElement(xmlReader.getLocalName());
											setNodeDetails(xmlReader, null, xmlReader.getAttributeCount());
										}
									break;
							}
						break;
					case XMLStreamConstants.CHARACTERS:
							xmlValue = xmlReader.getText().trim(); // grab the value of the node
						break;

					case XMLStreamConstants.END_ELEMENT:
							switch(xmlReader.getLocalName()) {
								case "aggregator": break; // ignore since we've set it at the top
								case "merge-root":
								case "merge-xsl":
								case "config-dir":
								case "debug-dir":
								case "validation-file":
									setNodeDetails(xmlReader, xmlValue, attrCount);
									break;
								case "service":
									// now stop retrieve the child nodes for this service node
									if (serviceNodeFound) {
										serviceNodeFound = false;
										writer.writeEndElement();
									}
									break;
								default:
										if (serviceNodeFound) {
											writer.writeStartElement(xmlReader.getLocalName());
											setNodeDetails(xmlReader, xmlValue, attrCount);
										}
									break;
							}
						break;
				}
			}

			// write end document
			writer.writeEndElement();
			writer.writeEndDocument();

			// even if there was no match, return nothing
			config = out.getBuffer().toString();


			//flush data to file and close writer
			writer.flush();
			writer.close();

		} catch (XMLStreamException e) {
			LOGGER.error("Error filtering xml config {},{}", kv("config", config), kv("providerCode", providerCode));
		}
		return config;
	}

	/**
	 * providercode mapping for travel. can be eliminated once the service name is updated and doesn't affect reporting
	 */

	private static String mapTravelProviderCodes(String providerCode) {
		switch(providerCode) {
			case "AGIS": providerCode = "BUDD"; break;
		}

		return providerCode;
	}

	/**
	 * Set the node attributes, value and the closing tag
	 */
	private static void setNodeDetails(XMLStreamReader xmlReader, String xmlValue, int attrCount) throws XMLStreamException {

		if (attrCount > 0) {
			for (int i = 0; i < attrCount; i++) {
				writer.writeAttribute(xmlReader.getAttributeLocalName(i), xmlReader.getAttributeValue(i));
			}
		}

		if (!xmlReader.getLocalName().equals("service")) {
			writer.writeCharacters(xmlValue);
			writer.writeEndElement();
		}
	}

	/**
	 * Get the provider by brand code with
	 */
	private String getProviderDetails(String providerKey) throws Exception {
		String providerCode = "";

		if (providerKey != null) {
			// if so grab check against the db if this key exists
			providerCode = providerFilterDAO.getProviderDetails(providerKey);
		}
		return providerCode;
	}


}
