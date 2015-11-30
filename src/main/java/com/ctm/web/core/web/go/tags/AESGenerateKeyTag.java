package com.ctm.web.core.web.go.tags;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.servlet.jsp.JspException;
import java.io.IOException;
import java.security.InvalidParameterException;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

/**
 * AESGenerateKeyTag generates an AES secret key based on the key size provided.
 *
 * @author Mark Smerdon
 */

@SuppressWarnings("serial")
public class AESGenerateKeyTag extends BaseTag {

	private static final Logger LOGGER = LoggerFactory.getLogger(AESGenerateKeyTag.class.getName());

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
			LOGGER.debug("About to return key to page. {},{} ", kv("key_size", this.key_size), kv("secretKey", output));
			pageContext.getOut().write(output);

			return SKIP_BODY;
		}
		catch(InvalidParameterException | NoSuchAlgorithmException | IOException e) {
			throw new JspException(e);
		}
	}
}