package org.oha7.contactsJetty.viewModel;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Locale;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

import com.github.mustachejava.DefaultMustacheFactory;
import com.github.mustachejava.Mustache;
import com.github.mustachejava.MustacheFactory;
import com.github.mustachejava.TemplateFunction;

import org.oha7.contactsJetty.infra.I18N;


public class I18nViewModel {

	public Locale locale;
	public I18N.Language[] languages;
	public TemplateFunction i18n = (key) -> I18N.getKey(locale,key);
}
