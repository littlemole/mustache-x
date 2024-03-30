<!doctype html>
<html lang="">
<head>
    <title>Contact App</title>    
    <link rel="stylesheet" href="https://the.missing.style/v0.2.0/missing.min.css">
    <link rel="stylesheet" href="/site.css">
    <script src="/js/htmx-1.8.0.js"></script>
    <script src="/js/rsjs-menu.js" type="module"></script>
</head>
<body >
<main>
    <header>
        <h1>
            <all-caps>contacts.app</all-caps>
            <sub-title>A Demo Contacts Application</sub-title>
        </h1>
    </header>

    <form action="/contacts" method="get" class="tool-bar">
        <label for="search">Search Term</label>
        <input id="search" type="search" name="q" value="{{q}}"
               hx-get="/contacts"
               hx-trigger="search, keyup delay:200ms changed"
               hx-target="#contacts"
               hx-select="#contacts"
               hx-swap="outerHTML"
               hx-push-url="true"
               hx-indicator="#spinner"/>
        <img style="height: 20px" id="spinner" class="htmx-indicator" src="/static/img/spinning-circles.svg"/>
        <input type="submit" value="Search"/>
    </form>

    <table>
        <thead>
        <tr>
            <th>First</th>
            <th>Last</th>
            <th>Phone</th>
            <th>Email</th>
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
                            >Options</button>
                        <div role="menu" hidden id="contact-menu-{{ id }}">
                            <a role="menuitem" href="/contacts/{{ id }}/edit">Edit</a>
                            <a role="menuitem" href="/contacts/{{ id }}">View</a>
                            <a role="menuitem" href="#"
                                hx-delete="/contacts/{{ id }}"
                                hx-select="#contacts"
                                hx-confirm="Are you sure you want to delete this contact?"
                                hx-swap="outerHTML swap:1s"
                                hx-target="closest tr">Delete</a>
                        </div>
                    </div>
                </td>
            </tr>
        {{/contacts}}            
        </tbody>
    </table>
    <p >
        <a href="/contacts/new">Add Contact</a> (
        <span hx-get="/contacts/count" hx-trigger="revealed, recountEvent from:body">
          <img id="spinner" style="height: 20px"  class="htmx-indicator" src="/static/img/spinning-circles.svg"/>
        </span>
        ) total Contacts.
    </p>

</main>
</body>
</html>

