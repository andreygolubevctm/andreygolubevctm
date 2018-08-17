package com.ctm.web.core.model.settings;

import com.ctm.web.core.exceptions.ConfigSettingException;
import com.ctm.web.core.services.EnvironmentService;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.Mock;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;

import static org.junit.Assert.*;
import static org.mockito.Mockito.when;
import static org.mockito.MockitoAnnotations.initMocks;


@RunWith(PowerMockRunner.class)
@PrepareForTest( { EnvironmentService.class, PageSettings.class, EnvironmentService.class})
public class PageSettingsTest {

    @Mock
	Vertical vertical;
    @Mock
    private Brand brand;
    public String contextFolderValue = "ctm/";
    private PageSettings pageSettings;

    @Before
	public void setup() {
		initMocks(this);

        PowerMockito.mockStatic(EnvironmentService.class);
        PowerMockito.when(EnvironmentService.getEnvironmentAsString()).thenReturn("LOCALHOST");
        pageSettings = new PageSettings();
        pageSettings.setVertical(vertical);
        when(brand.getCode()).thenReturn("ctm");
        when(vertical.getType()).thenReturn(Vertical.VerticalType.HEALTH);
	}

	@Test
	public void testGetContextFolder() throws Exception {
        PowerMockito.when(EnvironmentService.needsManuallyAddedBrandCodeParam()).thenReturn(true);
        setContextPathSettingCTM();
		assertTrue("ctm-HLT-1234/".regionMatches(0, contextFolderValue, 0, contextFolderValue.length()-1));

		// Normal situation
		EnvironmentService.setContextPath("ctm/");
        PowerMockito.when(EnvironmentService.getContextPath()).thenReturn("ctm/");
		assertEquals(contextFolderValue, pageSettings.getContextFolder());


        // Feature branch in PRO should never happen
        PowerMockito.when(EnvironmentService.getEnvironmentAsString()).thenReturn("PRO");
		assertEquals("No override in Production", contextFolderValue, pageSettings.getContextFolder());

		// Whitelabel
		ConfigSetting setting = new ConfigSetting();
		setting.setName("contextFolder");
		setting.setValue("app/");
		when(vertical.getSettingForName("contextFolder")).thenReturn(setting);

		// A ctm context should never override an app context
        PowerMockito.when(EnvironmentService.getContextPath()).thenReturn("ctm/");
        PowerMockito.when(EnvironmentService.getEnvironmentAsString()).thenReturn("NXI");
		assertEquals("app/", pageSettings.getContextFolder());
		EnvironmentService.setContextPath("ctm-HLT-1234/");
		assertEquals("app/", pageSettings.getContextFolder());
	}

    @Test
    public void testGetContextFolderDevBranch() throws ConfigSettingException {
        String branchContext = "ctm/";
        setContextPathSettingCTM();
        // Feature branch in dev
        PowerMockito.when(EnvironmentService.needsManuallyAddedBrandCodeParam()).thenReturn(true);
        PowerMockito.when(EnvironmentService.getEnvironmentAsString()).thenReturn("NXI");
        PowerMockito.when(EnvironmentService.getContextPath()).thenReturn(branchContext);
        assertEquals("Override in dev environments", branchContext, pageSettings.getContextFolder());
    }

    public void setContextPathSettingCTM() {
        ConfigSetting setting = new ConfigSetting();
        setting.setName("contextFolder");
        setting.setValue(contextFolderValue);
        when(vertical.getSettingForName("contextFolder")).thenReturn(setting);
    }

    @Test
	public void testGetSettingAsBoolean() throws Exception {
        ConfigSetting settingYes = new ConfigSetting();
        settingYes.setValue("Y");

        ConfigSetting settingNo = new ConfigSetting();
        settingNo.setValue("N");
		pageSettings.setBrand(brand);

		String testCode = "testCode";
        when(vertical.getSettingForName(testCode)).thenReturn(settingYes);
		boolean result = pageSettings.getSettingAsBoolean(testCode);
		assertTrue(result);


        when(vertical.getSettingForName(testCode)).thenReturn(settingNo);
		result = pageSettings.getSettingAsBoolean(testCode);
		assertFalse(result);

	}

}