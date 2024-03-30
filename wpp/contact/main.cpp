#include "reprocpp/test.h"
#include "reproweb/ctrl/controller.h"
#include "reproweb/view/i18n.h"
#include "reproweb/view/tpl.h"
#include "reproweb/web_webserver.h"
#include <signal.h>
     
//#include "valid.h"
#include "view.h"
#include "repo.h"
#include "controller.h"
  
using namespace diy;  
using namespace prio;
using namespace reproweb;



int main(int /*argc*/, char** /*argv*/ )
{
	prio::Libraries<prio::EventLoop> init;

	WebApplicationContext ctx {

		GET  ( "/contacts",				&Controller::index),
		GET  ( "/contacts/count",		&Controller::count),
		GET  ( "/contacts/new",			&Controller::create),
		POST ( "/contacts/new",			&Controller::insert),
		GET  ( "/contacts/{id}/edit",	&Controller::edit),
		POST ( "/contacts/{id}/edit",	&Controller::update),
		GET  ( "/contacts/{id}/email",	&Controller::email),
		DEL  ( "/contacts/{id}",		&Controller::remove),
		GET  ( "/contacts/{id}",		&Controller::show),
/*		GET  ( "/logout",		&Controller::logout),
		GET  ( "/login",		&Controller::show_login),
		GET  ( "/register",		&Controller::show_registration),
		POST ( "/login",		&Controller::login),
		POST ( "/register",		&Controller::register_user),
*/
		singleton<AppConfig()>(),
		singleton<ContactPool(AppConfig)>(),

		singleton<ContactRepository(ContactPool)>(),

		singleton<View(AppConfig,TplStore)>(),
		singleton<Controller(ContactRepository,View)>()

	};	


	WebServer server(ctx);
	server.configure<AppConfig>();
	server.listen();
     
	theLoop().run();

	MOL_TEST_PRINT_CNTS();	
    return 0;
}
