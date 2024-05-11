package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactErrors;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;
import org.oha7.contactsJetty.viewModel.ContactViewModel;


@Action("^/new$")
public class CreateContactAction implements Actionable {
    
    public CreateContactAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        Contact contact = new Contact();
        ContactErrors errors = new ContactErrors();

        var viewModel = new ContactViewModel(contact, errors);
		
		view(request,"templates/new.tpl")
			.render(response,viewModel);
    }
}
