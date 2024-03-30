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


@Action(value = "^/new$", method=HttpMethod.POST )
public class InsertContactAction implements BaseAction {
    
    public InsertContactAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        Contact contact = Contact.fromRequest(request);

        ContactErrors errors = Contact.validateContact(contact);

        if(!errors.hasErrors())
        {
            ContactsRepository.insertContact(contact);
            redirect(response,"/contacts");
            return;
        }

        var scopes = new ContactViewModel(contact, errors);

        render(response,"templates/new.tpl", scopes);
    }
}
