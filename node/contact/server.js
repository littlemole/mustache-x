
const express = require('express')
const mariadb = require('mariadb');
const Mustache = require('mustache');

const fs = require('node:fs/promises');

const Contacts = require('./Contacts.js');


const app = express()
const port = 3000

app.use(express.static('static'));
app.use(express.urlencoded({ extended: true })) ;

let render = async function(res, tpl, scopes) {

    let tmpl = await fs.readFile('templates/' + tpl + ".tpl", { encoding: 'utf8' });

    var output = Mustache.render(tmpl, scopes );  
    res.send(output);
}

app.get('/contacts', async function(req, res) {

    let search = req.query.q;
    let contacts;

    if(search && search != "") {
        contacts = await Contacts.search(search);
    } else {
        contacts = await Contacts.all_contacts();
    }

    render(res,"index", { "contacts" : contacts });
})

app.get('/contacts/count', async function(req, res) {

    let count = await Contacts.count();
    res.send(""+count);
})

app.get('/contacts/new', async function(req, res) {

    render(res,"new", { "contact" : {}, errors : {} });
})

app.post('/contacts/new', async function(req, res) {

    let errors = {};
    let valid = true;

    if(req.body.email == "") {
        valid = false;
        errors.email = "Email must not be empty.";
    }
    if(req.body.last == "") {
        valid = false;
        errors.last = "Last name must not be empty.";
    }

    let existing = await Contacts.find_by_email(req.body.email);
    if(existing) {
      valid = false;
      errors.email = "Email must be unique.";
    }

    if(valid) {
        await Contacts.insert(req.body);
        res.redirect(303, '/contacts');  
    } else {
        render(res,"new", { "contact" : req.body, errors : errors });
    }
})

app.get('/contacts/:id/edit', async function(req, res) {

    let id = req.params.id;
    let contact = await Contacts.find(id);

    render(res,"edit", { "contact" : contact, errors : {} });
})

app.post('/contacts/:id/edit', async function(req, res) {

    let id = req.params.id;

    let errors = {};
    let valid = true;

    if(req.body.email == "") {
        valid = false;
        errors.email = "Email must not be empty.";
    }
    if(req.body.last == "") {
        valid = false;
        errors.last = "Last name must not be empty.";
    }

    let existing = await Contacts.find_by_email(req.body.email);
    if(existing && (existing.id != id) ) {
      valid = false;
      errors.email = "Email already taken.";
    }

    if(valid) {
        await Contacts.update(id,req.body);
        res.redirect(303, '/contacts');  
    } else {
        render(res,"edit", { "contact" : req.body, errors : errors });
    }
})

app.get('/contacts/:id/email', async function(req, res) {
  
    let id = req.params.id;
    let email = req.query.email;

    let contact = await Contacts.find_by_email(email);

    if(contact && contact.id != id ) 
        res.send("Email already taken!");
    else
        res.send("");
})

app.delete('/contacts/:id', async function(req, res) {

    let id = req.params.id;
    await Contacts.remove(id);

    let trigger = req.get('HX-Trigger');

    if(trigger && trigger == 'delete-btn') {
        res.redirect(303, '/contacts');  
    }
    else {
        res.set('HX-Trigger', 'recountEvent')
        res.send("");
    }
})

app.get('/contacts/:id', async function(req, res) {

    let id = req.params.id;
    let contact = await Contacts.find(id);

    render(res,"show", { "contact" : contact, errors : {} });
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})

