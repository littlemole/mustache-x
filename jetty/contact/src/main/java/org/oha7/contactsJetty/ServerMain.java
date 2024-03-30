package org.oha7.contactsJetty;

import java.net.URI;
import java.net.URL;

import org.eclipse.jetty.ee10.servlet.DefaultServlet;
import org.eclipse.jetty.ee10.servlet.ServletContextHandler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.util.resource.Resource;
import org.eclipse.jetty.util.resource.URLResourceFactory;

public class ServerMain
{
    public static void main(String[] args) throws Throwable
    {
        try
        {
            new ServerMain().run();
        }
        catch (Throwable t)
        {
            t.printStackTrace();
        }
    }

    public void run() throws Exception
    {
        Server server = new Server(8000);

        URL webRootLocation = this.getClass().getResource("/webapp/index.html");
        if (webRootLocation == null)
        {
            throw new IllegalStateException("Unable to determine webroot URL location");
        }

        URI webRootUri = URI.create(webRootLocation.toURI().toASCIIString().replaceFirst("/index.html$", "/"));
        Resource resource = new URLResourceFactory().newResource(webRootUri);


        ServletContextHandler contextHandler = new ServletContextHandler();
        contextHandler.setContextPath("/");
        contextHandler.setBaseResource(resource);
        contextHandler.setWelcomeFiles(new String[]{"index.html"});

        contextHandler.getMimeTypes().addMimeMapping("txt", "text/plain;charset=utf-8");

        contextHandler.addServlet(ContactsServlet.class, "/contacts/*");
        contextHandler.addServlet(ContactsServlet.class, "/contacts");
        contextHandler.addServlet(DefaultServlet.class, "/");

        server.setHandler(contextHandler);

        server.start();
        server.join();
    }
}