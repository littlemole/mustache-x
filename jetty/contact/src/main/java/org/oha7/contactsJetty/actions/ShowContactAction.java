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

@Action("^/([0-9]*)$")
public class ShowContactAction implements BaseAction {
    
    public ShowContactAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);

        Contact contact = ContactsRepository.getContact(Long.valueOf(id));
        ContactErrors errors = new ContactErrors();

        var scopes = new ContactViewModel(contact, errors);

        render(response,"templates/show.tpl", scopes);
    }
}
