package com.disc_au.web.go.tags;

import java.io.IOException;
import java.security.GeneralSecurityException;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.jsp.JspException;

import org.apache.commons.codec.binary.Base64;
import org.apache.log4j.Logger;

import com.ctm.security.StringEncryption;

/**
 * AESEncryptDecryptTag uses the secret key and content provided to either
 * encrypt or decrypt the content.
 *
 * @author Mark Smerdon
 */

@SuppressWarnings("serial")
public class AESEncryptDecryptTag extends BaseTag {

	Logger logger = Logger.getLogger(AESEncryptDecryptTag.class.getName());

	String action = "";
	String key = "";
	String content = "";

	public void setAction(String action) {
		this.action = action;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public void setContent(String content) {
		this.content = content;
	}

	/* (non-Javadoc)
	 * @see javax.servlet.jsp.tagext.BodyTagSupport#doStartTag()
	 */
	@Override
	public int doStartTag() throws JspException {

		String output = "";

		try {
			if( this.action.compareTo("encrypt") == 0 ) {
				// Encrypt the content
				output = StringEncryption.encrypt(key, content);
			} 	else if (this.action.compareTo("decrypt") == 0) {
				output = StringEncryption.decrypt(this.key, this.content);
			}
			pageContext.getOut().write(output);
			reset();
			return SKIP_BODY;
		} catch (GeneralSecurityException | IOException e) {
			throw new JspException(e);
		}
	}

	private void reset() {
		action = "";
		key = "";
		content = "";
	}
}