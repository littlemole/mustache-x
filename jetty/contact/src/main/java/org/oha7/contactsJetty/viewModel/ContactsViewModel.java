package org.oha7.contactsJetty.viewModel;

import java.util.List;

import org.oha7.contactsJetty.domain.Contact;

public class ContactsViewModel extends I18nViewModel {
 
    public List<Contact> contacts;
    public String q;

	public ContactsViewModel(List<Contact> contacts, String q) {
        this.contacts = contacts;
        this.q = q == null ? "" : q;
    }
}
