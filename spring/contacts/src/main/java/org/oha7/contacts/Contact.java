package org.oha7.contacts;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

@Table(name = "contacts")
public class Contact {

    @Id
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

}
