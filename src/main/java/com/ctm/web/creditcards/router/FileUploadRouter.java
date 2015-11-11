package com.ctm.web.creditcards.router;

import com.ctm.web.core.exceptions.UploaderException;
import com.ctm.web.creditcards.model.UploadRequest;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class FileUploadRouter extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public UploadRequest Upload(HttpServletRequest request,
		HttpServletResponse response) throws UploaderException {
		return parseRequest(request);
	}

	private UploadRequest parseRequest(HttpServletRequest request) throws UploaderException {
		UploadRequest _request = new UploadRequest();
		_request.deleteId = "";

		if (ServletFileUpload.isMultipartContent(request)) {
			try {
				FileItemFactory factory = new DiskFileItemFactory();

				List<FileItem> multiparts = new ServletFileUpload(factory).parseRequest(request);
				for (FileItem item : multiparts) {
					String name = item.getFieldName().trim();
					String value = item.getString().trim();
					if (item.isFormField()) {
						if (name.equals("providercode")) {
							_request.providerCode =  value;
						} else if (name.equals("effectivedate")) {
							_request.effectiveDate =  value;
						} else if (name.equals("jira")) {
							_request.jira =  value;
						} else if (name.equals("deleteid")) {
							if(_request.deleteId != "") {
								_request.deleteId += ",";
							}
							_request.deleteId += value;
						}
					}
					else {
						long sizeInBytes = item.getSize();
						if (sizeInBytes > 0) {
							_request.uploadedStream = item.getInputStream();
						}
					}
				}
			} catch (IOException | FileUploadException| NumberFormatException e) {
				throw new UploaderException("failed to parse request " + request , e);
			}
		}
		return _request;
	}

}
