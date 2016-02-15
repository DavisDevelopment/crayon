package crayon;

import js.html.SelectElement;

import tannus.ds.Object;

class Select extends Component {
	/* Constructor Function */
	public function new():Void {
		super();

		elem = createElement( 'select' );
		opts = new Array();

		bindEvent( 'change' );
	}

/* === Instance Methods === */

	/**
	  * add an option to [this]
	  */
	public function option(text:String, value:String):Option {
		var o = new Option(text, value);
		addChild( o );
		opts.push( o );
		return o;
	}

	/**
	  * add a group of options
	  */
	public function options(batch : Object):Array<Option> {
		var added = [];
		for (text in batch.keys) {
			added.push(option(text, (batch[text] + '')));
		}
		return added;
	}

/* === Computed Instance Fields === */

	/* the underlying <select> element */
	private var se(get, never):SelectElement;
	private inline function get_se():SelectElement return cast e.first;

	/* the index of the selected option */
	public var selectedIndex(get, never):Int;
	private inline function get_selectedIndex():Int return se.selectedIndex;

	/* the currently selected option */
	public var selectedOption(get, never):Option;
	private inline function get_selectedOption():Option return opts[selectedIndex];

	/* the current value of [this] */
	public var value(get, never):String;
	private inline function get_value():String return selectedOption.value;

/* === Instance Fields === */

	private var opts : Array<Option>;
}

class Option extends Component {
	public function new(txt:String, val:String):Void {
		super();
		elem = createElement( 'option' );

		text = txt;
		value = val;
	}

	public var value(get, set):String;
	private inline function get_value():String return e.field( 'value' );
	private inline function set_value(v : String):String return e.field('value', v);

	public var selected(get, set):Bool;
	private inline function get_selected():Bool return e.field( 'selected' );
	private inline function set_selected(v : Bool):Bool return e.field('selected', v);
}
