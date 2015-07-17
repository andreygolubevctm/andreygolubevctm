package com.ctm.model.settings;

import com.ctm.services.EnvironmentService;
import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class PageSettingsTest {

	Vertical vertical = mock(Vertical.class);
	public String contextFolderValue = "ctm/";

	@Before
	public void setup() {
		ConfigSetting setting = new ConfigSetting();
		setting.setName("contextFolder");
		setting.setValue(contextFolderValue);
		when(vertical.getSettingForName("contextFolder")).thenReturn(setting);
	}

	@Test
	public void testGetContextFolder() throws Exception {
		assertTrue("ctm-HLT-1234/".regionMatches(0, contextFolderValue, 0, contextFolderValue.length()-1));

		PageSettings pageSettings = new PageSettings();
		pageSettings.setVertical(vertical);

		// Normal situation
		EnvironmentService.setEnvironment("NXI");
		EnvironmentService.setContextPath("ctm/");
		assertEquals(contextFolderValue, pageSettings.getContextFolder());

		// Feature branch in dev
		EnvironmentService.setContextPath("ctm-HLT-1234/");
		assertEquals("Override in dev environments", "ctm-HLT-1234/", pageSettings.getContextFolder());

		// Feature branch in PRO should never happen
		EnvironmentService.setEnvironment("PRO");
		assertEquals("No override in Production", contextFolderValue, pageSettings.getContextFolder());

		// Whitelabel
		ConfigSetting setting = new ConfigSetting();
		setting.setName("contextFolder");
		setting.setValue("app/");
		when(vertical.getSettingForName("contextFolder")).thenReturn(setting);

		// A ctm context should never override an app context
		EnvironmentService.setContextPath("ctm/");
		EnvironmentService.setEnvironment("NXI");
		assertEquals("app/", pageSettings.getContextFolder());
		EnvironmentService.setContextPath("ctm-HLT-1234/");
		assertEquals("app/", pageSettings.getContextFolder());
	}

}