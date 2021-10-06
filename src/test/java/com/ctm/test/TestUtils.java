package com.ctm.test;


import com.ctm.web.core.model.settings.ConfigSetting;
import com.ctm.web.core.model.settings.PageSettings;
import com.ctm.web.core.model.settings.Vertical;
import com.ctm.web.core.results.model.ResultsTemplateItem;
import com.ctm.web.core.services.EnvironmentService;
import org.junit.Assert;
import org.mockito.Mockito;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.nio.charset.StandardCharsets;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class TestUtils {

	public static Vertical getHealthVertical(){
		Vertical vertical = new Vertical();
		vertical.setType(Vertical.VerticalType.HEALTH);
		ArrayList<ConfigSetting> configSettings = new ArrayList<ConfigSetting>();
		ConfigSetting setting = new ConfigSetting();
		setting.setName("rootUrl");
		setting.setValue("rootUrl");
		configSettings.add(setting);

		ConfigSetting emailTokenEncryptionKey = new ConfigSetting();
		emailTokenEncryptionKey.setName("emailTokenEncryptionKey");
		emailTokenEncryptionKey.setValue("emailTokenEncryptionKey");
		configSettings.add(emailTokenEncryptionKey);

		vertical.setConfigSettings(configSettings );

		setting = new ConfigSetting();
		setting.setName("contextFolder");
		setting.setValue("contextFolder");
		configSettings.add(setting);
		vertical.setConfigSettings(configSettings );
		return vertical;
	}

	public static PageSettings getCTMHealthPageSettings() throws Exception{
		EnvironmentService.setEnvironment(EnvironmentService.Environment.LOCALHOST.toString());
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

	public static ResultSet mockResultItemResultSet() throws SQLException {
		ResultSet resultSet = Mockito.mock(ResultSet.class);
		Mockito.when(resultSet.getInt("id")).thenReturn(0);
		Mockito.when(resultSet.getString("name")).thenReturn("name");
		Mockito.when(resultSet.getString("type")).thenReturn("type");
		Mockito.when(resultSet.getBoolean("status")).thenReturn(false);
		Mockito.when(resultSet.getInt("sequence")).thenReturn(1);
		Mockito.when(resultSet.getInt("parentId")).thenReturn(2);
		Mockito.when(resultSet.getString("resultPath")).thenReturn("resultPath");
		Mockito.when(resultSet.getString("vertical")).thenReturn("vertical");
		Mockito.when(resultSet.getString("className")).thenReturn("className");
		Mockito.when(resultSet.getString("extraText")).thenReturn("extraText");
		Mockito.when(resultSet.getBoolean("multiRow")).thenReturn(true);
		Mockito.when(resultSet.getBoolean("expanded")).thenReturn(false);
		Mockito.when(resultSet.getInt("helpId")).thenReturn(3);
		Mockito.when(resultSet.getString("shortlistKey")).thenReturn("shortlistKey");
		Mockito.when(resultSet.getInt("flag")).thenReturn(4);
		Mockito.when(resultSet.getString("groups")).thenReturn("groups");
		Mockito.when(resultSet.getString("caption")).thenReturn("caption");
		Mockito.when(resultSet.getString("description")).thenReturn("description");
		return resultSet;
	}

	public static void checkResultsTemplateItem(ResultsTemplateItem item) {
		Assert.assertEquals(item.getId(), 0);
		Assert.assertEquals(item.getName(), "name");
		Assert.assertEquals(item.getType(), "type");
		Assert.assertFalse(item.isStatus());
		Assert.assertEquals(item.getSequence(), 1);
		Assert.assertEquals(item.getParentId(), 2);
		Assert.assertEquals(item.getResultPath(), "resultPath");
		Assert.assertEquals(item.getVertical(), "vertical");
		Assert.assertEquals(item.getClassName(), "className");
		Assert.assertEquals(item.getExtraText(), "extraText");
		Assert.assertTrue(item.isMultiRow());
		Assert.assertFalse(item.isExpanded());
		Assert.assertEquals(item.getHelpId(), 3);
		Assert.assertEquals(item.getShortlistKey(), "shortlistKey");
		Assert.assertEquals(item.getFlag(), 4);
	}

	public static ResultSet mockTransactionDetailsResultSet() throws SQLException {
		ResultSet resultSet = Mockito.mock(ResultSet.class);
		Mockito.when(resultSet.getInt("id")).thenReturn(0);
		Mockito.when(resultSet.getString("name")).thenReturn("name");
		Mockito.when(resultSet.getString("type")).thenReturn("type");
		Mockito.when(resultSet.getBoolean("status")).thenReturn(false);
		Mockito.when(resultSet.getInt("sequence")).thenReturn(1);
		Mockito.when(resultSet.getInt("parentId")).thenReturn(2);
		Mockito.when(resultSet.getString("resultPath")).thenReturn("resultPath");
		Mockito.when(resultSet.getString("vertical")).thenReturn("vertical");
		Mockito.when(resultSet.getString("className")).thenReturn("className");
		Mockito.when(resultSet.getString("extraText")).thenReturn("extraText");
		Mockito.when(resultSet.getBoolean("multiRow")).thenReturn(true);
		Mockito.when(resultSet.getBoolean("expanded")).thenReturn(false);
		Mockito.when(resultSet.getInt("helpId")).thenReturn(3);
		Mockito.when(resultSet.getString("shortlistKey")).thenReturn("shortlistKey");
		Mockito.when(resultSet.getInt("flag")).thenReturn(4);
		Mockito.when(resultSet.getString("groups")).thenReturn("groups");
		Mockito.when(resultSet.getString("caption")).thenReturn("caption");
		Mockito.when(resultSet.getString("description")).thenReturn("description");
		return resultSet;
	}


}
