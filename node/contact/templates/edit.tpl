
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

    <form action="/contacts/{{ contact.id }}/edit" method="post">
        <fieldset>
            <legend>Contact Values</legend>
            <div class="table rows">
                <p>
                    <label for="email">Email</label>
                    <input name="email" id="email" type="email"
                           hx-get="/contacts/{{ contact.id }}/email" hx-target="next .error"
                           hx-trigger="change, keyup delay:200ms"
                           placeholder="Email" value="{{ contact.email }}">
                    <span class="error">{{ errors.email }}</span>
                </p>
                <p>
                    <label for="first">First Name</label>
                    <input name="first" id="first" type="text" placeholder="First Name"
                           value="{{ contact.first }}">
                    <span class="error">{{ errors.first }}</span>
                </p>
                <p>
                    <label for="last">Last Name</label>
                    <input name="last" id="last" type="text" placeholder="Last Name"
                           value="{{ contact.last }}">
                    <span class="error">{{ errors.last }}</span>
                </p>
                <p>
                    <label for="phone">Phone</label>
                    <input name="phone" id="phone" type="text" placeholder="Phone" value="{{ contact.phone }}">
                    <span class="error">{{ errors.phone }}</span>
                </p>
            </div>
            <button>Save</button>
        </fieldset>
    </form>

    <button id="delete-btn"
            hx-delete="/contacts/{{ contact.id }}"
            hx-push-url="true"
            hx-confirm="Are you sure you want to delete this contact?"
            hx-target="body">
        Delete Contact
    </button>

    <p>
        <a href="/contacts">Back</a>
    </p>
    
</main>
</body>
</html>
    