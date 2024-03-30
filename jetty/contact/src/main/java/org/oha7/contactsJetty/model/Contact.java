package org.oha7.contactsJetty.model;

import org.oha7.contactsJetty.ContactsRepository;

import jakarta.servlet.http.HttpServletRequest;

public class Contact {

    public Long id;
    public String email;
    public String first;
    public String last;
    public String phone;

    public Contact()
    {
        this.email = "";
        this.first = "";
        this.last = "";
        this.phone = "";
    }

    public String getId()
    {
        return id == null ? "" : String.valueOf(id);
    }

    public void setId(Long id) 
    {
        this.id = id;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }

    public void setFirst(String first) {
        this.first = first;
    }

    public void setLast(String last) {
        this.last = last;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public static ContactErrors validateContact(Contact contact)
    {
        var errors = new ContactErrors();

        if(contact.email.isBlank())
        {
            errors.email = "Email must not be empty.";
        }
        if(contact.last.isBlank())
        {
            errors.last = "Last Name must not be empty.";
        }

        var existing = ContactsRepository.getContactByEmail(contact.email);
        if(existing != null && existing.id != contact.id)
        {
            errors.email = "Email must be unique.";
        }
        
        return errors;
    }

    public static Contact fromRequest(HttpServletRequest request)
    {
        Contact contact = new Contact();
        contact.email = request.getParameter("email");
        contact.first = request.getParameter("first_name");
        contact.last = request.getParameter("last_name");
        contact.phone = request.getParameter("phone");    
        return contact;    
    }
}
