package com.ctm.utils.travel;

import com.ctm.model.request.travel.TravelRequest;
import com.disc_au.web.go.Data;

public class TravelRequestParser {

	public static TravelRequest parseRequest(Data data, String vertical) {
		TravelRequest request = new TravelRequest();
		String prefix = vertical.toLowerCase() + "/";
		request.firstName =  data.getString(prefix + "firstName");
		request.surname =  data.getString(prefix + "surname");

		request.adults =  data.getString(prefix + "adults");
		request.children =  data.getString(prefix + "children");
		request.oldest =  data.getString(prefix + "oldest");
		request.destination =  data.getString(prefix + "destination");


		return request;
	}


}
