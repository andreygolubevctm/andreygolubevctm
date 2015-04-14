package com.ctm.router.travel;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ctm.dao.ProviderDao;
import com.ctm.exceptions.DaoException;
import com.ctm.model.Provider;
import com.ctm.services.EnvironmentService;
import com.ctm.services.EnvironmentService.Environment;
import org.apache.log4j.Logger;

import com.ctm.exceptions.UploaderException;
import com.ctm.services.travel.UploadService;


@WebServlet(urlPatterns = {
		"/travel/countrymapping/import",
})

/* Due to timelines, most of this code is a copy and paste of the CreditCardsRouter.java file. Would be nice to do a proper refactor down the track */

public class TravelRouter extends HttpServlet {
	private static Logger logger = Logger.getLogger(TravelRouter.class.getName());
	private static final long serialVersionUID = 70L;

	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		String uri = request.getRequestURI();

		if(uri.endsWith("/travel/countrymapping/import") && (EnvironmentService.getEnvironment() == Environment.LOCALHOST || EnvironmentService.getEnvironment() == Environment.NXI)){
			try {
				ProviderDao providerDao = new ProviderDao();
				UploadService uploadService = new UploadService();
				uploadService.uploadFile(request);

				Provider provider = providerDao.getProviderDetails(uploadService.getProviderCode(), "destMappingType");

				InputStream input = new ByteArrayInputStream(uploadService.importPartnerMapping(provider.getId(), provider.getPropertyDetail("mappingType")).getBytes("UTF-8"));

				response.setContentType("text/plain");
				response.addHeader("Content-Disposition", "attachment; filename="+uploadService.getAttachmentName());

				OutputStream responseOutputStream = response.getOutputStream();
				int bytes;
				while ((bytes = input.read()) != -1) {
					responseOutputStream.write(bytes);
				}
				input.close();
				responseOutputStream.flush();
				responseOutputStream.close();


			} catch (UploaderException | DaoException e) {
				logger.error(e);
			}
		}
	}
}
