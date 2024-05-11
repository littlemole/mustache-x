package org.oha7.contactsJetty.viewModel;

import org.oha7.contactsJetty.domain.Contact;
import org.oha7.contactsJetty.domain.ContactErrors;

public class ContactViewModel extends I18nViewModel{
 
    public Contact contact;
    public ContactErrors errors;

    public ContactViewModel( Contact contact, ContactErrors errors) {
        this.contact = contact;
        this.errors = errors;
    }
}
