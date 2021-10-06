package com.ctm.web.simples.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.exceptions.DaoException;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;

import javax.naming.NamingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Locale;
import java.util.Map;

public class MessageDetailDaoTest {

    private MessageDetailDao messageDetailDao;

    @Mock
    private ResultSet resultSet;
    @Mock
    SimpleDatabaseConnection databaseConnection;
    @Mock
    Connection connection;
    @Mock
    PreparedStatement preparedStatement;

    public MessageDetailDaoTest() throws SQLException {
    }

    @Before
    public void setUp() throws SQLException, NamingException {
        MockitoAnnotations.initMocks(this);
        MessageDetailDao.dbSource = databaseConnection;
        messageDetailDao = new MessageDetailDao();
        Mockito.when(databaseConnection.getConnection()).thenReturn(connection);
        Mockito.when(connection.prepareStatement(Mockito.anyString())).thenReturn(preparedStatement);
        Mockito.doNothing().when(preparedStatement).setLong(Mockito.anyInt(), Mockito.anyLong());
        Mockito.when(preparedStatement.executeQuery()).thenReturn(resultSet);
    }

    @Test
    public void getHealthProperties() throws SQLException, DaoException {
        testMessageDetailMap("health/situation/coverType", "coverTypeTextValue", "Product type", true);
        testMessageDetailMap("health/benefits/categorySelectHospital", "categorySelectHospitalTextValue", "Reason", true);
        testMessageDetailMap("health/benefits/quickSelectHospital", "quickSelectHospitalTextValue", "Hospital quick selects", true);
        testMessageDetailMap("health/benefits/categorySelectExtras", "categorySelectExtrasTextValue", "Extras quick selects", true);
        testMessageDetailMap("health/hospitalBenefitsSource", "hospitalBenefitsSourceTextValue", "Benefits source", true);
        testMessageDetailMap("health/benefits/benefitsExtras/PrHospital", "Private Hospital", "Benefits", false);
        testMessageDetailMap("health/benefits/benefitsExtras/PuHospital", "Private Patient in Public Hospital", "Benefits", false);
        testMessageDetailMap("health/benefits/benefitsExtras/DentalGeneral", "General Dental", "Benefits", true);
    }

    private void testMessageDetailMap(String xpath, String textValue, String newKey, boolean isExtras) throws SQLException, DaoException {
        Mockito.when(resultSet.next()).thenReturn(true).thenReturn(false);
        Mockito.when(resultSet.getString("xpath")).thenReturn(xpath);
        Mockito.when(resultSet.getString("textValue")).thenReturn(textValue);
        checkTransactionDetail(newKey, textValue, messageDetailDao.getHealthProperties(1L), isExtras);
    }

    private void checkTransactionDetail(String key, String textValue, Map<String, String> result, boolean isExtras) {
        Assert.assertEquals(isExtras ? textValue : textValue.toUpperCase(Locale.ROOT), isExtras ? result.get(key) : result.get(key).toUpperCase(Locale.ROOT));
    }
}
