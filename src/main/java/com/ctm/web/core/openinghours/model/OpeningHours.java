package com.ctm.web.core.openinghours.model;

import lombok.Getter;
import lombok.Setter;
import org.hibernate.validator.constraints.NotEmpty;
import org.hibernate.validator.constraints.Range;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;

@Getter
@Setter
public class OpeningHours {

	public int openingHoursId;
	public String startTime;
	public String endTime;
	
	@NotNull(message="Description can not be empty")
	@NotEmpty(message="Description can not be empty")
	public String description;
	
	public String date;
	public String daySequence;
	
	@NotEmpty(message="Hours Type can not be empty and must be either 'H' or 'N' or 'S'")
	@Pattern(regexp="[s|S|n|N|h|H]", message="Hours Type can not be empty and must be either 'H' or 'N' or 'S'")
	public String hoursType;
	
	@NotNull(message="Effective Start date can not be empty")
	@NotEmpty(message="Effective Start date can not be empty")
	public String effectiveStart;
	
	@NotNull(message="Effective End date can not be empty")
	@NotEmpty(message="Effective End date  can not be empty")
	public String effectiveEnd;
	@Range(min=1, message="Vertical ID must be positive Integer")	
	public int verticalId;
}
