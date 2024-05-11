package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactErrors;
import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;
import org.oha7.contactsJetty.viewModel.ContactViewModel;


@Action("^/([0-9]*)/edit$")
public class EditContactAction implements Actionable {
    
    public EditContactAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);

        Contact contact = ContactsRepository.getContact(Long.valueOf(id));
        ContactErrors errors = new ContactErrors();

        var viewModel = new ContactViewModel(contact, errors);

		view(request,"templates/edit.tpl")
			.render(response, viewModel);
    }
}
