package com.ctm.test;

import com.ctm.model.settings.ConfigSetting;
import com.ctm.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.model.settings.Vertical.VerticalType;
import com.ctm.web.core.services.EnvironmentService;
import com.ctm.web.core.services.EnvironmentService.Environment;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

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
		pageSettings.setVertical(TestUtils.getHealthVertical());
		return pageSettings;
	}

	public static HttpURLConnection createFakeConnection() throws IOException {
		HttpURLConnection connection= mock(HttpURLConnection.class);
		InputStream stream = new ByteArrayInputStream("respone".getBytes(StandardCharsets.UTF_8));
		when(connection.getInputStream()).thenReturn(stream);
		OutputStream outputStream = mock(OutputStream.class);
		when(connection.getOutputStream()).thenReturn(outputStream);
		when(connection.getResponseCode()).thenReturn(200);
		return connection;
	}


}
