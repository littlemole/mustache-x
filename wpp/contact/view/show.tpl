
<!doctype html>
<html lang="">
{{>header}}
<body >
<main>

{{>title}}

<h1>{{contact.first}} {{contact.last}}</h1>

<div>
    <div>{{#i18n}}contact.phone{{/i18n}}: {{contact.phone}}</div>
    <div>{{#i18n}}contact.email{{/i18n}}: {{contact.email}}</div>
</div>

<p>
    <a href="/contacts/{{contact.id}}/edit">{{#i18n}}contact.edit{{/i18n}}</a>
    <a href="/contacts">{{#i18n}}contact.back{{/i18n}}</a>
</p>

</main>
</body>
</html>