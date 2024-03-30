import json
import mysql.connector

from random import random

# ========================================================
# Contact Model
# ========================================================
PAGE_SIZE = 100

class ContactRepo:
    def __init__(self):

        self.db = mysql.connector.connect(
            host="mariadb",
            user="contacts",
            password="contact",
            database="contacts"
        )

    def close(self):
        self.db.close()

    def count(self):

        cursor = self.db.cursor()

        cursor.execute("SELECT COUNT(id) FROM contacts")

        result = cursor.fetchone()

        return result[0]
    
    def insert(self,contact):

        cursor = self.db.cursor()

        try:
            cursor.execute("INSERT into contacts (email,first,last,phone) VALUES (%s,%s,%s,%s)",
                (contact.email,contact.first,contact.last,contact.phone) 
            )

            self.db.commit()
        except:
            return 0

        return cursor.rowcount 

    def update(self,contact):

        cursor = self.db.cursor()

        try:
            cursor.execute("UPDATE contacts set email=%s,first=%s,last=%s,phone=%s WHERE id = %s",
                (contact.email,contact.first,contact.last,contact.phone, contact.id) 
            )
            self.db.commit()
        except:
            return 0


        return cursor.rowcount 

    def delete(self,id):

        cursor = self.db.cursor()

        try:
            cursor.execute("DELETE FROM contacts WHERE id = %s",
                (id,) 
            )
            self.db.commit()
        except:
            return 0
    
        return cursor.rowcount 
    
    def fetch(self,id):
        cursor = self.db.cursor()

        cursor.execute("SELECT id,email,first,last,phone FROM contacts WHERE id = %s", (id,))

        try:
            result = cursor.fetchone()
        except:
            return None

        if result is None: 
            return None

        return Contact(id_=result[0],email=result[1],first=result[2],last=result[3],phone=result[4])

    def fetch_by_email(self,email):
        cursor = self.db.cursor()

        print(email)
        cursor.execute("SELECT id,email,first,last,phone FROM contacts WHERE email LIKE %s ", (email,))

        try:
            result = cursor.fetchone()
        except:
            return None
        
        if result is None: 
            return None

        return Contact(id_=result[0],email=result[1],first=result[2],last=result[3],phone=result[4])

    def fetch_all(self,limit,offset):
        cursor = self.db.cursor()

        cursor.execute("SELECT id,email,first,last,phone FROM contacts LIMIT %s OFFSET %s", (limit,offset))

        result = cursor.fetchall()

        all = []
        for row in result:            
            all.append(Contact(id_=row[0],email=row[1],first=row[2],last=row[3],phone=row[4]))

        return all

    def search(self,text,limit,offset):
        cursor = self.db.cursor()

        cursor.execute("SELECT id,email,first,last,phone FROM contacts WHERE first like %s OR last like %s LIMIT %s OFFSET %s", (text+"%",text+"%",limit,offset))

        result = cursor.fetchall()

        all = []
        for row in result:

            all.append(Contact(id_=row[0],email=row[1],first=row[2],last=row[3],phone=row[4]))

        return all

# active record
class Contact:

    def __init__(self, id_=None, first=None, last=None, phone=None, email=None):
        self.id = id_
        self.first = first
        self.last = last
        self.phone = phone
        self.email = email
        self.errors = {}

    def __str__(self):
        return json.dumps(self.__dict__, ensure_ascii=False)
    
    def toJson(self):
        return self.__dict__

    def update(self, first, last, phone, email):
        self.first = first
        self.last = last
        self.phone = phone
        self.email = email

    def validate(self,db):
        if not self.email:
            self.errors['email'] = "Email Required"
        existing_contact = db.fetch_by_email(self.email)
        if existing_contact and existing_contact.id != self.id:
            self.errors['email'] = "Email Must Be Unique"
        if not self.last:
            self.errors['last'] = "Lastname is Required"
        return len(self.errors) == 0

    def save(self):
        db = ContactRepo()
        if not self.validate(db):
            db.close()
            return False
        
        r = 0
        if self.id is None:
            r = db.insert(self)
        else:
            r = db.update(self)

        db.close()
        if r != 1 :
            return False            
        return True

    def delete(self):

        db = ContactRepo()
        db.delete(self.id)
        db.close()

    @classmethod
    def count(cls):

        db = ContactRepo()
        c = db.count()
        db.close()
        return c


    @classmethod
    def all(cls, page=1):

        db = ContactRepo()
        r = db.fetch_all(PAGE_SIZE,(page-1)*PAGE_SIZE)
        db.close()
        return r

    @classmethod
    def search(cls, text):

        db = ContactRepo()
        r = db.search(text,PAGE_SIZE,0)
        db.close()
        return r

    @classmethod
    def find(cls, id_):
        id_ = int(id_)

        db = ContactRepo()
        r = db.fetch(id_)
        db.close()
        return r
