package org.oha7.contactsJetty;

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import org.eclipse.jetty.http.HttpMethod;

public class ActionEntry {
    
    public BaseAction action;
    public HttpMethod method;
    public Pattern pattern;

    public static List<ActionEntry> fromClasspath(String packageName) {

        List<ActionEntry> actions = new ArrayList<ActionEntry>();

        try {

            var classNames = Scanner.getClassNamesFromPackage(packageName);

            for(String className : classNames)
            {
                var clazz = Class.forName(className);

                Action[] annotations = (Action[])clazz.getAnnotationsByType(Action.class);

                if(annotations == null || annotations.length == 0) continue;

                for(Action annotation : annotations)
                {
                    String value = annotation.value();
                    HttpMethod method = annotation.method();
    
                    var actionEntry = new ActionEntry();

                    actionEntry.action = (BaseAction)clazz.getDeclaredConstructor().newInstance();
                    actionEntry.method = method;
                    actionEntry.pattern = Pattern.compile(value);
    
                    actions.add(actionEntry);
                }
            }
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
        }        
        return actions;
    }

}
