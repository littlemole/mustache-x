package org.oha7.contactsJetty.domain;

import java.util.List;
import java.sql.SQLException;

import org.oha7.contactsJetty.infra.Query;


public class ContactsRepository {

    public static List<Contact> getContacts()
    {
		try(Query query = new Query()) {
			return query
				.prepare("select * from contacts")
				.queryAll(Contact.class);
		}
		catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
    }

    public static List<Contact> searchContacts(String txt)
    {
		try(Query query = new Query()) {
			return query
				.prepare("select * from contacts where first like ? or last like ? ")
				.param(txt+"%")
				.param(txt+"%")
				.queryAll(Contact.class);
		}
		catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
    }

    public static Contact getContact(long id)
    {
		try(Query query = new Query()) {
			return query
				.prepare("select * from contacts where id = ? ")
				.param(id)
				.queryOne(Contact.class);
		}
		catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
    }

    public static Contact getContactByEmail(String email)
    {
		try(Query query = new Query()) {
			return query
				.prepare("select * from contacts where email = ? ")
				.param(email)
				.queryOne(Contact.class);
		}
		catch (SQLException e) {
			e.printStackTrace();
			return null;
		}
    }

    public static void insertContact(Contact contact)
    {
		try(Query query = new Query()) {
			query
				.prepare("insert into contacts (email,first,last,phone) values (?,?,?,?) ")
				.param(contact.email)
				.param(contact.first)
				.param(contact.last)
				.param(contact.phone)
				.ecexute();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public static void updateContact(Contact contact)
    {
		try(Query query = new Query()) {
			query
				.prepare("update contacts set email = ?,first = ?, last = ?, phone = ? where id = ? ")
				.param(contact.email)
				.param(contact.first)
				.param(contact.last)
				.param(contact.phone)
				.param(contact.id)
				.ecexute();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public static void deleteContact(long id)
    {
		try(Query query = new Query()) {
			query
				.prepare("delete from contacts where id = ? ")
				.param(id)
				.ecexute();
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
    }

    public static long countContacts()
    {
		try(Query query = new Query()) {
			return query
				.prepare("select count(*) from contacts")
				.query(Long.class);
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
    }
}
