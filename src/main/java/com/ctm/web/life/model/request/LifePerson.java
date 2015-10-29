package com.ctm.web.life.model.request;

import com.ctm.web.core.model.request.PersonAlt;
import com.ctm.web.validation.FortyCharHash;

public final class LifePerson extends PersonAlt {

	@FortyCharHash
	public String occupation;

}
