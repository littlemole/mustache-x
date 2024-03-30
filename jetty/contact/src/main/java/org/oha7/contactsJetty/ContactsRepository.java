package org.oha7.contactsJetty;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.oha7.contactsJetty.model.Contact;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class ContactsRepository {

//    private static String jdbcurl = "jdbc:mariadb://mariadb/contacts?user=contacts&password=contact&useUnicode=true&amp;characterEncoding=UTF-8";

    private static String jdbcurl = System.getProperty("JDBC_URL");

    public static List<Contact> getContacts()
    {
        Connection conn = null;
        Statement stmt = null;
        ResultSet resultSet = null;

        List<Contact> contacts = new ArrayList<Contact>();

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.createStatement();

            resultSet = stmt.executeQuery("select * from contacts");

            contacts = getAllContacts(resultSet);
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }

        return contacts;
    }

    public static List<Contact> searchContacts(String txt)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        List<Contact> contacts = new ArrayList<Contact>();

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("select * from contacts where first like ? or last like ? ");
            stmt.setString(1, txt + "%");
            stmt.setString(2, txt + "%");

            resultSet = stmt.executeQuery();

            contacts = getAllContacts(resultSet);
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }

        return contacts;
    }

    public static Contact getContact(long id)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        Contact contact = null;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("select * from contacts where id = ? ");
            stmt.setLong(1, id);

            resultSet = stmt.executeQuery();

            contact = getSingleContact(resultSet);
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }

        return contact;
    }

    public static Contact getContactByEmail(String email)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        Contact contact = null;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("select * from contacts where email = ? ");
            stmt.setString(1, email);

            resultSet = stmt.executeQuery();

            contact = getSingleContact(resultSet);
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }

        return contact;
    }


    public static void insertContact(Contact contact)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("insert into contacts (email,first,last,phone) values (?,?,?,?) ");
            stmt.setString(1,contact.email);
            stmt.setString(2,contact.first);
            stmt.setString(3,contact.last);
            stmt.setString(4,contact.phone);

            stmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }
    }

    public static void updateContact(Contact contact)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("update contacts set email = ?,first = ?, last = ?, phone = ? where id = ? ");
            stmt.setString(1,contact.email);
            stmt.setString(2,contact.first);
            stmt.setString(3,contact.last);
            stmt.setString(4,contact.phone);
            stmt.setLong(5,contact.id);

            stmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }
    }

    public static void deleteContact(long id)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet resultSet = null;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.prepareStatement("delete from contacts where id = ? ");
            stmt.setLong(1,id);
            stmt.executeUpdate();
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }
    }


    public static long countContacts()
    {
        Connection conn = null;
        Statement stmt = null;
        ResultSet resultSet = null;

        long count = 0;

        try {
            conn = DriverManager.getConnection(jdbcurl);

            stmt = conn.createStatement();

            resultSet = stmt.executeQuery("select count(*) from contacts");


            if(resultSet.next())
            {
                count = resultSet.getLong(1);
            }
        }
        catch (Exception e) {
            System.out.println(e.getMessage());
        } finally {
            close(resultSet,stmt,conn);
        }

        return count;
    }

    private static List<Contact> getAllContacts(ResultSet resultSet) throws SQLException {

        List<Contact> contacts = new ArrayList<Contact>();

        while (resultSet.next()) {
            Contact contact = mapContact(resultSet);
            contacts.add(contact);
        }
        return contacts;
    }

    private static Contact getSingleContact(ResultSet resultSet)  throws SQLException {

        if (resultSet.next()) {
            return mapContact(resultSet);
        }
        return null;
    }

    private static Contact mapContact(ResultSet resultSet)  throws SQLException {

        Contact contact = new Contact();
        contact.id = resultSet.getLong("id");
        contact.email = resultSet.getString("email");
        contact.first = resultSet.getString("first");
        contact.last = resultSet.getString("last");
        contact.phone = resultSet.getString("phone");
        return contact;
    }

    private static void close(ResultSet resultSet, Statement stmt, Connection conn) {

        try {
            if (resultSet != null) {
                resultSet.close();
            }

            if (stmt != null) {
                stmt.close();
            }

            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
