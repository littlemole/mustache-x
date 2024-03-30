package org.oha7.contacts;

import java.util.List;

public class ContactsViewModel {

    public List<Contact> contacts;
    public String q;
    public long count;

    public ContactsViewModel(List<Contact> contacts, String q, long count ) 
    {
        this.contacts = contacts;
        this.q = q == null ? "" : q;
        this.count = count;
    }
}
