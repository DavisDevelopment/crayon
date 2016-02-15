package crayon;

import tannus.dom.*;
import tannus.dom.Element.CElement;
import tannus.io.Ptr;
import tannus.io.Asserts.*;
import tannus.io.EventDispatcher;
import tannus.ds.Memory;
import tannus.ds.Obj;
import tannus.ds.Object;
import tannus.ds.Stack;
import tannus.ds.EitherType;
import tannus.html.Win;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class Component extends EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		super();
		__checkEvents = false;

		children = new Array();
		dependents = new Array();
	}

/* === Instance Methods === */

	/**
	  * delete [this] Component
	  */
	public function delete():Void {
		ensureElem();
		dispatch('delete', null);
		getElement().remove();

		for (dep in dependents) {
			switch ( dep ) {
				case DElement( el ):
					el.remove();
				case DComponent( comp ):
					comp.delete();
			}
		}

		for (child in children) {
			child.delete();
		}
	}

	/**
	  * attach [this] Component to an Element
	  */
	public function attachTo(parentEl : Element):Void {
		ensureElem();
		parentEl.append( elem );
		maybeActivate();
	}

	/**
	  * add a component as a child of [this] one
	  */
	public function addChild(child : Component):Void {
		if (!children.has( child )) {
			children.push( child );
			_append( child );
			child.maybeActivate();
		}
	}

	/**
	  * remove the given component as a child of [this]
	  */
	public function detachChild(child : Component):Void {
		children.remove( child );
	}

	/**
	  * remove a child from [this] Component, deleting it
	  */
	public function removeChild(child : Component):Void {
		if (children.has( child )) {
			detachChild( child );
			child.delete();
		}
	}

	/**
	  * get the underlying Element of [this] Component
	  */
	public function getElement():Element {
		ensureElem();
		return elem;
	}

	/**
	  * add a dependent to [this]
	  */
	public function addDependent(dep : EitherType<Element, Component>):Void {
		switch ( dep.type ) {
			case Left( el ):
				dependents.push(DElement( el ));

			case Right( comp ):
				dependents.push(DComponent( comp ));
		}
	}

	/**
	  * remove a dependent
	  */
	public function removeDependent(dep : EitherType<Element, Component>):Void {
		var del:Array<Dependent> = new Array();
		for (d in dependents) {
			if (d.getParameters()[0] == dep.type.getParameters()[0]) {
				del.push( d );
			}
		}
		dependents = dependents.macfilter(!del.has( _ ));
	}

	/**
	  * bind an event from the underlying Element, to [this]
	  */
	public function bindEvent(name : String):Void {
		ensureElem();
		getElement().on(name, dispatch.bind(name, _));
	}

	/**
	  * bind an Array of events
	  */
	public function bindEvents(list : Array<String>):Void {
		for (name in list) {
			bindEvent( name );
		}
	}

	/**
	  * perform some css-styling
	  */
	public function css(props : Object):Void {
		styles.write( props );
	}

	/**
	  * append [child]'s underlying Element to [this]'s underlying Element
	  */
	private function _append(child : Component):Void {
		ensureElem();
		getElement().append(child.getElement());
	}

	/**
	  * assert that [elem] has been assigned
	  */
	private inline function ensureElem():Void {
		assert((elem != null && Std.is(elem, CElement)), 'TypeError: $elem is not valid');
	}

	/**
	  * check whether [this] should be marked as 'activated'
	  */
	private inline function maybeActivate():Void {
		if (!_activated && elem.isDescendantOf( Win.current.document.body )) {
			dispatch('activated', parent);
		}
	}

	/**
	  * check whether the given Element is also a component
	  */
	private function elementComponent(el : Element):Null<Component> {
		if (!el.data.exists( DKEY )) {
			return null;
		}
		else {
			var dc = el.data[DKEY];
			if (Std.is(dc, Component)) {
				return cast dc;
			}
			else {
				return null;
			}
		}
	}

	/**
	  * bind [this] object to [elem]
	  */
	private function _initData():Void {
		elem.data.set(DKEY, this);
		var comp_data:Obj = {};
		elem.data.set((DKEY + '-data'), comp_data);
	}

	/**
	  * create a new Element of the given tag-type
	  */
	private function createElement(name:String, ?attrs:Obj):Element {
		var e:Element = new Element(doc.createElement( name ));
		if (attrs != null) {
			var at = e.attributes;
			for (k in attrs.keys()) {
				at.set(k, attrs.get(k));
			}
		}
		return e;
	}

/* === Computed Instance Fields === */

	/* the underlying Element for [this] Component */
	private var elem (default, set): Element;
	private function set_elem(v : Element):Element {
		elem = v;
		_initData();
		return elem;
	}

	/* the parent Component (if any) of [this] one */
	public var parent(get, never):Null<Component>;
	private function get_parent():Null<Component> {
		ensureElem();
		if (elem.parent == null) {
			return null;
		}
		else {
			return elementComponent( elem.parent );
		}
	}

	/* whether [this] is currently the root component */
	public var root(get, never):Bool;
	private inline function get_root():Bool return (parent == null);

	/* the Styles of [this] Component's underlying Element */
	public var styles(get, never):Styles;
	private function get_styles():Styles {
		ensureElem();
		return getElement().css;
	}

	/* the attributes of [this] Component's underlying Element */
	public var attributes(get, never):Attributes;
	private function get_attributes():Attributes {
		ensureElem();
		return getElement().attributes;
	}

	/* the data of [this] Component */
	public var data(get, never):Obj;
	private function get_data():Obj {
		ensureElem();
		return (elem.data.get(DKEY + '-data'));
	}

	/* the textual content of [this] Component's element */
	public var elementText(get, set):String;
	private function get_elementText():String {
		ensureElem();
		return e.text;
	}
	private function set_elementText(v : String):String {
		ensureElem();
		return (e.text = v);
	}

	/* the textual content of [this] Component */
	public var text(get, set):String;
	private function get_text():String return elementText;
	private function set_text(v : String):String return (elementText = v);

/* === Internal Computed Instance Fields === */

	/* the current window */
	private var win(get, never):Win;
	private inline function get_win():Win return Win.current;

	/* the current document */
	private var doc(get, never):js.html.HTMLDocument;
	private inline function get_doc():js.html.HTMLDocument return win.document;

	private var e(get, never):Element;
	private inline function get_e():Element return getElement();

	private var attr(get, never):Attributes;
	private inline function get_attr():Attributes return attributes;

/* === Instance Fields === */

	private var _activated : Bool = false;

	/* child components of [this] one */
	private var children : Array<Component>;

	/* objects which are bound to [this] */
	private var dependents : Array<Dependent>;

/* === Static Fields === */

	private static inline var DKEY:String = 'crayon:component';
	public static var MOUSE_EVENTS:Array<String> = {['mouseenter', 'mouseleave', 'mousemove', 'click', 'contextmenu'];};
	public static var KEYBOARD_EVENTS:Array<String> = {['keydown', 'keyup', 'keypress'];};
}

/**
  * an object bound, or 'dependant', on a Component
  */
enum Dependent {
	DElement(el : Element);
	DComponent(el : Component);
}
