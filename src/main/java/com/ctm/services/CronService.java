package com.ctm.services;

import java.net.URL;
import java.util.ArrayList;
import java.util.Iterator;
import java.io.BufferedReader;
import java.io.InputStreamReader;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import com.ctm.dao.CronDao;
import com.ctm.model.CronJob;
import com.ctm.exceptions.DaoException;

public abstract class CronService {

	private static Logger logger = Logger.getLogger(CronService.class.getName());

	public static void execute(HttpServletRequest request, String frequency) throws DaoException {

		String rootURL = request.getRequestURL().toString().replace(request.getRequestURI().toString(), request.getContextPath());

		CronDao cronDao = new CronDao();
		ArrayList<CronJob> jobsToRun = cronDao.getJobs(rootURL, frequency);
		Iterator<CronJob> it = jobsToRun.iterator();
		while(it.hasNext())
		{
			CronJob job = it.next();
			String response = runJob(job);
			cronDao.writeLog(job.getID(), response);
		}
	}

	private static String runJob(CronJob job) {

		StringBuilder response = new StringBuilder();

		try {
			URL url = new URL(job.getURL());
			BufferedReader buffered_reader = new BufferedReader(new InputStreamReader(url.openStream()));
			String tempStr = null;
			Integer counter = 0;
			while (null != (tempStr = buffered_reader.readLine())) {
				if(counter > 0) {
					response.append(System.getProperty("line.separator"));
				}
				response.append(tempStr);
				counter++;
			}
		} catch (Exception e) {
			response.append(e.getMessage());
		}

		if(response.toString().equals(job.getURL())) {
			response.insert(0, "BAD URL: ");
		}

		return response.toString();
	}
}
