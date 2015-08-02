package com.ctm.dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import javax.naming.NamingException;

import org.apache.log4j.Logger;

import com.ctm.connectivity.SimpleDatabaseConnection;
import com.ctm.exceptions.DaoException;
import com.ctm.model.CronJob;

public class CronDao {

	private static Logger logger = Logger.getLogger(CronDao.class.getName());

	public ArrayList<CronJob> getJobs(String rootURL, String frequency) throws DaoException{

		SimpleDatabaseConnection dbSource = null;

		ArrayList<CronJob> cron_jobs = new ArrayList<CronJob>();

		try{
			dbSource = new SimpleDatabaseConnection();
			PreparedStatement stmt;

			stmt = dbSource.getConnection().prepareStatement(
				"SELECT cj.cronID AS id, cj.cronStyleCodeID AS styleCodeID, cj.cronVerticalID AS verticalID," +
				"cj.cronFrequency AS frequency, cj.cronURL AS url, cj.cronEffectiveStart AS effectiveStart," +
				"cj.cronEffectiveEnd AS effectiveEnd, cj.cronStatus AS status " +
				"FROM ctm.cron_jobs cj " +
				"WHERE cj.cronFrequency = ? " +
				"AND CURRENT_TIMESTAMP >= cj.cronEffectiveStart AND CURRENT_TIMESTAMP <= cj.cronEffectiveEnd " +
				"AND cj.cronStatus = '';"
			);
			stmt.setString(1, frequency);

			ResultSet resultSet = stmt.executeQuery();

			while (resultSet.next()) {

				String jobURLSuffix = resultSet.getString("url");
				String jobURL = rootURL + ((jobURLSuffix.charAt(0) == '/' ? "" : "/") + jobURLSuffix);

				CronJob job = new CronJob();
				job.setID(resultSet.getInt("id"));
				job.setStyleCodeID(resultSet.getInt("styleCodeID"));
				job.setVerticalID(resultSet.getInt("verticalID"));
				job.setFrequency(resultSet.getString("frequency"));
				job.setURL(jobURL);
				job.setEffectiveStart(resultSet.getDate("effectiveStart"));
				job.setEffectiveEnd(resultSet.getDate("effectiveEnd"));
				job.setStatus(resultSet.getString("status"));

				cron_jobs.add(job);
			}

		} catch (SQLException | NamingException e) {
			logger.error("Failed to get cron jobs for frequency:" + frequency , e);
			throw new DaoException(e.getMessage(), e);
		} finally {
			dbSource.closeConnection();
		}

		return cron_jobs;
	}

	public void writeLog(int cronID , String response) throws DaoException {

		SimpleDatabaseConnection dbSource = new SimpleDatabaseConnection();
		PreparedStatement stmt = null;

		try {
			stmt = dbSource.getConnection().prepareStatement(
				"INSERT INTO ctm.cron_jobs_log " +
				"(cronLogCronID, cronLogDateTime, cronLogResponse) " +
				"values (?, CURRENT_TIMESTAMP, ?); "
			);
			stmt.setInt(1, cronID);
			stmt.setString (2, response);

			stmt.executeUpdate();

		} catch (SQLException | NamingException e) {
			throw new DaoException("Failed to write to cron_jobs_log: " + e.getMessage() , e);
		} finally {
			dbSource.closeConnection();
		}
	}
}
