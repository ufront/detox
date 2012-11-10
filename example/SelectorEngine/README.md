Selector Engines in Detox
=========================

Detox makes heavy use of selector engines.  Originally we were only supporting the one that comes built into modern browsers - `document.querySelectorAll()`.  However, this doesn't work in IE6, 7 or even 8.  Therefore I'm setting Detox up to be able to use JQuery, or if you want something light weight, Sizzle, as the selector engine.

The behaviour should be the same, and Detox will use whatever is available.

The process:

 * You call "h1".find();
 * Detox check's what is available:
 	* If document.querySelectorAll exists, use this
 	* If Sizzle exists, use this
 	* If jQuery exists, use this
 	* If $ exists, use this
 * Return the resulting DOMCollection to you.

### Including Sizzle or jQuery

If you're using Dead Code Elimination in Haxe, then classes and methods which aren't used aren't included in the final output - which is great for keeping the JS file size down.  Keeping this in mind, I've tried to structure the Detox code in a way which won't include a selector engine you're not using.  There are some simple implications for this:

 * If you only want to use `querySelectorAll()`, you don't have to worry about anything.  (Works in IE9+ and other browsers)
 * If you are already using jQuery elsewhere in your project, it will probably 'just work' as a fallback for IE8 or older.
 * If you want to use IE8 or older, and you don't already have jQuery in your project, you'll have to:
 	* Include JQuery `Detox.includeJQuery();` somewhere in your project.  OR
 	* Include Sizzle `Detox.includeSizzle();` somewhere in your project.
 * Both JQuery and Sizzle respect the "noEmbedJS" compile flag.  If you include this in your hxml (-D noEmbedJS), then neither the jQuery or Sizzle code will be included in Haxe's JS output - you have to include them yourself *before* the Haxe Javascript runs.

### File Sizes

Obviously, including these older libraries will add to the generated file size.  In this example, the generated file sizes are:

	 16K usingBrowser.js       # Using querySelectorAll()
	 49K usingSizzle.js
	106K usingJQuery.js
	5.7K usingBrowser.js.gzip  # Using querySelectorAll()
	 15K usingSizzle.js.gzip
	 37K usingJQuery.js.gzip

So the cost of including these fallback files:

 * Sizzle  (33KB,  9.3KB gzipped)
 * jQuery  (90KB, 31.3KB gzipped)

Obviously, if you're already including jQuery for other plugins etc, you'll be including this anyway - so it's up to you.