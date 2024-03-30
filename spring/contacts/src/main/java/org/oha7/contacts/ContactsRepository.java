package org.oha7.contacts;

import java.util.List;

import org.springframework.data.jdbc.repository.query.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository 
public interface ContactsRepository extends CrudRepository<Contact, Long> {

    @Override
    List<Contact> findAll();

    @Query("SELECT * FROM contacts WHERE last LIKE :txt OR first LIKE :txt")
    List<Contact> search(String txt);

    @Query("SELECT * FROM contacts WHERE email = :email")
    Contact findByEmail(String email);

}

