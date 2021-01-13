package com.ctm.web.core.openinghours.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import com.ctm.web.core.openinghours.model.OpeningHours;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import javax.naming.NamingException;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.List;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.*;

public class OpeningHoursDaoTest {

    @InjectMocks
    private OpeningHoursDao openingHoursDao;

    @Mock
    private SimpleDatabaseConnection mockConnection;

    @Mock
    private Connection connection;

    @Mock
    private PreparedStatement statement;

    @Mock
    ResultSet mockResultSet;

    private static final List<String> COLUMN_NAMES = Arrays.asList(new String[]{"startTime", "endTime", "description", "date"});

    @Before
    public void setup() throws SQLException, NamingException {
        MockitoAnnotations.initMocks(this);
        when(mockConnection.getConnection()).thenReturn(connection);
        when(mockConnection.getConnection(any(String.class), any(Boolean.class))).thenReturn(connection);
        when(connection.prepareStatement(anyString())).thenReturn(statement);
        when(statement.executeQuery()).thenReturn(mockResultSet);
        openingHoursDao = new OpeningHoursDao(mockConnection);
    }

    @Test
    public void testOpeningHoursIncludingSpecialHoursForDisplay() throws Exception {
        ResultSet mockResultSet1 = ResultSetMock.mockResultSet(COLUMN_NAMES,
                "09:00:00", "20:00:00", "Monday", null
                , "09:00:00", "20:00:00", "Tuesday", null
                , "09:00:00", "20:00:00", "Wednesday", null
                , "09:00:00", "20:00:00", "Thursday", null
                , "10:00:00", "19:00:00", "Friday", new Date(new GregorianCalendar(2021, Calendar.JANUARY, 11).getTimeInMillis()));

        when(statement.executeQuery()).thenReturn(mockResultSet1);
        List<OpeningHours> openingHours = openingHoursDao.getAllOpeningHoursForDisplay(4, new GregorianCalendar(2021, Calendar.JANUARY, 11).getTime());
        assertTrue(openingHours.size() == 5);
        Assert.assertEquals("10:00 am", openingHours.get(4).getStartTime());
        Assert.assertEquals("07:00 pm", openingHours.get(4).getEndTime());
    }

    @Test
    public void testOpeningHoursForDisplayForEmpty() throws Exception {
        when(mockResultSet.next()).thenReturn(false);
        java.util.Date effectiveDate = new GregorianCalendar(2021, Calendar.JANUARY, 11).getTime();
        List<OpeningHours> openingHours = openingHoursDao.getAllOpeningHoursForDisplay(4, effectiveDate);
        assertTrue(openingHours.isEmpty());
        verify(mockConnection, atMost(1)).getConnection();
        verify(connection, atMost(1)).prepareStatement(anyString());
        verify(statement, atMost(7)).setDate(anyInt(), eq(new java.sql.Date(effectiveDate.getTime())));
        verify(statement, atMost(3)).setInt(anyInt(), eq(4));
    }

    @Test
    public void testIsCallCentreOpen() throws Exception {
        when(mockResultSet.next()).thenReturn(true);

        when(mockResultSet.getTime("startTime")).thenReturn(Time.valueOf("09:00:00"));
        when(mockResultSet.getTime("endTime")).thenReturn(Time.valueOf("10:00:00"));
        assertTrue(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 9, 0, 0)));
        assertTrue(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 9, 59, 59)));

        when(mockResultSet.getTime("startTime")).thenReturn(Time.valueOf("20:11:11"));
        when(mockResultSet.getTime("endTime")).thenReturn(Time.valueOf("23:55:55"));
        assertTrue(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 20, 11, 11)));
        assertTrue(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 23, 55, 54)));
    }

    @Test
    public void testIsCallCentreClosed() throws Exception {
        when(mockResultSet.next()).thenReturn(true);

        when(mockResultSet.getTime("startTime")).thenReturn(Time.valueOf("09:00:00"));
        when(mockResultSet.getTime("endTime")).thenReturn(Time.valueOf("10:00:00"));
        assertFalse(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 10, 0, 0)));
        assertFalse(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 8, 59, 59)));

        when(mockResultSet.getTime("startTime")).thenReturn(Time.valueOf("20:11:11"));
        when(mockResultSet.getTime("endTime")).thenReturn(Time.valueOf("23:55:55"));
        assertFalse(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 20, 11, 10)));
        assertFalse(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 23, 55, 55)));

        when(mockResultSet.next()).thenReturn(false);
        assertFalse(openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 1, 1, 10, 0, 0)));
    }

    @Test
    public void testIsCallCentreNulls() throws Exception {
        when(mockResultSet.next()).thenReturn(true);

        when(mockResultSet.getTime("startTime")).thenReturn(null);
        when(mockResultSet.getTime("endTime")).thenReturn(null);
        assertFalse("No start or end times", openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 12, 25, 10, 0, 0)));

        when(mockResultSet.getTime("startTime")).thenReturn(Time.valueOf("09:00:00"));
        when(mockResultSet.getTime("endTime")).thenReturn(null);
        assertTrue("No end time, now after start", openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 12, 25, 10, 0, 0)));
        assertFalse("No end time, now before start", openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 12, 25, 8, 50, 0)));

        when(mockResultSet.getTime("startTime")).thenReturn(null);
        when(mockResultSet.getTime("endTime")).thenReturn(Time.valueOf("23:55:55"));
        assertFalse("No start time", openingHoursDao.isCallCentreOpen(4, LocalDateTime.of(2016, 12, 25, 10, 0, 0)));
    }
}