package com.disc_au.web.go.tags;

import java.io.IOException;
import java.security.SecureRandom;
import java.security.NoSuchAlgorithmException;
import java.security.InvalidParameterException;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.servlet.jsp.JspException;
import org.apache.commons.codec.binary.Base64;

/**
 * AESGenerateKeyTag generates an AES secret key based on the key size provided.
 *
 * @author Mark Smerdon
 */

@SuppressWarnings("serial")
public class AESGenerateKeyTag extends BaseTag {

	int key_size = 128;

	public void setKeysize(int keysize)
	{
		this.key_size = keysize;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {

		String output = "";

		try
		{
			KeyGenerator key_gen = KeyGenerator.getInstance("AES");
			SecureRandom random = new SecureRandom();
			key_gen.init(this.key_size, random);
			SecretKey secret_key = key_gen.generateKey();
			byte[] enc_key = secret_key.getEncoded();
			output = Base64.encodeBase64URLSafeString(enc_key);
			System.out.println("Key Size: " + this.key_size);
			System.out.println("Secret Key: " + output);

			pageContext.getOut().write(output);

			return SKIP_BODY;
		}
		catch(InvalidParameterException e)
		{
			throw new JspException(e);
		}
		catch(NoSuchAlgorithmException e)
		{
			throw new JspException(e);
		}
		catch(IOException e)
		{
			throw new JspException(e);
		}
	}
}