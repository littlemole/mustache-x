<!doctype html>
<html lang="">
{{>header}}
<body >
<main>
    <header>
	    <p style="width:100%;text-align:right">
		{{#languages}}
			{{#active}}<b>{{/active}}
			<a href="/contacts?lang={{locale}}">{{locale}}</a>
			{{#active}}</b>{{/active}}
		{{/languages}}
		</p>
        <h1>
            <all-caps>{{#i18n}}title{{/i18n}}</all-caps>
            <sub-title>{{#i18n}}subtitle{{/i18n}}</sub-title>
        </h1>
    </header>

    <form action="/contacts" method="get" class="tool-bar">
        <label for="search">{{#i18n}}search.term{{/i18n}}</label>
        <input id="search" type="search" name="q" value="{{q}}"
               hx-get="/contacts"
               hx-trigger="search, keyup delay:200ms changed"
               hx-target="#contacts"
               hx-select="#contacts"
               hx-swap="outerHTML"
               hx-push-url="true"
               hx-indicator="#spinner"/>
        <img style="height: 20px" id="spinner" class="htmx-indicator" src="/img/spinning-circles.svg"/>
        <input type="submit" value="{{#i18n}}search.button{{/i18n}}"/>
    </form>

    <table>
        <thead>
        <tr>
            <th>{{#i18n}}contact.first{{/i18n}}</th>
            <th>{{#i18n}}contact.last{{/i18n}}</th>
            <th>{{#i18n}}contact.phone{{/i18n}}</th>
            <th>{{#i18n}}contact.email{{/i18n}}</th>
            <th></th>
        </tr>
        </thead>
        <tbody id="contacts" >
            {{#contacts}}
            <tr>
                <td>{{ first }}</td>
                <td>{{ last }}</td>
                <td>{{ phone }}</td>
                <td>{{ email }}</td>
                <td>
                    <div data-overflow-menu>
                        <button type="button" aria-haspopup="menu"
                            aria-controls="contact-menu-{{ id }}"
                            >{{#i18n}}contact.options{{/i18n}}</button>
                        <div role="menu" hidden id="contact-menu-{{ id }}">
                            <a role="menuitem" href="/contacts/{{ id }}/edit">{{#i18n}}contact.options.edit{{/i18n}}</a>
                            <a role="menuitem" href="/contacts/{{ id }}">{{#i18n}}contact.options.view{{/i18n}}</a>
                            <a role="menuitem" href="#"
                                hx-delete="/contacts/{{ id }}"
                                hx-select="#contacts"
                                hx-confirm="{{#i18n}}contact.confirm.delete{{/i18n}}"
                                hx-swap="outerHTML swap:1s"
                                hx-target="closest tr">{{#i18n}}contact.options.delete{{/i18n}}</a>
                        </div>
                    </div>
                </td>
            </tr>
        {{/contacts}}            
        </tbody>
    </table>
    <p >
        <a href="/contacts/new">{{#i18n}}contact.add{{/i18n}}</a> (
        <span hx-get="/contacts/count" hx-trigger="revealed, recountEvent from:body">
          <img id="spinner" style="height: 20px"  class="htmx-indicator" src="/img/spinning-circles.svg"/>
        </span>
        ) {{#i18n}}contact.total{{/i18n}}
    </p>

</main>
</body>
</html>

