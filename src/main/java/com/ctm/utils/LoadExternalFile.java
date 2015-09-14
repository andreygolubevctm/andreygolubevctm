package com.ctm.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import sun.misc.BASE64Encoder;

import javax.net.ssl.HttpsURLConnection;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

/**
 * LoadExternalFile loads the content of a url into a string. Provide a username and password
 * when authorisation is required.
 *
 * This process assumes that you don't have a proxy preventing access to external sites. In that
 * case add applicable setting to your setup (eclipse, server... wherever)
 */

public class LoadExternalFile {

    private static final Logger logger = LoggerFactory.getLogger(LoadExternalFile.class.getName());

    private String m_username;
    private String m_password;
    private String m_url;
    private String m_output;

    public LoadExternalFile(){}

    public String getContent( String url, String username, String password )
    {
        try
        {
            m_username = username;
            m_password = password;
            m_url = url;

            m_output = doHttpUrlConnectionAction();
        }
        catch (Exception e)
        {
            logger.error("Failed to get content", e);
            m_output = "";
        }

        return m_output;
    }

    private String doHttpUrlConnectionAction() throws Exception
    {
        BufferedReader reader = null;
        StringBuilder stringBuilder;
        String output = "";
        try
        {
            // create the HttpURLConnection
            URL url = new URL( m_url );
            HttpsURLConnection connection = (HttpsURLConnection) url.openConnection();

            // Add applicable settings to connection
            connection.setRequestMethod("POST");
            HttpsURLConnection.setFollowRedirects(true);
            connection.setInstanceFollowRedirects(true);
            connection.setReadTimeout(30*1000);

            // Add authorization if username and password provided
            if( m_username != null && m_password != null )
            {
                connection.setRequestProperty("Authorization", "Basic " + encode(m_username + ":" + m_password));
            }

            // Only needed if proxy settings are not defined elsewhere
            //System.setProperty("https.proxyHost", "192.168.1.111");
            //System.setProperty("https.proxyPort", "8080");

            // Read the response and write to output
            InputStream content = (InputStream) connection.getInputStream();
            BufferedReader in = new BufferedReader (new InputStreamReader(content));
            String line;
            while ((line = in.readLine()) != null)
            {
                output += line;
            }
        }
        catch (Exception e)
        {
            logger.error("Failed to call url", e);
            output = "";
        }

        return output;
    }

    public String encode (String source)
    {
        BASE64Encoder enc = new sun.misc.BASE64Encoder();
        return(enc.encode(source.getBytes()));
    }
}
