package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;

import org.oha7.contactsJetty.Action;
import org.oha7.contactsJetty.BaseAction;
import org.oha7.contactsJetty.model.Contact;
import org.oha7.contactsJetty.ContactsRepository;
import org.oha7.contactsJetty.viewModel.ContactsViewModel;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Action("^/$")
@Action("^$")
public class ContactsAction implements BaseAction {
    
    public ContactsAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String search = request.getParameter("q");

        List<Contact> contacts = null;
        
        if(search == null || search.isBlank())
        {
            contacts = ContactsRepository.getContacts();
        }
        else
        {
            contacts = ContactsRepository.searchContacts(search);
        }

        var scopes = new ContactsViewModel(
            contacts,
            search
        );
        render(response,"templates/index.tpl", scopes);
    }
}
