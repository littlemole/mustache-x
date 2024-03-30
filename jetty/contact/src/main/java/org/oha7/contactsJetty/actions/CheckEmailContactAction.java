package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.regex.Matcher;

import org.oha7.contactsJetty.Action;
import org.oha7.contactsJetty.BaseAction;
import org.oha7.contactsJetty.model.Contact;
import org.oha7.contactsJetty.ContactsRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Action(value = "^/([^/]*)/email$")
public class CheckEmailContactAction implements BaseAction {
    
    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);
        String email = request.getParameter("email");

        Contact contact = ContactsRepository.getContactByEmail(email);

        PrintWriter writer = response.getWriter();

        if(contact != null && contact.id != Long.valueOf(id))
        {
            writer.println( "Email already taken!" );     
        }
        writer.flush();
    }
}
