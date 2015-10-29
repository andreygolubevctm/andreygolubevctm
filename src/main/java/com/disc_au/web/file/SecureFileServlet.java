package com.disc_au.web.file;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.Vector;

import static com.ctm.web.core.logging.LoggingArguments.kv;

/**
  * This Servlet is used to allow client access to files located in a secured folder.
  * 
  * Files that are to be accessed via this servlet must first be added to a <String> 
  * which has been stored as a session attribute 
  * 
  * 
  * 
  * @author aransom
  *
  */
public class SecureFileServlet extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {

	 private static final Logger LOGGER = LoggerFactory.getLogger(SecureFileServlet.class);

	 public final static String INIT_PARAM_SECURE_FOLDER = "secure-folder";
	 public static final String INIT_PARAM_ERROR_PAGE = "error-page";
	 private static final long serialVersionUID = 1L;
	 private final static String ATTRIB_SECURE_FILES = "secureFiles";
	 
	 private String secureFolder = "";
	 private String errorPage = "";
	 
	 public SecureFileServlet() {
		 super();		
	 }
	 
	 public void init()throws ServletException {  
		 super.init();
		 
		 this.secureFolder = this.getInitParameter(INIT_PARAM_SECURE_FOLDER);
		 this.errorPage = this.getInitParameter(INIT_PARAM_ERROR_PAGE);
		 
	 }

	 protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		 
		 boolean success = true; 
		 
		 String filename = request.getParameter("filename");
		 String filePath = this.secureFolder + File.separator + filename; 
		 
		 HttpSession session = request.getSession(true);		 
		 Vector<String> secureFiles = getSecureFiles(session);
		 
		 LOGGER.debug("Attempt to get secure file. {}" ,  kv("filename", filename));
		 
		 if (secureFiles != null && secureFiles.contains(filename)){
			 
			 File f = new File(filePath);
			 
			 //response.setContentType(this.mimeTypes.getContentType(f));
			 response.setContentType("application/pdf");
			 response.addHeader("content-disposition","inline; filename=" + filename);
			 
			 BufferedInputStream in = null;
			 BufferedOutputStream out = null;
			 try {
				 in = new BufferedInputStream(new FileInputStream(f));
				 out = new BufferedOutputStream(response.getOutputStream());
				 
				 byte[] buffer = new byte[2048];
				 int bytesRead;
				 // Flat read/write loop
				 while(-1 != (bytesRead = in.read(buffer, 0, buffer.length))) {
			        out.write(buffer, 0, bytesRead);
				 }
				 
			 } catch(final IOException e) {
				 LOGGER.error("Exception thrown. {}", kv("filePath",filePath), e);
				 success = false;
				 
			 } finally {
				 if (in != null){
					 in.close();
				 }
				 if (out != null){
					 out.close();
				 }
			 }
			 
		 } else {
			 LOGGER.error("File not found. {}", kv("filePath", filePath));
			 success = false;
		 }
		 
		 if (!success){
			 response.reset();
			 RequestDispatcher dis = session.getServletContext().getRequestDispatcher(this.errorPage);
			 dis.forward(request, response);
		 }
		 
	 }
	 @SuppressWarnings("unchecked")
	public static Vector<String> getSecureFiles(HttpSession session){
		 Vector<String> secureFiles = (Vector<String>)session.getAttribute(ATTRIB_SECURE_FILES);
		 if (secureFiles == null){
			 secureFiles = new Vector<String>();
			 session.setAttribute(ATTRIB_SECURE_FILES, secureFiles);
		 }
		 return secureFiles;
	 }
	 public static void addSecureFile(HttpSession session, String filename){
		 Vector<String> secureFiles = getSecureFiles(session);
		 
		 if (!secureFiles.contains(filename)){
			 secureFiles.add(filename);
		 }
	 }
	 public static void removeSecureFile(HttpSession session, String filename){
		 Vector<String> secureFiles = getSecureFiles(session);
		 
		 if (secureFiles.contains(filename)){
			 secureFiles.remove(filename);
		 }
	 }
	 public static void clearSecureFiles(HttpSession session){
		 Vector<String> secureFiles = getSecureFiles(session);
		 secureFiles.clear();
	 }	 
	 public static boolean secureFileExists(HttpSession session, String filename){
		 Vector<String> secureFiles = getSecureFiles(session);
		 
		 if (secureFiles != null && secureFiles.contains(filename)){
			 return true;
		 } else {
			 return false;
		 }
	 }

}
