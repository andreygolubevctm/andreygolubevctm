/**  =========================================== */
/**  ===  AGH Compare The Market Aggregator  === */
/**  LDAPDetails class: Determine LDAP directory-based login details
 *   $Id$
 * (c)2012 Auto & General Holdings Pty Ltd       */

package com.disc_au.web;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Vector;

import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attributes;
import javax.naming.directory.SearchControls;
import javax.naming.directory.SearchResult;
import javax.naming.ldap.InitialLdapContext;
import javax.naming.ldap.LdapContext;

public class LDAPDetails {

	protected Hashtable<String, String> userDetails = null;
	protected String PROVIDER_URL            = "ldap://argon.budgetdirect.com.au:389";
	protected String SECURITY_AUTHENTICATION = "Simple";
	protected String SECURITY_PRINCIPAL      = "CTM LDAP";
	protected String SECURITY_CREDENTIALS    = "Bind_Ldap$";

	public LDAPDetails() {
		this("");
	}

	public LDAPDetails(String userName) {
		if ( userName != null && userName != "" ) {
			this.userDetails = this.getUserBasicAttributes(userName, this.getLdapContext());
		} else {
			System.out.print(DateFormat.getInstance().format(new Date()));
			System.out.println(":\tcom.disc_au.web.LDAPDetails constructor called with no user name parameter");
		}
	}

	public Hashtable<String, String> getDetails() {
		return this.userDetails;
	}

	public LdapContext getLdapContext(){
		LdapContext ctx = null;

		try {
			Hashtable<String, String> env = new Hashtable<String, String>();
			env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
			env.put(Context.PROVIDER_URL,            this.PROVIDER_URL);
			env.put(Context.SECURITY_AUTHENTICATION, this.SECURITY_AUTHENTICATION);
			env.put(Context.SECURITY_PRINCIPAL,      this.SECURITY_PRINCIPAL);
			env.put(Context.SECURITY_CREDENTIALS,    this.SECURITY_CREDENTIALS);
			ctx = new InitialLdapContext(env, null);
		} catch (NamingException nex) {
			System.out.print(DateFormat.getInstance().format(new Date()));
			System.out.println(":\tLDAP Connection FAILED");
//			nex.printStackTrace();
		}

		return ctx;
	}

	private Hashtable<String, String> getUserBasicAttributes(String userName, LdapContext ctx) {
		Hashtable<String, String> userDetails = null;

		if ( ctx != null ) {
			try {
				SearchControls constraints = new SearchControls();
				constraints.setSearchScope(SearchControls.SUBTREE_SCOPE);

				String[] attrIDs = { "postalCode", "displayName", "givenname", "sn", "mail", "userPrincipalName", "distinguishedName", "memberOf" };
				constraints.setReturningAttributes(attrIDs);
				NamingEnumeration<SearchResult> answer = ctx.search("OU=AIH Users,DC=budgetdirect,DC=com,DC=au", "sAMAccountName=" + userName, constraints);

				if (answer.hasMore()) {
					Attributes attrs = ((SearchResult) answer.next()).getAttributes();
					userDetails = new Hashtable<String, String>();
					userDetails.put("uid",            userName);
					userDetails.put("loginTimestamp", (new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")).format(new Date()));

					Iterator ite = (new Vector(Arrays.asList(attrIDs))).iterator();
					while (ite.hasNext()) {
						String attrName = (String) ite.next();
						userDetails.put(attrName, attrs.get(attrName).toString().replaceFirst("^" + attrName + ": ", ""));
					}

//					System.out.print(DateFormat.getInstance().format(new Date()));
//					System.out.print(":\tCTM Simples LDAP Login Success: ");
//					System.out.print(userName);
//					System.out.print(" - ");
//					System.out.println(userDetails.get("distinguishedName"));
					//System.out.println("AgentID = " + userDetails.get("postalCode"));
				} else {
					throw new Exception("Invalid User");
				}
			} catch (Exception ex) {
//				ex.printStackTrace();
			}
		}

		return userDetails;
	}
}
