
<!doctype html>
<html lang="">
<meta charset="utf-8">
{{>header.tpl}}

<body>
<main>
    <header>
	    <p style="width:100%;text-align:right">
		{{#languages}}
			{{#active}}<b>{{/active}}
			<a href="/contacts/new?lang={{locale}}">{{locale}}</a>
			{{#active}}</b>{{/active}}
		{{/languages}}
		</p>
        <h1>
            <all-caps>{{#i18n}}title{{/i18n}}</all-caps>
            <sub-title>{{#i18n}}subtitle{{/i18n}}</sub-title>
        </h1>
    </header>

<form action="/contacts/new" method="post">
    <fieldset>
        <legend>{{#i18n}}contact.values{{/i18n}}</legend>

        <div class="table rows">
            <p>
                <label for="email">{{#i18n}}contact.email{{/i18n}}</label>
                <input name="email" id="email" type="text" placeholder="{{#i18n}}contact.email{{/i18n}}" value="{{contact.email }}">
                <span class="error">{{ errors.email }}</span>
            </p>
            <p>
                <label for="first_name">{{#i18n}}contact.first{{/i18n}}</label>
                <input name="first_name" id="first_name" type="text" placeholder="{{#i18n}}contact.first{{/i18n}}" value="{{ contact.first }}">
                <span class="error">{{ errors.first }}</span>
            </p>
            <p>
                <label for="last_name">{{#i18n}}contact.last{{/i18n}}</label>
                <input name="last_name" id="last_name" type="text" placeholder="{{#i18n}}contact.last{{/i18n}}" value="{{ contact.last  }}">
                <span class="error">{{ errors.last }}</span>
            </p>
            <p>
                <label for="phone">{{#i18n}}contact.phone{{/i18n}}</label>
                <input name="phone" id="phone" type="text" placeholder="{{#i18n}}contact.phone{{/i18n}}" value="{{ contact.phone }}">
                <span class="error">{{ errors.phone}}</span>
            </p>
        </div>
        <button>{{#i18n}}contact.save{{/i18n}}</button>
    </fieldset>
</form>

<p>
    <a href="/contacts">{{#i18n}}contact.back{{/i18n}}</a>
</p>

</main>
</body>
</html>
