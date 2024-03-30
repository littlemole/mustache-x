
const mariadb = require('mariadb');

var Contacts = function() {

    const pool = mariadb.createPool({
        host: 'mariadb', 
        database : 'contacts',
        user:'contacts', 
        password: 'contact',
        connectionLimit: 5
    });

    let api = {};

    api.all_contacts = async function () {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query("SELECT * from contacts");
            return rows;
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    api.search = async function (search) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "SELECT * FROM contacts WHERE first LIKE ? OR last LIKE ? ",
                [ search + "%", search + "%" ]
            );
            return rows;
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    api.find = async function (id) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "SELECT * FROM contacts WHERE id = ? ",
                [ id ]
            );
            return rows[0];
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    api.find_by_email = async function (email) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "SELECT * FROM contacts WHERE email = ? ",
                [ email ]
            );
            if(rows.length == 0) return null;
            return rows[0];
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    api.count = async function () {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "SELECT COUNT(*) AS count FROM contacts "
            );
            return rows[0].count;
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };
  
    api.insert = async function (contact) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "INSERT INTO contacts (email,first,last,phone) VALUES ( ?, ?, ?, ? ) ",
                [ contact.email, contact.first, contact.last, contact.phone ]
            );
        } catch (err) {
            throw err;
        } finally {
        if (conn) {
            await conn.end();
        }
        }
    };

    api.update = async function (id,contact) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "UPDATE contacts set email = ?, first = ?, last = ?, phone = ? WHERE id = ? ",
                [ contact.email, contact.first, contact.last, contact.phone, id ]
            );
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    api.remove = async function (id) {
        let conn;
        try {
            conn = await pool.getConnection();
            const rows = await conn.query(
                "DELETE FROM contacts WHERE id = ? ",
                [ id ]
            );
        } catch (err) {
            throw err;
        } finally {
            if (conn) {
                await conn.end();
            }
        }
    };

    return api;
}();

module.exports = Contacts;