package com.ctm.model.request.travel;

import com.ctm.web.validation.Destinations;
import com.ctm.web.validation.Name;
import com.ctm.web.validation.Numeric;

import javax.validation.constraints.NotNull;

public class TravelRequest {
	/* I would prefer to do a travelPerson model instead but because travel has the xpath first firstName (travel/firstName)
	and surname (travel/surname), it had to be done this way. Same with the numeric fields.
	 */

	@Name
	public String firstName;

	@Name
	public String surname;

	@NotNull(message = "Please choose how many adults")
	@Numeric
	public String adults;

	@NotNull(message = "Please choose how many children")
	@Numeric
	public String children;

	@NotNull(message = "Please enter a valid number")
	@Numeric
	public String oldest;

	@Destinations
	public String destination;

	public String currentJourney;
}
