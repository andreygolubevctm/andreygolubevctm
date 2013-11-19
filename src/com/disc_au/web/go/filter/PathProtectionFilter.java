package com.disc_au.web.go.filter;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;



public class PathProtectionFilter implements Filter {

	public static final String DATA_BEAN_NAME = "data-bean-name";
	public static final String DEFAULT_BEAN_NAME = "data";

	private String beanName;


	@Override
	public void destroy() {
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest)req;


		if ( httpRequest.getSession() == null
				|| httpRequest.getSession().getAttribute(this.beanName) == null){

			// Flick 403 here
			HttpServletResponse httpResponse = (HttpServletResponse)resp;
			httpResponse.setStatus(HttpServletResponse.SC_FORBIDDEN);
			httpResponse.setContentType("text/html");
			PrintWriter out = httpResponse.getWriter();
			out.print("<html><body>403 Forbidden</body></html>\r\n");
			out.flush();
			out.close();
		} else {
			chain.doFilter(req, resp);
		}

	}

	@Override
	public void init(FilterConfig config) throws ServletException {
		this.beanName = config.getInitParameter(DATA_BEAN_NAME);
		if (this.beanName == null){
			this.beanName = DEFAULT_BEAN_NAME;
		}
	}

}
