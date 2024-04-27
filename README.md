# Mustache-X 

Opinionated modern web examples utilizing [&lt;/&gt;htmx](https://htmx.org/) and [{{Mustache}}](https://mustache.github.io/) for interactive web pages,
in an effort to help bringing back the joy of web development.

# Example web app

The example web app is a stripped down version of the web 1 server-side <b>Contacts</b> [webapp](https://hypermedia.systems/a-web-1-0-application/) introduced in the HTMX book [hypermedia.systems](https://hypermedia.systems/), covering the basic CRUD aspects of the Contacts app. The archiver part has been omitted, but we talk to a real database ( [mariadb](https://mariadb.com/) ).

All example implementations cover the same functionality. Examples avail in Python, Perl (2), PHP (2), JavaScript, Java (2) and C++.

## HTMX features covered

- [active search](https://htmx.org/examples/active-search/) - filtering the display list
- [lazy loading](https://htmx.org/examples/lazy-load/) - (re-)loading the total contact count
- [delete row](https://htmx.org/examples/delete-row/) - account deletion w/o reload
- [inline validation](https://htmx.org/examples/inline-validation/) - when editing email address of existing account.

No hx-boost is used. [HX-Trigger](https://htmx.org/headers/hx-trigger/) is used via Response Header to initiate a lazy reload of the count on delete.

## Mustache

All examples use the logic-less [{{Mustache}}](https://mustache.github.io/) template engine to render content.

# Running examples

All examples are containerized ([docker](https://www.docker.com/)), e.g. to run the flask example do:

```bash
cd flask
docker-compose up --build
```
then point your browser to [http://localhost:5000/contacts](http://localhost:5000/contacts). Ports for other examples see table below.

Dockerfiles are used for reproducible build. As these are examples just developer web-servers are started - providing production use containers and/or running them is outside the scope of this exercise.

## Install docker pre-requisites

ubuntu:
```bash
sudo apt install docker-io docker-compose
```
# All Examples

|name|framework|language|port|mustache|
|----|---------|--------|----|--------|
|flask|[Flask](https://flask.palletsprojects.com/)|[Python 3](https://www.python.org/)|[5000](http://localhost:5000/contacts)|[chevron](https://pypi.org/project/chevron/)|
|dancer|[Dancer2](https://perldancer.org/)|[Perl 5](https://www.perl.org/)|[3000](http://localhost:3000/contacts)|[Template::Mustache](https://metacpan.org/dist/Template-Mustache)|
|mod_perl2|[mod_perl](https://perl.apache.org/)|[Perl 5](https://www.perl.org/)|[3000](http://localhost:3000/contacts)|[Template::Mustache](https://metacpan.org/dist/Template-Mustache)|
|symfony|[Symfony 6.4](https://symfony.com/)|[PHP 8.1](https://www.php.net/)|[8000](http://localhost:8000/contacts)|[mustache/mustache](https://packagist.org/packages/mustache/mustache)|
|laravel|[Laravel 10](https://laravel.com/)|[PHP 8.1](https://www.php.net/)|[8000](http://localhost:8000/contacts)|[mustache/mustache](https://packagist.org/packages/mustache/mustache)|
|node|[ExpressJs 4.19](http://expressjs.com/)|[NodeJs 20](https://nodejs.org/en)|[3000](http://localhost:3000/contacts)|[mustache](https://www.npmjs.com/package/mustache)|
|spring|[Spring Boot 3.2.4](https://spring.io/projects/spring-boot)|[Java 17](https://openjdk.org/projects/jdk/17/)|[8000](http://localhost:8000/contacts)|[jmustache 1.15](https://github.com/samskivert/jmustache)|
|jetty|[Jetty 12 Servlet](https://eclipse.dev/jetty/)|[Java 17](https://openjdk.org/projects/jdk/17/)|[8000](http://localhost:8000/contacts)|[spullara](https://github.com/spullara/mustache.java)|
|wpp|[wpp](https://github.com/littlemole/wpp)|[C++](https://isocpp.org/)|[3000](http://localhost:3000/contacts)|[kainjow](https://github.com/kainjow/Mustache)|
 
</table>