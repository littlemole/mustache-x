#ifndef _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_MODEL_ENTITIES_DEFINE_
#define _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_MODEL_ENTITIES_DEFINE_

#include <string>
#include <memory>

#include <reproweb/tools/config.h>
#include <metacpp/meta.h>


class Contact
{
public:

	Contact() {}

	Contact( 
		const std::string& id,
		const std::string& email,
		const std::string& first,
		const std::string& last,
		const std::string& phone
	)
	  : 
	     id_(id),  
  	  	 email_(email),
		 first_(first),
		 last_(last),
		 phone_(phone)
	{}

	Contact( 
		const std::string& email,
		const std::string& first,
		const std::string& last,
		const std::string& phone
	)
	  : 
  	  	 email_(email),
		 first_(first),
		 last_(last),
		 phone_(phone)
	{}

	std::string id() const 	  	  { return id_; }
	std::string email() const 	  { return email_; }
	std::string first() const 	  { return first_; }
	std::string last() const  	  { return last_; }
	std::string phone() const  	  { return phone_; }

	static constexpr auto meta()
	{
		return meta::data (
			"id", &Contact::id_,
			"email", &Contact::email_,
			"first", &Contact::first_,
			"last", &Contact::last_,
			"phone", &Contact::phone_
		);
	}
	
private:
	std::string id_;
	std::string email_;	
	std::string first_;	
	std::string last_;	
	std::string phone_;	
};


class AppConfig : public reproweb::Config
{
public:
	AppConfig()
	  : reproweb::Config("config.json")
	{
	}
};

#endif
