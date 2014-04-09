package com.disc_au.web.go.tags;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import org.apache.commons.codec.binary.Base64;
import javax.servlet.jsp.JspException;

public class HmacSHA256Tag extends BaseTag {

	String username = "";
	String password = "";
	String brand = "";
	String salt = "++:A6Q6RC;ZXDHL50|e^f;L3?PU^/o#<K;brkE8J@7~4JFr.}U)qmS1ytN|E2qg"; //
	String secretKey = "MzJmOGM@#^584kNGNViYTEzMmMTUwMw=";
	String algorithm = "HmacSHA256";
	Integer MAX_LENGTH = 1000;

	/**
	 * Set the Username as lower case
	 * Cut it to 1000 characters to prevent CPU overload.
	 *
	 * @param username
	 */
	public void setUsername(String username) {
		int maxLength = (username.length() < this.MAX_LENGTH) ? username
				.length() : this.MAX_LENGTH;
		this.username = username.toLowerCase().substring(0, maxLength);
	}

	/**
	 * Set the Password.
	 * Cut it to 1000 characters to prevent CPU overload.
	 *
	 * @param password
	 */
	public void setPassword(String password) {
		int maxLength = (password.length() < this.MAX_LENGTH) ? password
				.length() : this.MAX_LENGTH;
		this.password = password.substring(0, maxLength);
	}

	/**
	 * Set the brand as lower case for #whitelabel in future
	 * Cut it to 1000 characters to prevent CPU overload.
	 *
	 * @param brand
	 */
	public void setBrand(String brand) {
		int maxLength = (brand.length() < this.MAX_LENGTH) ? brand.length()
				: this.MAX_LENGTH;
		this.brand = brand.toLowerCase().substring(0, maxLength);
	}

	public int doStartTag() throws JspException {

		try {
			// To Rollback to plaintext passwords, uncomment these lines
			// AND comment out the remaining lines 61-75
			// pageContext.getOut().write(this.username);
			// return SKIP_BODY;

			// Generate secret key
			Mac algorithm = Mac.getInstance(this.algorithm);
			SecretKeySpec secretKey = new SecretKeySpec(
					this.secretKey.getBytes(), this.algorithm);
			algorithm.init(secretKey);

			// Build the credentials string
			String credentials = this.username + this.password + this.brand;

			// Generate
			String output = Base64.encodeBase64String((algorithm
					.doFinal((this.salt + credentials).getBytes())));

			pageContext.getOut().write(output);

			return SKIP_BODY;

		} catch (Exception e) {
			throw new JspException(e);
		}
	}
}
