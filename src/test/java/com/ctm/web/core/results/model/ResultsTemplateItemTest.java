package com.ctm.web.core.results.model;

import org.junit.Test;

import static junitx.framework.Assert.assertEquals;

/**
 * Created by msmerdon on 5/1/21.
 */
public class ResultsTemplateItemTest {

	@Test
	public void testModel() {
		String groups = "GROUPS COPY";
		String caption = "CAPTIONS COPY";
		String description = "DESCRIPTION COPY";
		ResultsTemplateItem item = new ResultsTemplateItem();
		item.setGroups(groups);
		assertEquals(groups, item.getGroups());
		item.setCaption(caption);
		assertEquals(caption, item.getCaption());
		item.setDescription(description);
		assertEquals(description, item.getDescription());
	}
}
