package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import org.oha7.contactsJetty.Action;
import org.oha7.contactsJetty.BaseAction;
import org.oha7.contactsJetty.ContactsRepository;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.eclipse.jetty.http.HttpMethod;


@Action(value = "^/([0-9]*)$", method=HttpMethod.DELETE )
public class DeleteContactAction implements BaseAction {
    
    public DeleteContactAction() {}
        
    public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String id = matcher.group(1);

        ContactsRepository.deleteContact(Long.valueOf(id));

        String hxTrigger = request.getHeader("HX-Trigger");

        if("delete-btn".equals(hxTrigger))
        {
            redirect(response,"/contacts/");
            return;
        }

        response.setHeader("HX-Trigger", "recountEvent");

        render(response,"");
    }
}
