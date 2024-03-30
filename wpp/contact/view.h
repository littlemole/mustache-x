#ifndef _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_VIEW_DEFINE_
#define _DEF_GUARD_DEFINE_REPROWEB_HELLO_WORLD_VIEW_DEFINE_

#include <metacpp/json.h>

#include "reproweb/serialization/json.h"
#include "reproweb/ctrl/ssi.h"
#include "reproweb/view/i18n.h"
#include "reproweb/view/tpl.h"

#include "entities.h"

using namespace reproweb;
using namespace repro;
using namespace prio;

class View : public MustacheView
{
public:

	View( std::shared_ptr<AppConfig> conf, std::shared_ptr<TplStore> tpls)
		: MustacheView(tpls)
	{
		version_ = conf->getString("version");
	}

	void render_index(Request& req, Response& res, 
		const std::vector<Contact>& contacts,
		const std::string& search)
	{
		Json::Value json = Json::Value(Json::objectValue);
		json["contacts"] = meta::toJson(contacts);
		json["q"] = search;

		render(req,res,"index",json);
	}

	void render_count(Request&, Response& res, long count)
	{
		res.ok().body(std::to_string(count)).flush();
	}

	void render_show(Request& req, Response& res, const Contact& contact)
	{
		Json::Value json = Json::Value(Json::objectValue);
		json["contact"] = meta::toJson(contact);
		json["errors"] = Json::Value(Json::objectValue);

		render(req,res,"show",json);
	}

	void render_create(Request& req, Response& res, const Contact& contact, Json::Value errors)
	{
		Json::Value json = Json::Value(Json::objectValue);
		json["contact"] = meta::toJson(contact);
		json["errors"] = errors;

		render(req,res,"new",json);
	}

	void render_edit(Request& req, Response& res, const Contact& contact, Json::Value errors)
	{
		Json::Value json = Json::Value(Json::objectValue);
		json["contact"] = meta::toJson(contact);
		json["errors"] = errors;

		render(req,res,"edit",json);
	}

	void redirect_to_index(Request& req, Response& res)
	{
		redirect( req, res, "/contacts" );
	}


private:

	std::string version_;


};
 
#endif

