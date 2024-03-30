package org.oha7.contactsJetty.viewModel;

import java.util.List;

import org.oha7.contactsJetty.model.Contact;

public class ContactsViewModel {
 
    public List<Contact> contacts;
    public String q;

    public ContactsViewModel(List<Contact> contacts, String q) {
        this.contacts = contacts;
        this.q = q == null ? "" : q;
    }
}
