#ifndef _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_CONTROLLER_DEFINE_
#define _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_CONTROLLER_DEFINE_

#include <reproweb/serialization/parameter.h>
#include "reproweb/serialization/web.h"

#include "view.h"
#include "repo.h"

using namespace reproweb;

class Controller
{
public:

	Controller( std::shared_ptr<ContactRepository> repo, std::shared_ptr<View> view)
		: repository(repo), view_(view)
	{}

	Async index( Request& req, Response& res)
	{		
		std::vector<Contact> contacts;

		QueryParams query = req.path.queryParams();
		std::string search = query.get("q");
		
		if(search != "")
		{
			contacts = co_await repository->search_contacts(search);
		}
		else
		{
			contacts = co_await repository->all_contacts();
		}

		view_->render_index(req,res,contacts,search);

		co_return;
	}

	Async count( Request& req, Response& res)
	{		
		long count = co_await repository->count_contacts();

		view_->render_count(req,res,count);

		co_return;
	}

	Async show( Request& req, Response& res)
	{		
		std::string id = req.path.args().get("id");

		Contact contact = co_await repository->find_contact(id);

		view_->render_show(req,res,contact);

		co_return;
	}

	Async email( Request& req, Response& res)
	{		
		std::string id = req.path.args().get("id");

		QueryParams query = req.path.queryParams();
		std::string email = query.get("email");

		Contact contact = co_await repository->find_contact_by_email(email);

		if(contact.id() != "" && contact.id() != id) 
		{
			res.ok().body("Email is already taken!").flush();
		}
		else
		{
			res.ok().flush();
		}

		co_return;
	}

	Async create( Request& req, Response& res)
	{		
		Contact contact;

		Json::Value errors = Json::Value(Json::objectValue);

		view_->render_create(req,res,contact,errors);

		co_return;
	}

	Async insert( Request& req, Response& res)
	{		
		FormParams params(req.body());

		Contact contact(
			params.get("email"),	
			params.get("first"),	
			params.get("last"),	
			params.get("phone")	
		);

		Json::Value errors = Json::Value(Json::objectValue);

		bool valid = co_await validate(contact,"",errors);
		if(valid)
		{
			repository->insert(contact);
			view_->redirect_to_index(req,res);
		}
		else
		{
			view_->render_create(req,res,contact,errors);
		}

		co_return;
	}

	Async edit( Request& req, Response& res)
	{		
		std::string id = req.path.args().get("id");

		Contact contact = co_await repository->find_contact(id);

		Json::Value errors = Json::Value(Json::objectValue);

		view_->render_edit(req,res,contact,errors);

		co_return;
	}

	Async update( Request& req, Response& res)
	{		
		std::string id = req.path.args().get("id");

		FormParams params(req.body());

		Contact contact(
			id,
			params.get("email"),	
			params.get("first"),	
			params.get("last"),	
			params.get("phone")	
		);

		Json::Value errors = Json::Value(Json::objectValue);

		bool valid = co_await validate(contact,id,errors);
		if(valid)
		{
			repository->update(contact);
			view_->redirect_to_index(req,res);
		}
		else
		{
			view_->render_edit(req,res,contact,errors);
		}

		co_return;
	}

	Async remove( Request& req, Response& res)
	{		
		std::string id = req.path.args().get("id");
		std::string trigger = req.headers.get("HX-Trigger");

		co_await repository->remove(id);

		if( trigger == "delete-btn")
		{
			res.redirect("/contacts", 303).flush();
		}
		else
		{
			res.ok().header("HX-Trigger", "recountEvent").flush();
		}

		co_return;
	}

	Future<bool> validate(Contact& contact, const std::string& id, Json::Value& errors) 
	{
		bool valid = true;

		if(contact.email() == "")
		{
			valid = false;
			errors["email"] = "Email must not be empty.";
		}
		if(contact.last() == "")
		{
			valid = false;
			errors["last"] = "Last name must not be empty.";
		}

		Contact existing = co_await repository->find_contact_by_email(contact.email());
		if(existing.id() != id) 
		{
			valid = false;
			errors["email"] = "Email must be unique!";
		}

		co_return valid;
	}

private:

	std::shared_ptr<ContactRepository> repository;
	std::shared_ptr<View> view_;
};



#endif