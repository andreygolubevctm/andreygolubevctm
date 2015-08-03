package com.ctm.model.request.life;

import com.ctm.model.request.PersonAlt;
import com.ctm.web.validation.FortyCharHash;

public final class LifePerson extends PersonAlt {

	@FortyCharHash
	public String occupation;

}
