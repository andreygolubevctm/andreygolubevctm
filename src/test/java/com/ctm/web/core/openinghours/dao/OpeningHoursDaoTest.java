package com.ctm.web.core.openinghours.dao;

import com.ctm.web.core.connectivity.SimpleDatabaseConnection;
import org.junit.Before;
import org.junit.Test;

import javax.naming.NamingException;
import java.sql.*;
import java.time.LocalDateTime;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.mockito.Matchers.any;
import static org.mockito.Matchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

public class OpeningHoursDaoTest {

	private SimpleDatabaseConnection mockConnection = mock(SimpleDatabaseConnection.class);
	private PreparedStatement statement = mock(PreparedStatement.class);
	private OpeningHoursDao openingHoursDao;
	ResultSet mockResultSet = mock(ResultSet.class);

	@Before
	public void setup() throws SQLException, NamingException {
		Connection connection = mock(Connection.class);
		when(mockConnection.getConnection()).thenReturn(connection);
		when(mockConnection.getConnection(any(String.class), any(Boolean.class))).thenReturn(connection);
		when(connection.prepareStatement(anyString())).thenReturn(statement);
		when(statement.executeQuery()).thenReturn(mockResultSet);

		openingHoursDao = new OpeningHoursDao(mockConnection);
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
}