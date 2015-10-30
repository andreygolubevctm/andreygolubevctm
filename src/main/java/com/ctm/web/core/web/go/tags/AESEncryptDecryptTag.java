package com.ctm.web.core.web.go.tags;

import com.ctm.web.core.security.StringEncryption;

import javax.servlet.jsp.JspException;
import java.io.IOException;
import java.security.GeneralSecurityException;

/**
 * AESEncryptDecryptTag uses the secret key and content provided to either
 * encrypt or decrypt the content.
 *
 * @author Mark Smerdon
 */

@SuppressWarnings("serial")
public class AESEncryptDecryptTag extends BaseTag {

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