#ifndef _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_REPO_DEFINE_
#define _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_REPO_DEFINE_

#include "reproweb/serialization/sql.h"
#include "entities.h"

using namespace prio;
using namespace repro;
using namespace reproweb;


class ContactRepository
{
public:

	ContactRepository(std::shared_ptr<repromysql::MysqlPool> my)
		: mysql(my)
	{}

	Future<std::vector<Contact>> all_contacts( )
	{
		repromysql::result_async::Ptr r = co_await mysql->query(
			"SELECT * FROM contacts ;"
		);

		std::vector<Contact> contacts;
		fromSQL(r,contacts);

		co_return contacts;
	}

	Future<std::vector<Contact>> search_contacts( const std::string& search )
	{
		std::string like = search + "%";
		repromysql::result_async::Ptr r = co_await mysql->query(
			"SELECT * FROM contacts WHERE first LIKE ? OR last LIKE ? ;",
			like, like
		);

		std::vector<Contact> contacts;
		fromSQL(r,contacts);

		co_return contacts;
	}

	Future<Contact> find_contact( const std::string& id )
	{
		repromysql::result_async::Ptr r = co_await mysql->query(
			"SELECT * FROM contacts WHERE id = ? ;",
			id
		);

		Contact contact;
		fromSQL(r,contact);

		co_return contact;
	}

	Future<Contact> find_contact_by_email( const std::string& email )
	{
		repromysql::result_async::Ptr r = co_await mysql->query(
			"SELECT * FROM contacts WHERE email = ? ;",
			email
		);

		Contact contact;
		fromSQL(r,contact);

		co_return contact;
	}

	Async insert( const Contact& contact )
	{
		co_await mysql->execute(
			"INSERT INTO contacts (email,first,last,phone) VALUES ( ?, ?, ?, ? ) ;",
			contact.email(), contact.first(), contact.last(), contact.phone()
		);

		co_return;
	}

	Async update( const Contact& contact )
	{
		co_await mysql->execute(
			"UPDATE contacts set email = ?, first = ?, last = ?, phone = ? WHERE id = ? ;",
			contact.email(), contact.first(), contact.last(), contact.phone(), contact.id()
		);

		co_return;
	}

	Async remove( const std::string& id )
	{
		co_await mysql->execute(
			"DELETE FROM contacts WHERE id = ? ;",
			id
		);

		co_return;
	}

	Future<long> count_contacts( )
	{
		repromysql::result_async::Ptr r = co_await mysql->query(
			"SELECT COUNT(*) FROM contacts ;"
		);

		if(r->fetch()) {
			long count = r->field(0).getLong();
			co_return count;
		}

		co_return 0;
	}

private:

	std::shared_ptr<repromysql::MysqlPool> mysql;
};

struct ContactPool : public repromysql::MysqlPool
{
	ContactPool(std::shared_ptr<Config> config) 
	  : MysqlPool(config->getString("mysql")) 
	{}
};

#endif
