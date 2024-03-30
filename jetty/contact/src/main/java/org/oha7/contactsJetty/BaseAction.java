package org.oha7.contactsJetty;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Writer;
import java.util.regex.Matcher;

import com.github.mustachejava.DefaultMustacheFactory;
import com.github.mustachejava.Mustache;
import com.github.mustachejava.MustacheFactory;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public interface BaseAction {
    
      public void execute(Matcher matcher, HttpServletRequest request, HttpServletResponse response) throws IOException;

      default public void render(HttpServletResponse response, String template, Object scopes) throws IOException {

            response.setContentType("text/html;");

            Writer writer = new OutputStreamWriter(response.getOutputStream());
            MustacheFactory mf = new DefaultMustacheFactory();
            Mustache mustache = mf.compile(template);
            mustache.execute(writer, scopes);
            writer.flush();            
      }

      default public void render(HttpServletResponse response, String txt) throws IOException {

            response.setContentType("text/html;");

            PrintWriter writer = response.getWriter();
            writer.println( txt); 
            writer.flush();            
      }

      default public void redirect(HttpServletResponse response, String location) {
            
            response.setStatus(303);
            response.setHeader("Location", location);
      }

}
