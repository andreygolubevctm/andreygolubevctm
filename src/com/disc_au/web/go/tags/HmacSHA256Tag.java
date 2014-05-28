package com.disc_au.web.go.tags;

import javax.servlet.jsp.JspException;

import com.ctm.security.StringEncryption;

public class HmacSHA256Tag extends BaseTag {

	private static final long serialVersionUID = 1L;

	private String username = "";
	private String password = "";
	private String brand = "";
	private Integer MAX_LENGTH = 1000;

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

			// Build the credentials string
			String credentials = this.username + this.password + this.brand;

			StringEncryption encyption = new StringEncryption();
			String output = encyption.encrypt(credentials);

			pageContext.getOut().write(output);

			return SKIP_BODY;

		} catch (Exception e) {
			throw new JspException(e);
		}
	}
}
