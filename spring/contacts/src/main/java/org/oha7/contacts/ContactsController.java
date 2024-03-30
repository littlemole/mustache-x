package org.oha7.contacts;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.HashMap;
import java.util.List;

@Controller
public class ContactsController {

    private ContactsRepository repository;

    ContactsController(ContactsRepository repo) {
        this.repository = repo;
    }

    @GetMapping("/contacts")
    public ModelAndView contacts(@RequestParam(required = false) String q) {

        List<Contact> contacts = null;
        
        if(q == null)
        {
            contacts = repository.findAll();
        }
        else
        {
            contacts = repository.search(q + "%");
        }

        var model = new ContactsViewModel (contacts,q,contacts.size());

        return new ModelAndView("index","view",model);
    }

    @GetMapping("/contacts/{id}")
    public ModelAndView show(@PathVariable(value="id") Long id) {

        var contact =repository.findById(id).get();

        var errors = new ContactErrors();
        var model = new ContactViewModel(contact,errors);

        return new ModelAndView("show","view",model);
    }

    @GetMapping("/contacts/new")
    public ModelAndView create() {

        var contact = new Contact();

        var errors = new ContactErrors();
        var model = new ContactViewModel(contact,errors);

        return new ModelAndView("new","view",model);
    }

    @PostMapping("/contacts/new")
    public ModelAndView insert(Contact contact) {

        var errors = validateContact(contact);

        if(errors.hasErrors())
        {
            var model = new ContactViewModel(contact,errors);

            return new ModelAndView("new","view",model);    
        }

        repository.save(contact);

        return new ModelAndView("redirect:/contacts");       
    }

    @GetMapping("/contacts/{id}/edit")
    public ModelAndView edit(@PathVariable(value="id") Long id) {

        var contact =repository.findById(id).get();

        var errors = new ContactErrors();
        var model = new ContactViewModel(contact,errors);

        return new ModelAndView("edit","view",model);
    }

    @PostMapping("/contacts/{id}/edit")
    public ModelAndView update(Contact contact) {

        var errors = validateContact(contact);

        if(errors.hasErrors())
        {
            var model = new ContactViewModel(contact,errors);

            return new ModelAndView("edit","view",model);    
        }

        repository.save(contact);

        return new ModelAndView("redirect:/contacts");       
    }

    @DeleteMapping("/contacts/{id}")
    @ResponseBody
    public Object update( HttpServletResponse response, @PathVariable(value="id") Long id, @RequestHeader(value = "HX-Trigger",required = false) String hxTrigger) {

        repository.deleteById(id);

        if("delete-btn".equals(hxTrigger))
        {
            var view = new RedirectView("/contacts");
            view.setHttp10Compatible(false);
            return view;
        }

        response.setHeader("HX-Trigger", "recountEvent");

        return "";
    }

    @GetMapping("/contacts/{id}/email")
    @ResponseBody
    public String email(@PathVariable(value="id") Long id, @RequestParam(value="email") String email) {

        var contact = repository.findByEmail(email);

        if(contact != null)
        {
            if(contact.id != id)
            {
                return "Email already taken!";
            }
        }
        return "";
    }

    @GetMapping("/contacts/count")
    @ResponseBody
    public String count() {

        var count = repository.count();

        return String.valueOf(count);
    }

    private ContactErrors validateContact(Contact contact) {

        var errors = new ContactErrors();

        if(contact.email.isBlank())
        {
            errors.email = "Email must not be empty.";
        }
        if(contact.last.isBlank())
        {
            errors.last = "Last Name must not be empty.";
        }

        var existing = repository.findByEmail(contact.email);
        if(existing != null && existing.id != contact.id)
        {
            errors.email = "Email must be unique.";
        }
        return errors;
    }
}
