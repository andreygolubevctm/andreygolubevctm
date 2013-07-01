package com.disc_au.web.go;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.PageContext;
/**
 * The Class FileUtils.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class FileUtils {

	/**
	 * Retrieve the files in a directory
	 *
	 * @param text String to convert
	 *
	 */
	public static ArrayList listFiles(String path, PageContext context){
		String realPath = localPath(path, context);
		return walkDir(realPath);
	}
	
	public static ArrayList listFilesStartingWith(String path, PageContext context, Boolean recursive, String startsWith){
		String realPath = localPath(path, context);
		return walkDir(realPath, recursive, startsWith);
	}
	
	public static ArrayList walkDir(String path){
		return walkDir(path, false, "");
	}

	public static ArrayList walkDir(String path, Boolean recursive){
		return walkDir(path, recursive, "");
	}
	
	public static ArrayList walkDir(String path, Boolean recursive, String startsWith){
		
		ArrayList v = new ArrayList();
		File d = new File(path);
		
		if (d.isDirectory()){
			
			for (File f : d.listFiles()) {
				
				if ( recursive && f.isDirectory() ) {
					v.addAll( walkDir( f.getAbsolutePath(), recursive, startsWith ) );
	            } else {
	            	if( (startsWith != "" && f.getName().startsWith(startsWith)) || startsWith == ""){
	            		v.add(f);
	            	}
	            }
			}
		}
		return v;
	}
	
	public static String localPath(String path){
		return FileUtils.localPath(path, null);
	}

	public static String localPath(String path, PageContext context){
		
		if(context != null) {
			/* USING SERVLET CONTEXT TO GET REAL PATH (MIGHT NOT WORK WHEN USING war FILES TO DEPLOY */
			return context.getServletContext().getRealPath(path);
		} else {
			/* USING THE CLASS PATH TO DETERMINE OTHERS FILES' REALPATH */
			try {
				if (!path.substring(0,1).equals('/')){
					path="/" + path;
				}
			} catch(Exception e){
				System.err.println("Invalid path:" + path);
			}
			
			// Very evil hack to determine the actual local path of the given
			// relative path - as static functions do not have access to the ServletContext
			// otherwise, we could just get the real path from that
			final String CLASSPATH = "/WEB-INF/classes/";
			try {
				URL url = FileUtils.class.getResource("FileUtils.class");	//let javaloader find the complete class path of this class first
				String className = url.getFile();	 //get the complete file path from URL
				if(className.indexOf(CLASSPATH) == -1) {
					return className.substring(0, className.indexOf("/build/classes/"))+ path; //get the root path portion
				} else {
					return className.substring(0, className.indexOf(CLASSPATH))+ path; //get the root path portion
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return "";
		}
	}

	public static String readFile(String path) throws IOException {
		return FileUtils.readFile(path, null);
	}

	public static String readFile(String path, PageContext context) throws IOException {
		FileInputStream stream = new FileInputStream(new File(localPath(path, context)));
		try {
			FileChannel fc = stream.getChannel();
			MappedByteBuffer bb = fc.map(FileChannel.MapMode.READ_ONLY, 0,
					fc.size());
			/* Instead of using default, pass in a decoder. */
			return Charset.defaultCharset().decode(bb).toString();
		} finally {
			stream.close();
		}
	}
	
	public static String downloadFile(String path, PageContext context) throws IOException {
		
		String filename = path.substring(path.lastIndexOf('/') + 1);
		
		HttpServletResponse response = (HttpServletResponse) context.getResponse();
		response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition","attachment;filename=" + filename);
        
        ServletOutputStream out = response.getOutputStream();
        FileInputStream in = new FileInputStream(new File(localPath(path, context)));
        try
        {
    		byte[] outputByte = new byte[4096];
    		//copy binary context to output stream
    		while(in.read(outputByte, 0, 4096) != -1)
    		{
    			out.write(outputByte, 0, 4096);
    		}
    		in.close();
    		out.flush();
        } finally {
        	out.close();
        }
        return null;
	}

	/**
	 * Check if file exists
	 *
	 * @param text Path to file
	 *
	 */
	public static boolean exists(String filePath){
		//String localPath = localPath(filePath);
		//File f = new File(localPath);
		File f = new File(filePath);
		return f.exists();
	}
}
