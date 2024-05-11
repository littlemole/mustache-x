package org.oha7.contactsJetty;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Locale;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import com.github.mustachejava.DefaultMustacheFactory;
import com.github.mustachejava.Mustache;
import com.github.mustachejava.MustacheFactory;

import org.oha7.contactsJetty.infra.I18N;
import org.oha7.contactsJetty.viewModel.I18nViewModel;


public class View {

	private Locale locale;
	private String tpl;
	private String contentType = "text/html";

	public View(Locale locale, String tpl) {
		this.locale = locale;
		this.tpl = tpl;
	}

	public View contentType(String type) {
		this.contentType = type;
		return this;
	}

	public void render(HttpServletResponse response, I18nViewModel viewModel) throws IOException {

		updateLocale(viewModel);
		setLocaleCookie(response);
		doRender(response,viewModel);
	}

	public void render(HttpServletResponse response, Object viewModel) throws IOException {

		doRender(response,viewModel);
	}

	private void doRender(HttpServletResponse response, Object viewModel) throws IOException {

		response.setContentType(contentType);

		Writer writer = new OutputStreamWriter(response.getOutputStream());
		MustacheFactory mf = new DefaultMustacheFactory();
		Mustache mustache = mf.compile(this.tpl);
		mustache.execute(writer, viewModel);
		writer.flush();            
	}

	private void updateLocale(I18nViewModel viewModel) {

		viewModel.locale = this.locale;
		I18N.Language[] langs = new I18N.Language[I18N.languages_avail.length];

		for( int i = 0; i < I18N.languages_avail.length; i++ ) {

			String l = I18N.languages_avail[i];
			Locale loc = I18N.fromString(l);

			langs[i] = new I18N.Language(loc, l.equals(this.locale.getLanguage()) ? true : false);
		}
		viewModel.languages = langs;
	}

	private void setLocaleCookie(HttpServletResponse response) {

		Cookie cookie = new Cookie("language", this.locale.toString());
		cookie.setPath("/");
		response.addCookie(cookie);
	}
}
