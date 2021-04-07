/**  =========================================== */
/**  ===  AGH Compare The Market Aggregator  === */
/**  LDAPDetails class: Determine LDAP directory-based login details
 *   $Id$
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.ctm.web.core.web;

import com.ctm.web.core.services.EnvironmentService;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;

import static com.ctm.commonlogging.common.LoggingArguments.kv;

public class LDAPDetails {
	private static final Logger LOGGER = LoggerFactory.getLogger(LDAPDetails.class.getName());

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
			LOGGER.warn("constructor called with no user name parameter");
		}
	}

	public Hashtable<String, String> getDetails() {
		return this.userDetails;
	}

	public LdapContext getLdapContext(){
		LdapContext ctx = null;

		final Hashtable<String, String> env = new Hashtable<>();
		env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
		env.put(Context.PROVIDER_URL,            this.PROVIDER_URL);
		env.put(Context.SECURITY_AUTHENTICATION, this.SECURITY_AUTHENTICATION);
		env.put(Context.SECURITY_PRINCIPAL,      this.SECURITY_PRINCIPAL);
		env.put(Context.SECURITY_CREDENTIALS,    this.SECURITY_CREDENTIALS);
		try {
			ctx = new InitialLdapContext(env, null);
		} catch (final NamingException nex) {
			LOGGER.error("LDAP Connection FAILED. {}", kv("env", env), nex);
		}

		return ctx;
	}

	private Hashtable<String, String> getUserBasicAttributes(final String userName, final LdapContext ctx) {
		Hashtable<String, String> userDetails = null;

		if(StringUtils.equalsIgnoreCase("browsertest", userName) && EnvironmentService.getEnvironment() == EnvironmentService.Environment.PRO) {
			return null;
		}

		if ( ctx != null ) {
				final SearchControls constraints = new SearchControls();
				constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);

				final String[] attrIDs = { "postalCode", "displayName", "givenname", "sn", "mail", "userPrincipalName", "distinguishedName", "memberOf" };
				constraints.setReturningAttributes(attrIDs);
			final NamingEnumeration<SearchResult> answer;
			try {
				answer = ctx.search("OU=AIH Users,DC=budgetdirect,DC=com,DC=au", "sAMAccountName=" + userName, constraints);
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
					LOGGER.warn("Invalid User. {}", kv("userName", userName));
				}
			} catch (NamingException e) {
				LOGGER.error("Failed to call LDAP. {}", kv("userName", userName), e);
			}
		}

		return userDetails;
	}
}