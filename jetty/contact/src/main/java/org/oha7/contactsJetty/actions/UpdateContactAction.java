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


@Action(value = "^/([0-9]*)/edit$", method=HttpMethod.POST )
public class UpdateContactAction implements Actionable {

    public UpdateContactAction() {}
    
    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);
		Locale locale = getLocale(request);

        Contact contact = Contact.fromRequest(request);
        contact.id = Integer.valueOf(id);

        ContactErrors errors = Contact.validateContact(locale,contact);

        if(!errors.hasErrors())
        {
            ContactsRepository.updateContact(contact);
            redirect(response,"/contacts");
            return;
        }

        var viewModel = new ContactViewModel(contact, errors);

		view(request,"templates/edit.tpl")
			.render(response, viewModel);
    }
}
