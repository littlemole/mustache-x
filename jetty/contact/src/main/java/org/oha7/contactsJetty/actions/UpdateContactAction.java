package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import org.oha7.contactsJetty.Action;
import org.oha7.contactsJetty.BaseAction;
import org.oha7.contactsJetty.model.Contact;
import org.oha7.contactsJetty.ContactsRepository;
import org.oha7.contactsJetty.model.ContactErrors;
import org.oha7.contactsJetty.viewModel.ContactViewModel;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.eclipse.jetty.http.HttpMethod;


@Action(value = "^/([0-9]*)/edit$", method=HttpMethod.POST )
public class UpdateContactAction implements BaseAction {

    public UpdateContactAction() {}
    
    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);

        Contact contact = Contact.fromRequest(request);
        contact.id = Long.valueOf(id);

        ContactErrors errors = Contact.validateContact(contact);

        if(!errors.hasErrors())
        {
            ContactsRepository.updateContact(contact);
            redirect(response,"/contacts");
            return;
        }

        var scopes = new ContactViewModel(contact, errors);

        render(response,"templates/edit.tpl", scopes);
    }
}
