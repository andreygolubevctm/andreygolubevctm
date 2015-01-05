package com.ctm.utils;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import com.ctm.model.Address;

public class FormAddressUtils {

	private static Logger logger = Logger.getLogger(FormAddressUtils.class.getName());

	public static Address parseAddressFromForm(HttpServletRequest request, String xPathPrefix){

		Address address = new Address();

		address.setPostCode(request.getParameter(xPathPrefix+"_postCode"));
		address.setState(request.getParameter(xPathPrefix+"_state"));


		if(request.getParameter(xPathPrefix+"_nonStd") != null && request.getParameter(xPathPrefix+"_nonStd").equals("Y")){

			logger.debug("Manually entered address on "+xPathPrefix);
			// Manually entered address
			address.setUnitNo(request.getParameter(xPathPrefix+"_unitShop"));
			address.setUnitType(request.getParameter(xPathPrefix+"_unitType"));
			address.setHouseNo(request.getParameter(xPathPrefix+"_streetNum"));
			address.setStreet(request.getParameter(xPathPrefix+"_nonStdStreet"));
			address.setSuburb(request.getParameter(xPathPrefix+"_suburb"));

		}else{
			logger.debug("Type ahead address on "+xPathPrefix);
			address.setUnitNo(request.getParameter(xPathPrefix+"_unitShop"));
			address.setUnitType(request.getParameter(xPathPrefix+"_unitType"));

			address.setHouseNo(request.getParameter(xPathPrefix+"_houseNoSel"));
			address.setStreet(request.getParameter(xPathPrefix+"_streetName"));

		}



		address.setSuburb(request.getParameter(xPathPrefix+"_suburbName"));

		return address;
	}

}
