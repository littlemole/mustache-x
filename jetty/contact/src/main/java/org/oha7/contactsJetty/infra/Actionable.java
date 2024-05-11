package org.oha7.contactsJetty.infra;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.regex.Matcher;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.View;


public interface Actionable {
    
	public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException;

	default public void render(HttpServletResponse response, String txt) throws IOException {

		render(response,txt,"text/html;");
	}

	default public void render(HttpServletResponse response, String txt, String contentType) throws IOException {

		response.setContentType(contentType);

		PrintWriter writer = response.getWriter();
		writer.println( txt); 
		writer.flush();            
	}

	default public void redirect(HttpServletResponse response, String location) {

		redirect(response,location,303);
	}

	default public void redirect(HttpServletResponse response, String location, int status) {
		
		response.setStatus(status);
		response.setHeader("Location", location);
	}

	default public Locale getLocale(HttpServletRequest request) {

		Locale locale = request.getLocale();

		String queryParam = request.getParameter("lang");
		if(queryParam != null && !queryParam.isEmpty()) {
			locale = I18N.fromString(queryParam);
		}
		else {
			Cookie[] cookies = request.getCookies();
			if(cookies != null)
			for(Cookie cookie : cookies ) {
				if(cookie.getName().equals("language")) {
					String value = cookie.getValue();
					locale = I18N.fromString(value);
					break;
				}
			}
		}
		return locale;
	}

	default public View view(HttpServletRequest request, String tpl) {
		Locale locale = getLocale(request);
		return new View(locale,tpl);
	}
}
