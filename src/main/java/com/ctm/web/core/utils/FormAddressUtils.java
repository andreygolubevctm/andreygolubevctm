package com.ctm.web.core.utils;

import com.ctm.web.core.model.Address;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class FormAddressUtils {

	private static final Logger LOGGER = LoggerFactory.getLogger(FormAddressUtils.class);

	public static Address parseAddressFromForm(HttpServletRequest request, String xPathPrefix){

		Address address = new Address();

		address.setPostCode(request.getParameter(xPathPrefix+"_postCode"));
		address.setState(request.getParameter(xPathPrefix+"_state"));


		if(request.getParameter(xPathPrefix+"_nonStd") != null && request.getParameter(xPathPrefix+"_nonStd").equals("Y")){

			LOGGER.debug("Manually entered address. {}" , kv("prefix" ,xPathPrefix));
			// Manually entered address
			address.setUnitNo(request.getParameter(xPathPrefix + "_unitShop"));
			address.setUnitType(request.getParameter(xPathPrefix+"_unitType"));
			address.setHouseNo(request.getParameter(xPathPrefix+"_streetNum"));
			address.setStreet(request.getParameter(xPathPrefix+"_nonStdStreet"));
			address.setSuburb(request.getParameter(xPathPrefix+"_suburb"));

		}else{
			LOGGER.debug("Type ahead address. {}" , kv("prefix" ,xPathPrefix));
			address.setUnitNo(request.getParameter(xPathPrefix+"_unitSel"));
			address.setUnitType(request.getParameter(xPathPrefix+"_unitType"));

			address.setHouseNo(request.getParameter(xPathPrefix+"_houseNoSel"));
			address.setStreet(request.getParameter(xPathPrefix+"_streetName"));

		}



		address.setSuburb(request.getParameter(xPathPrefix+"_suburbName"));

		return address;
	}

}
