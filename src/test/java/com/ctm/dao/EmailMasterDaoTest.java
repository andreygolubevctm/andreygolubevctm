package com.ctm.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.junit.*;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.EmailMaster;

public class EmailMasterDaoTest {


	private SimpleDatabaseConnection dbSource = mock(SimpleDatabaseConnection.class);
	private PreparedStatement statement;
	private String vertical = "health";
	private String emailAddress = "test@test.com";
	private int brandId= 1;
	private ResultSet resultSet;

	@Before
	public void setup() throws SQLException, NamingException{
		Connection connection = mock(Connection.class);
		when(dbSource.getConnection()).thenReturn(connection);
		statement = mock(PreparedStatement.class);
		when(connection.prepareStatement(anyString())).thenReturn(statement);
		resultSet = mock(ResultSet.class);
		when(statement.executeQuery()).thenReturn(resultSet);
		when(resultSet.next()).thenReturn(true).thenReturn(false);
		when(resultSet.getString("hashedEmail")).thenReturn("test");
	}


	@Test
	public void testShouldGetOptOut() throws SQLException, DaoException {
		when(resultSet.getString("optedIn")).thenReturn("N");

		EmailMasterDao emailMasterDao = new EmailMasterDao(dbSource, vertical, brandId);
		EmailMaster emailDetails = emailMasterDao.getEmailDetails(emailAddress);
		assertFalse(emailDetails.getOptedInMarketing(vertical));
	}

	@Test
	public void testShouldGetOptIn() throws SQLException, DaoException {
		when(resultSet.getString("optedIn")).thenReturn("Y");

		EmailMasterDao emailMasterDao = new EmailMasterDao(dbSource, vertical, brandId);
		EmailMaster emailDetails = emailMasterDao.getEmailDetails(emailAddress);
		assertTrue(emailDetails.getOptedInMarketing(vertical));

	}

}
