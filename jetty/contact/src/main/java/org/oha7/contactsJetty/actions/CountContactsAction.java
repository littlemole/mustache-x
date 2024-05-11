package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;


@Action(value = "^/count$")
public class CountContactsAction implements Actionable {
    
    public CountContactsAction() {}

    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        long count = ContactsRepository.countContacts();

        render(response,String.valueOf(count) );
    }
}

