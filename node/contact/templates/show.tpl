
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

<h1>{{contact.first}} {{contact.last}}</h1>

<div>
    <div>Phone: {{contact.phone}}</div>
    <div>Email: {{contact.email}}</div>
</div>

<p>
    <a href="/contacts/{{contact.id}}/edit">Edit</a>
    <a href="/contacts">Back</a>
</p>

</main>
</body>
</html>