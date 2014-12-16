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
				output = decrypt();
			}
			pageContext.getOut().write(output);
			return SKIP_BODY;
		} catch (GeneralSecurityException | IOException e) {
			throw new JspException(e);
		}
	}

	public String decrypt() throws GeneralSecurityException {
		String output;
		// Convert the string version of the key to a SecretKey object
		byte[] encoded_secret_key = Base64.decodeBase64(this.key);
		final SecretKeySpec secret_key = new SecretKeySpec(encoded_secret_key, "AES");

		// Create Cipher object needed to do encryption/decryption
		Cipher aes_cipher = Cipher.getInstance("AES");
		aes_cipher.init(Cipher.ENCRYPT_MODE, secret_key);

		// Decrypt the content
		aes_cipher.init(Cipher.DECRYPT_MODE, secret_key, aes_cipher.getParameters());
		byte[] content_as_byte_cipher_text = Base64.decodeBase64(this.content);
		byte[] decrypted_text_as_bytes = aes_cipher.doFinal(content_as_byte_cipher_text);
		output = new String(decrypted_text_as_bytes);
		// Important! keep this as debug and don't enable debug logging in production
		// as this may include credit card details (this is from the nib webservice)
		logger.debug("Decrypted content: " + output);
		return output;
	}
}