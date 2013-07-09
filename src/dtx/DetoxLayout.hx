package dtx;

import haxe.ds.StringMap;
using Detox;
using StringTools;

class DetoxLayout extends dtx.DOMCollection
{
	public var dtd:String;
	public var head:DOMNode;
	public var body:DOMNode;
	public var title(get_title, set_title):String;
	public var content(default, set_content):DOMCollection;
	public var navigation(default, set_navigation):DOMCollection;

	var contentDOM:DOMNode;
	var titleDOM:DOMNode;
	var navigationDOM:DOMNode;
	
	public var scripts:StringMap<DOMCollection>;
	public var stylesheets:StringMap<DOMCollection>;

	public function new(?template:String, ?layout:DOMNode, dtd:String = "<!DOCTYPE html>", contentSelector = "#main-content", navSelector = "#main-nav")
	{
		super();

		if (layout != null)
		{
			this.add(layout);
		} 
		else if (template != null) 
		{
			this.addCollection(template.parse());
		}
		else
		{
			throw "DetoxLayout requires either a HTML string as a template or a pre-existing DOMNode in order to work.";
		}

		this.dtd = dtd;

		head = this.find("head").getNode();
		body = this.find("body").getNode();
		titleDOM = this.find("title").getNode();
		contentDOM = this.find(contentSelector).getNode();
		navigationDOM = this.find(navSelector).getNode();

		scripts = new StringMap();
		for (script in this.find("script"))
		{
			scripts.set(script.attr("src"), script.toCollection());
		}

		stylesheets = new StringMap();
		for (stylesheet in this.find("link[rel=stylesheet]"))
		{
			stylesheets.set(stylesheet.attr("href"), stylesheet.toCollection());
		}
	}

	public function addScript(url:String)
	{
		var scriptTag = '<script type="text/javascript" src="$url"></script>'.parse();
		scripts.set(url, scriptTag);
		scriptTag.appendTo(body);
	}

	public function addInlineScript(script:String)
	{
		var scriptTag = script.parse();
		scripts.set(script, scriptTag);
		scriptTag.appendTo(body);
	}

	public function removeScript(script:String)
	{
		if (scripts.exists(script))
		{
			var scriptTag = scripts.get(script);
			scriptTag.removeFromDOM();
			scripts.remove(script);
		}
	}

	public function addStylesheet(url:String, ?media:String = "all")
	{
		var stylesheetTag = '<link rel="stylesheet" type="text/css" href="$url" media="$media" />'.parse();
		stylesheets.set(url, stylesheetTag);
		stylesheetTag.appendTo(head);
	}

	public function removeStylesheet(url:String)
	{
		if (stylesheets.exists(url))
		{
			var stylesheetTag = stylesheets.get(url);
			stylesheetTag.removeFromDOM();
			stylesheets.remove(url);
		}
	}

	public function html()
	{
		return this.dtd + "\n" + dtx.collection.ElementManipulation.html(this);
	}

	function get_title()
	{
		return titleDOM.text();
	}

	function set_title(newTitle:String)
	{
		titleDOM.setText(newTitle);
		return newTitle;
	}

	function set_content(newContent:dtx.DOMCollection)
	{
		contentDOM.empty();
		contentDOM.append(newContent);
		return newContent;
	}

	function set_navigation(newNavigation:dtx.DOMCollection)
	{
		contentDOM.empty();
		contentDOM.append(newNavigation);
		return newNavigation;
	}
}
