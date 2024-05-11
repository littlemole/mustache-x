package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;
import org.oha7.contactsJetty.viewModel.ContactsViewModel;


@Action("^/$")
@Action("^$")
public class ContactsAction implements Actionable {

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

        var viewModel = new ContactsViewModel(
            contacts,
            search
       );

	   view(request,"templates/index.tpl")
	   		.render(response, viewModel);
    }
}
