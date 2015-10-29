package com.ctm.web.travel.services;

import com.ctm.exceptions.UploaderException;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpServletRequest;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import static com.ctm.web.core.logging.LoggingArguments.kv;


public class UploadService {

	private static final Logger LOGGER = LoggerFactory.getLogger(UploadService.class);
	private String attachmentFilename;
	private String effectiveDate, providerCode, jira;
	private InputStream uploadedStream;

	public String importPartnerMapping(int providerId, String mappingType) throws UploaderException {

		// upload the file
		//UploadRequest file = uploadFile(request);

		StringBuilder update = new StringBuilder();

		try {

			update.append("UPDATE ctm.country_provider_mapping SET effectiveEnd='"+effectiveDate+"', status='X' WHERE providerId IN ("+providerId+");\r\n");

			int COUNTRY_ISO_CODE_COLUMN = 1;
			int COUNTRY_REGION_COLUMN = 2;
			int COUNTRY_PARTNER_MAPPING_COLUMN = 3;
			int COUNTRY_PRIORITY_ORDER_COLUMN = 4;
			int COUNTRY_HANDOVER_CODE_COLUMN = 5;
			int priority;

			String[] row;
			String line, regionValue = "", countryValue = "", isoCode, seperator = "", lineNext = "", handoverValue = "";

			BufferedReader in = new BufferedReader(new InputStreamReader(uploadedStream));

			// Get first line
			line = in.readLine().trim();

			update.append("INSERT INTO ctm.country_provider_mapping (`providerId`,`isoCode`, `regionValue`, `countryValue`, `handoverValue`, `priority`, `effectiveStart`, `effectiveEnd`) VALUES ");
			do {
				// update the line var with the next read line
				if( lineNext != null && !lineNext.equals("")) {
					line = lineNext.trim();
				}

				// split the line into a String array for easy access
				row = line.split(",(?=(?:(?:[^\"]*\"){2})*[^\"]*$)");

				// setup the values
				isoCode = row[COUNTRY_ISO_CODE_COLUMN].trim();
				handoverValue = row[COUNTRY_HANDOVER_CODE_COLUMN] != null ? row[COUNTRY_HANDOVER_CODE_COLUMN] : "";

				switch(mappingType) {
					case "country":
							regionValue = "";
							countryValue = row[COUNTRY_PARTNER_MAPPING_COLUMN];
						break;
					case "region":
							regionValue = row[COUNTRY_PARTNER_MAPPING_COLUMN];
							countryValue = "";
						break;
					case "both":
						regionValue = row[COUNTRY_REGION_COLUMN];
						countryValue = row[COUNTRY_PARTNER_MAPPING_COLUMN];
						break;
					default:
						break;
				}

				priority = Integer.parseInt(row[COUNTRY_PRIORITY_ORDER_COLUMN]) == 0 ? 300 : Integer.parseInt(row[COUNTRY_PRIORITY_ORDER_COLUMN]); // push the do not quote to the bottom of the priority

				// build the SQL string
				update.append(seperator + "\r\n(" + providerId + ", '" + isoCode + "', '" + regionValue + "', '" + countryValue + "', '"+ handoverValue +"', " + priority + ", '" + effectiveDate + "', '2040-12-12')");

				// set the seperator as a comma
				seperator = ",";

				// grab next line
				line = lineNext;
			} while(((lineNext = in.readLine()) != null) || line != null);

			in.close();

		}
		catch(IOException e) {
			LOGGER.error("Error importing partner mapping {},{}", kv("providerId", providerId), kv("mappingType", mappingType), e);
		}

		// close off the SQL statement
		update.append(";");

		return update.toString();
	}

	public String getAttachmentName() {
		return attachmentFilename;
	}

	public String getProviderCode() {
		return providerCode;
	}

	/* TODO: will need to redo this down the track with FileUploadRouter.java as that has a dependancy which forced me to do this  */
	public void uploadFile(HttpServletRequest request) throws UploaderException {

		if (ServletFileUpload.isMultipartContent(request)) {
			try {
				FileItemFactory factory = new DiskFileItemFactory();

				List<FileItem> multiparts = new ServletFileUpload(factory).parseRequest(request);
				for (FileItem item : multiparts) {
					String name = item.getFieldName().trim();
					String value = item.getString().trim();
					if (item.isFormField()) {
						switch (name) {
							case "providerCode":
								providerCode = value;
								break;
							case "effectivedate":
								effectiveDate = value;
								break;
							case "jira":
								jira = value;
								break;
						}
					}
					else {
						long sizeInBytes = item.getSize();
						if (sizeInBytes > 0) {
							uploadedStream = item.getInputStream();
						}
					}
				}
			} catch (IOException | FileUploadException| NumberFormatException e) {
				throw new UploaderException("failed to parse request " + request , e);
			}
		}

		attachmentFilename = jira+"_import_partnermapping_"+providerCode+".sql";
	}
}