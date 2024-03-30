
<!doctype html>
<html lang="">
<head>
    <title>Contact App</title>    
    <link rel="stylesheet" href="https://the.missing.style/v0.2.0/missing.min.css">
    <link rel="stylesheet" href="/static/site.css">
    <script src="/static/js/htmx-1.8.0.js"></script>
    <script src="/static/js/rsjs-menu.js" type="module"></script>
</head>
<body >
<main>
    <header>
        <h1>
            <all-caps>contacts.app</all-caps>
            <sub-title>A Demo Contacts Application</sub-title>
        </h1>
    </header>

    <form action="/contacts/{{ id }}/edit" method="post">
        <fieldset>
            <legend>Contact Values</legend>
            <div class="table rows">
                <p>
                    <label for="email">Email</label>
                    <input name="email" id="email" type="email"
                           hx-get="/contacts/{{ id }}/email" hx-target="next .error"
                           hx-trigger="change, keyup delay:200ms"
                           placeholder="Email" value="{{ email }}">
                    <span class="error">{{ errors.email }}</span>
                </p>
                <p>
                    <label for="first_name">First Name</label>
                    <input name="first_name" id="first_name" type="text" placeholder="First Name"
                           value="{{ first }}">
                    <span class="error">{{ errors.first }}</span>
                </p>
                <p>
                    <label for="last_name">Last Name</label>
                    <input name="last_name" id="last_name" type="text" placeholder="Last Name"
                           value="{{ last }}">
                    <span class="error">{{ errors.last }}</span>
                </p>
                <p>
                    <label for="phone">Phone</label>
                    <input name="phone" id="phone" type="text" placeholder="Phone" value="{{ phone }}">
                    <span class="error">{{ errors.phone }}</span>
                </p>
            </div>
            <button>Save</button>
        </fieldset>
    </form>

    <button id="delete-btn"
            hx-delete="/contacts/{{ id }}"
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
    