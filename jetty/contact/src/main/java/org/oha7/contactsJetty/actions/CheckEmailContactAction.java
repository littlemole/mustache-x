package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Locale;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;
import org.oha7.contactsJetty.infra.I18N;


@Action(value = "^/([^/]*)/email$")
public class CheckEmailContactAction implements Actionable {
    
    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);
        String email = request.getParameter("email");

        Contact contact = ContactsRepository.getContactByEmail(email);

		String result = "";
        if(contact != null && contact.id != Integer.valueOf(id)) {

			Locale locale = getLocale(request);
            result = I18N.getKey(locale, "contact.error.email.taken");			
        }
		render(response,result);
    }
}
