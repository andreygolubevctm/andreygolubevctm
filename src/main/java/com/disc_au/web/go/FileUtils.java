package com.disc_au.web.go;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.MappedByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.charset.Charset;
import java.util.ArrayList;
/**
 * The Class FileUtils.
 *
 * @author aransom
 * @version 1.0
 */

@SuppressWarnings("unchecked")
public class FileUtils {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileUtils.class.getName());

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
			System.out.println(className);
				if(className.indexOf(CLASSPATH) == -1) {
					return className.substring(0, className.indexOf("/build/classes/"))+ path; //get the root path portion
				} else {
					return className.substring(0, className.indexOf(CLASSPATH))+ path; //get the root path portion
				}
			}catch(Exception e){
				LOGGER.error("", e);
			}
			return "";
		}


	public static String readFile(String path) throws IOException {
		System.out.println(localPath(path));
		FileInputStream stream = new FileInputStream(new File(localPath(path)));
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
