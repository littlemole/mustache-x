<header>
	<p style="width:100%;text-align:right">
	{{#languages}}
		{{#active}}<b>{{/active}}
		<a href="{{base_url}}?lang={{locale}}">{{locale}}</a>
		{{#active}}</b>{{/active}}
	{{/languages}}
	</p>
	<h1>
		<all-caps>{{#i18n}}title{{/i18n}}</all-caps>
		<sub-title>{{#i18n}}subtitle{{/i18n}}</sub-title>
	</h1>
</header>
