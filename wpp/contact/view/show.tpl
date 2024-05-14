
<!doctype html>
<html lang="">
{{>header}}
<body >
<main>
    <header>
	    <p style="width:100%;text-align:right">
		{{#languages}}
			{{#active}}<b>{{/active}}
			<a href="/contacts/{{contact.id}}?lang={{locale}}">{{locale}}</a>
			{{#active}}</b>{{/active}}
		{{/languages}}
		</p>
        <h1>
            <all-caps>{{#i18n}}title{{/i18n}}</all-caps>
            <sub-title>{{#i18n}}subtitle{{/i18n}}</sub-title>
        </h1>
    </header>

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