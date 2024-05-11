package org.oha7.contactsJetty.actions;

import java.io.IOException;
import java.util.regex.Matcher;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.eclipse.jetty.http.HttpMethod;
import org.oha7.contactsJetty.domain.ContactsRepository;
import org.oha7.contactsJetty.infra.Action;
import org.oha7.contactsJetty.infra.Actionable;


@Action(value = "^/([0-9]*)$", method=HttpMethod.DELETE )
public class DeleteContactAction implements Actionable {
    
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
