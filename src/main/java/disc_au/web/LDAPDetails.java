/**  =========================================== */
/**  ===  AGH Compare The Market Aggregator  === */
/**  LDAPDetails class: Determine LDAP directory-based login details
 *   $Id$
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.disc_au.web;

import org.apache.log4j.Logger;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;

public class LDAPDetails {
	private final Logger logger = Logger.getLogger(Dreammail.class.getName());

	protected Hashtable<String, String> userDetails = null;
	protected String PROVIDER_URL            = "ldap://argon.budgetdirect.com.au:389";
	protected String SECURITY_AUTHENTICATION = "Simple";
	protected String SECURITY_PRINCIPAL      = "CTM LDAP";
	protected String SECURITY_CREDENTIALS    = "Bind_Ldap$";

	public LDAPDetails() {
		this("");
	}

	public LDAPDetails(final String userName) {
		if ( userName != null && !userName.isEmpty() ) {
			this.userDetails = this.getUserBasicAttributes(userName, this.getLdapContext());
		} else {
			logger.error(DateFormat.getInstance().format(new Date()));
			logger.error(":\tcom.disc_au.web.LDAPDetails constructor called with no user name parameter");
		}
	}

	public Hashtable<String, String> getDetails() {
		return this.userDetails;
	}

	public LdapContext getLdapContext(){
		LdapContext ctx = null;

		try {
			final Hashtable<String, String> env = new Hashtable<>();
			env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.PROVIDER_URL,            this.PROVIDER_URL);
			env.put(Context.SECURITY_AUTHENTICATION, this.SECURITY_AUTHENTICATION);
			env.put(Context.SECURITY_PRINCIPAL,      this.SECURITY_PRINCIPAL);
			env.put(Context.SECURITY_CREDENTIALS,    this.SECURITY_CREDENTIALS);
			ctx = new InitialLdapContext(env, null);
		} catch (final NamingException nex) {
			logger.error(DateFormat.getInstance().format(new Date()));
			logger.error(":\tLDAP Connection FAILED");
		}

		return ctx;
	}

	private Hashtable<String, String> getUserBasicAttributes(final String userName, final LdapContext ctx) {
		Hashtable<String, String> userDetails = null;

		if ( ctx != null ) {
			try {
				final SearchControls constraints = new SearchControls();
				constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);

				final String[] attrIDs = { "postalCode", "displayName", "givenname", "sn", "mail", "userPrincipalName", "distinguishedName", "memberOf" };
				constraints.setReturningAttributes(attrIDs);
				final NamingEnumeration<SearchResult> answer = ctx.search("OU=AIH Users,DC=budgetdirect,DC=com,DC=au", "sAMAccountName=" + userName, constraints);

				if (answer.hasMore()) {
					final Attributes attrs = answer.next().getAttributes();
					userDetails = new Hashtable<>();
					userDetails.put("uid",            userName);
					userDetails.put("loginTimestamp", (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new Date()));

					for (final String attrName : attrIDs) {
						final String attrValue = attrs.get(attrName) == null ? "" : attrs.get(attrName).toString().replaceFirst("^" + attrName + ": ", "");
						userDetails.put(attrName, attrValue);
					}
				} else {
					throw new Exception("Invalid User");
				}
			} catch (final Exception ex) {
				logger.error(ex);
			}
		}

		return userDetails;
	}
}