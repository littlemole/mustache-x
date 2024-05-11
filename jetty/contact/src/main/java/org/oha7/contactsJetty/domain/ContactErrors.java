package org.oha7.contactsJetty.domain;

public class ContactErrors {

    public String email;
    public String first;
    public String last;
    public String phone;

    public ContactErrors()
    {
        this.email = "";
        this.first = "";
        this.last = "";
        this.phone = "";
    }

    public boolean hasErrors()
    {
        return !email.isBlank() || 
            !first.isBlank() ||
            !last.isBlank() ||
            !phone.isBlank();
    }
}
