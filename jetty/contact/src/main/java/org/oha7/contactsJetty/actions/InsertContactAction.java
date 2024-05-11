package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.Locale;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.eclipse.jetty.http.HttpMethod;
import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactErrors;
import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;
import org.oha7.contactsJetty.viewModel.ContactViewModel;


@Action(value = "^/new$", method=HttpMethod.POST )
public class InsertContactAction implements Actionable {
    
    public InsertContactAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        Contact contact = Contact.fromRequest(request);
		Locale locale = getLocale(request);

        ContactErrors errors = Contact.validateContact(locale,contact);

        if(!errors.hasErrors())
        {
            ContactsRepository.insertContact(contact);
            redirect(response,"/contacts");
            return;
        }

        var viewModel = new ContactViewModel(contact, errors);

		view(request,"templates/new.tpl")
			.render(response, viewModel);
    }
}
