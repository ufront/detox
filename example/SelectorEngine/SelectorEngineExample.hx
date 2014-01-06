using Detox;

class SelectorEngineExample
{
	static function main()
	{
		var message:String;

		#if usingJQuery
			Detox.includeJQuery();
			message = "Including jQuery as a fallback selector engine, will work in IE6, 7, 8 or modern browsers.";
		#elseif usingSizzle
			Detox.includeSizzle();
			message = "Including Sizzle as a fallback selector engine, will work in IE6, 7, 8 or modern browsers.";
		#else
			message = "Using document.querySelectorAll() as a selector engine, will not work in IE6, 7 or 8.";
		#end

		Detox.ready(function () {
			"p.message".find().setText(message);
		});
	}
}