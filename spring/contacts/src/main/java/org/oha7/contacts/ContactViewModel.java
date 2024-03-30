package org.oha7.contacts;


public class ContactViewModel {

    public Contact contact;
    public ContactErrors errors;

    public ContactViewModel(Contact contact, ContactErrors errors) 
    {
        this.contact = contact;
        this.errors = errors;
    }
}
