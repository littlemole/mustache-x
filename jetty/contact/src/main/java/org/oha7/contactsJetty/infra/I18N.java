package org.oha7.contactsJetty.infra;

import java.util.ResourceBundle;
import java.util.HashMap;
import java.util.Map;
import java.util.Locale;


public class I18N {

	public static class Language {
		public Locale locale;
		public boolean active;

		public Language(Locale locale, boolean active) {
			this.locale = locale;
			this.active = active;
		}
	}

	public static String[] languages_avail = new String[] {"en" } ;

	private static Map<Locale,ResourceBundle> properties = new HashMap<Locale,ResourceBundle>();

	public static String getKey(Locale locale, String key)
	{
		ResourceBundle bundle = getBundle(locale);
		if(bundle == null) return null;
		return bundle.getString(key);
	}

	public static ResourceBundle getBundle(Locale locale)
	{
		if(properties.containsKey(locale))
		{
			return properties.get(locale);
		}

		ResourceBundle bundle = ResourceBundle.getBundle("locale/locale", locale);
		properties.put(locale, bundle);
		return bundle;
	}

	public static Locale fromString(String value) {
		if(value.contains("_"))
		{
			String[] parts = value.split("_");
			if(parts.length > 1)
			{
				Locale locale = new Locale(parts[0], parts[1]);
				return locale;
			}	
		}

		Locale locale = new Locale(value);
		return locale;
	}
}
