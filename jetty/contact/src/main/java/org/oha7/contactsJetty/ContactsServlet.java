package org.oha7.contactsJetty;

import java.io.IOException;
import java.util.List;
import java.util.regex.Matcher;
import org.eclipse.jetty.http.HttpMethod;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class ContactsServlet extends HttpServlet {

    private static List<ActionEntry> actions = ActionEntry.fromClasspath("org.oha7.contactsJetty.actions");

    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

        dispatch(HttpMethod.GET,request,response);
    }

    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {

        dispatch(HttpMethod.POST,request,response);
    }

    @Override
    public void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {

        dispatch(HttpMethod.DELETE,request,response);
    }

    private void dispatch(HttpMethod requestMethod, HttpServletRequest request, HttpServletResponse response) throws IOException {

        String pathInfo =  request.getPathInfo() == null ? "" : request.getPathInfo() ;

        for(ActionEntry actionEntry : actions)
        {
            if(!requestMethod.equals(actionEntry.method)) continue;

            Matcher matcher = actionEntry.pattern.matcher(pathInfo);

            if(matcher.find())
            {
                actionEntry.action.execute(matcher,request,response);
                break;
            }      
        }
    }
}
