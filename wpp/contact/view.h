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

class View 
{
public:

	View( std::shared_ptr<AppConfig> conf, std::shared_ptr<TplStore> tpls)
		: templates_(tpls)
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
		res.redirect(req, "/contacts").flush();
	}


private:

    void render(Request& req, Response& res, const std::string&tpl, Json::Value data) 
	{
		std::string locale = get_locale(req);
		std::string short_locale = get_short_locale(locale);

		std::vector<std::string> avail_locales{ "en","de" };
		Json::Value langs(Json::arrayValue);
		for(auto& it : avail_locales)
		{
			Json::Value l(Json::objectValue);
			l["locale"] = it;
			l["active"] = it == short_locale ? true : false;
			langs.append(l);
		}
		data["languages"] = langs;

		std::string content = templates_->render(tpl,locale,data);

		Cookie cookie("language",locale);
		cookie.path("/");

		res
			.ok()
			.cookie(cookie)
			.body(content)
			.flush();
	}

	std::string get_short_locale(const std::string& locale)
	{
		if(locale.size() == 2) return locale;
		auto v = prio::split(locale,"_");
		if(v.size()>1)
		{
			if(v[0].size() == 2) return v[0];
		}
		return "en";
	}

	std::string get_locale(Request& req)
	{
		auto qp = req.path.queryParams();
		if(qp.exists("lang"))
		{
			std::string lang = qp.get("lang");
			if(!lang.empty())
			{
				std::regex rgx("^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$");
				if(std::regex_match(lang,rgx))
				{
					return lang;
				}
			}
		}
		auto cookies = req.headers.cookies();
		if(cookies.exists("language"))
		{
			auto cookie = cookies.get("language");
			{
				std::string lang = cookie.value();
				if(!lang.empty())
				{
					std::regex rgx("^[a-zA-Z][a-zA-Z](_[a-zA-Z][a-zA-Z])?$");
					if(std::regex_match(lang,rgx))
					{
						return lang;
					}
				}
			}
		}
		return req.locale();
	}

	std::string version_;
	std::shared_ptr<TplStore> templates_;

};
 
#endif

