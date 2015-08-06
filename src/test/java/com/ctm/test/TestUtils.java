package com.ctm.test;

import java.util.ArrayList;

import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.PageSettings;
import com.ctm.model.settings.Vertical;
import com.ctm.model.settings.Vertical.VerticalType;
import com.ctm.services.EnvironmentService;
import com.ctm.services.EnvironmentService.Environment;

public class TestUtils {

	public static Vertical getHealthVertical(){
		Vertical vertical = new Vertical();
		vertical.setType(VerticalType.HEALTH);
		ArrayList<ConfigSetting> configSettings = new ArrayList<ConfigSetting>();
		ConfigSetting setting = new ConfigSetting();
		setting.setName("rootUrl");
		setting.setValue("rootUrl");
		configSettings.add(setting);
		vertical.setConfigSettings(configSettings );

		setting = new ConfigSetting();
		setting.setName("contextFolder");
		setting.setValue("contextFolder");
		configSettings.add(setting);
		vertical.setConfigSettings(configSettings );
		return vertical;
	}

	public static PageSettings getCTMHealthPageSettings() throws Exception{
		EnvironmentService.setEnvironment(Environment.LOCALHOST.toString());
		PageSettings pageSettings = new PageSettings();
		pageSettings.setBrandCode("TEST");
		pageSettings.setVertical(TestUtils.getHealthVertical() );
		return pageSettings;
	}


}
