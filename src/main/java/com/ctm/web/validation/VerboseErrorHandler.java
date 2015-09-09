package com.ctm.web.validation;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

import javax.xml.stream.XMLStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static com.ctm.logging.LoggingArguments.kv;

/**
 * Created by lbuchanan on 21/04/2015.
 */
public class VerboseErrorHandler implements ErrorHandler {

    private final String prefixXpath;
	private static final Logger LOGGER = LoggerFactory.getLogger(VerboseErrorHandler.class);

    private XMLStreamReader reader;
    public boolean valid  = true;
    public List<String> validated = new ArrayList<>();
    public final List<SchemaValidationError> validationErrors = new ArrayList<>();

    public VerboseErrorHandler(XMLStreamReader reader, String prefixXpath) {
        this.reader = reader;
        this.prefixXpath = prefixXpath;
    }

    @Override
    public void error(SAXParseException e) throws SAXException {
        warning(e);
    }

    @Override
    public void fatalError(SAXParseException e) throws SAXException {
        warning(e);
        valid = false;
        throw e;
    }

    @Override
    public void warning(SAXParseException e) throws SAXException {
        //check there is an error to validate
        if(reader.isStartElement() || reader.isEndElement()) {
            createValidationErrorObject(reader.getName().getLocalPart(), e.getMessage());
        }
    }

    private void createValidationErrorObject(String element, String message) {
        if(!validated.contains(element)) {
            boolean notCompleteErrorMultiple =  message.contains("The content of element '"+ element + "' is not complete. One of '{");
            boolean unspecifiedField = message.contains("Invalid content was found starting with element '" + element + "'. One of ")
                    ||  message.contains("Invalid content was found starting with element '" + element + "'. No child element is expected at this point.");

            SchemaValidationError error = new SchemaValidationError();
            if(unspecifiedField) {
                LOGGER.info("unspecified Field. {}" , kv("element", element));
                //This is most likely intentional carry on
            } else if(notCompleteErrorMultiple) {
                error.setMessage("ELEMENT REQUIRED");
                Pattern p = Pattern.compile(" One of \'\\{(.*?)\\}\' is expected.");
                Matcher m = p.matcher(message);
                String expected = "";
                if (m.find()) {
                    expected = m.group(1);
                }

                // multiple missing fields
                if(!expected.equals(element)) {
                    error.setElements(expected);
                    error.setElementXpath(prefixXpath + element);
                } else {
                    error.setElementXpath(prefixXpath + element);
                }
                validated.add(element);
                valid = false;
                this.validationErrors.add(error);
            } else if(message.contains("is not complete. One of") || message.contains("\'\' is not a valid value for") || message.contains("Value \'\' is not facet-valid")) {
                error.setMessage("ELEMENT REQUIRED");
                error.setElementXpath(prefixXpath  + element);
                validated.add(element);
                valid = false;
                this.validationErrors.add(error);
            } else if(message.contains("of element \'" + element + "\' is not valid.") || message.contains("is not facet-valid")) {
                validated.add(element);
                error.setMessage(SchemaValidationError.INVALID);
                error.setElementXpath(prefixXpath  + element);
                valid = false;
                this.validationErrors.add(error);
            } else {
                error.setMessage(message);
                error.setElementXpath(prefixXpath  + element);
                valid = false;
                this.validationErrors.add(error);
            }
        }
    }
}