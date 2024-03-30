from flask import (
    Flask, redirect, render_template, make_response,request,flash, jsonify, send_file, get_flashed_messages
)

from contacts_model import Contact
from templates import Templates

import chevron

# ========================================================
# Views
# ========================================================

templates = Templates("templates")    

# ========================================================
# Flask App
# ========================================================

app = Flask(__name__)


@app.route("/")
def index():

    return redirect("/contacts")


@app.route("/contacts")
def contacts():

    search = request.args.get("q")
    page = int(request.args.get("page", 1))

    if search is not None:
        contacts_set = Contact.search(search)
    else:
        contacts_set = Contact.all()

    viewdata = { "contacts" : contacts_set, 
                 "q" : search, 
                 "count" : Contact.count(), 
                 "flashed_messages" : get_flashed_messages() 
                }

    return chevron.render(templates["index.tpl"], viewdata)


@app.route("/contacts/count", methods=["GET"])
def contacts_count():

    c = Contact.count()

    return str(c)



@app.route("/contacts/new", methods=['GET'])
def contacts_new_get():

    viewdata = {}
    return chevron.render(templates["new.tpl"], viewdata)


@app.route("/contacts/new", methods=['POST'])
def contacts_new():

    c = Contact(None, 
                request.form['first_name'], 
                request.form['last_name'], 
                request.form['phone'],
                request.form['email'])
    
    if c.save():
        return redirect("/contacts")    
    else:
        return chevron.render(templates["new.tpl"], c.toJson())


@app.route("/contacts/<contact_id>")
def contacts_view(contact_id=0):

    contact = Contact.find(contact_id)
    return chevron.render(templates["show.tpl"], contact.toJson())    


@app.route("/contacts/<contact_id>/edit", methods=["GET"])
def contacts_edit_get(contact_id=0):

    contact = Contact.find(contact_id)
    return chevron.render(templates["edit.tpl"], contact.toJson())    


@app.route("/contacts/<contact_id>/edit", methods=["POST"])
def contacts_edit_post(contact_id=0):

    c = Contact.find(contact_id)
    
    c.update(request.form['first_name'], 
             request.form['last_name'], 
             request.form['phone'], 
             request.form['email'])

    if c.save():
        return redirect("/contacts/" + str(contact_id))
    else:
        return chevron.render(templates["edit.tpl"], c.toJson())    

@app.route("/contacts/<contact_id>/email", methods=["GET"])
def contacts_email_get(contact_id=0):

    c = Contact.find(contact_id)

    c.email = request.args.get('email')
    c.validate()

    return c.errors.get('email') or ""


@app.route("/contacts/<contact_id>", methods=["DELETE"])
def contacts_delete(contact_id=0):

    contact = Contact.find(contact_id)
    contact.delete()

    if request.headers.get('HX-Trigger') == 'delete-btn':
        return redirect("/contacts", 303)

    resp = make_response("")
    resp.headers['HX-Trigger'] = 'recountEvent'
    return resp



if __name__ == "__main__":
    app.run( host='0.0.0.0')
