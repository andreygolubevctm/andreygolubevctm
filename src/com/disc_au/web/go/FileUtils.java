package com.disc_au.web.go;

import java.io.File;
import java.net.URL;
import java.util.ArrayList;
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
	public static ArrayList listFiles(String path){
		
		String realPath = localPath(path);
		
		ArrayList v = new ArrayList();
		File d = new File(realPath);
		
		if (d.isDirectory()){
			for (File f : d.listFiles()) {
				if (f.isFile()) {
					v.add(f.getName());
				}	
			}
		}
		return v;
	}
	
	public static String localPath(String path){
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
			return className.substring(0, className.indexOf(CLASSPATH))+ path; //get the root path portion 
		}catch(Exception e){
			e.printStackTrace();
		}
		return "";
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
