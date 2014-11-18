package com.disc_au.web.go.tags;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.jsp.JspException;

import org.apache.commons.codec.binary.Base64;

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
			// Convert the string version of the key to a SecretKey object
			byte[] encoded_secret_key = Base64.decodeBase64(this.key);
			final SecretKeySpec secret_key = new SecretKeySpec(encoded_secret_key, "AES");

			// Create Cipher object needed to do encryption/decryption
			Cipher aes_cipher = Cipher.getInstance("AES");
			aes_cipher.init(Cipher.ENCRYPT_MODE, secret_key);

			if( this.action.compareTo("encrypt") == 0 )
			{
				// Encrypt the content
				byte[] content_as_bytes = this.content.getBytes();
				byte[] content_as_byte_cipher_text = aes_cipher.doFinal(content_as_bytes);
				output = Base64.encodeBase64URLSafeString(content_as_byte_cipher_text);
				System.out.println("Encrypted content: " + output);
			}
			else if (this.action.compareTo("decrypt") == 0)
			{
				// Decrypt the content
				aes_cipher.init(Cipher.DECRYPT_MODE, secret_key, aes_cipher.getParameters());
				byte[] content_as_byte_cipher_text = Base64.decodeBase64(this.content);
				byte[] decrypted_text_as_bytes = aes_cipher.doFinal(content_as_byte_cipher_text);
				output = new String(decrypted_text_as_bytes);
				System.out.println("Decrypted content: " + output);
			}

			pageContext.getOut().write(output);

			return SKIP_BODY;
		}
		catch (InvalidKeyException e)
		{
			throw new JspException(e);
		}
		catch (NoSuchPaddingException e)
		{
			throw new JspException(e);
		}
		catch (BadPaddingException e)
		{
			throw new JspException(e);
		}
		catch (IllegalBlockSizeException e)
		{
			throw new JspException(e);
		}
		catch (NoSuchAlgorithmException e)
		{
			throw new JspException(e);
		}
		catch (InvalidAlgorithmParameterException e)
		{
			throw new JspException(e);
		}
		catch(IOException e)
		{
			throw new JspException(e);
		}
	}
}