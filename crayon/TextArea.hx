package crayon;

import js.html.TextAreaElement;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class TextArea extends Component {
	/* Constructor Function */
	public function new():Void {
		super();

		elem = createElement( 'textarea' );

		bindEvents( Component.KEYBOARD_EVENTS );
		bindEvents(['input', 'change']);
	}

/* === Instance Methods === */

	/* focus on [this] */
	public inline function focus():Void ta.focus();

	/* unfocus [this] */
	public inline function blur():Void ta.blur();

/* === Computed Instance Fields === */

	/* underlying DOM object */
	private var ta(get, never):TextAreaElement;
	private inline function get_ta():TextAreaElement return cast e.first;

	/* number of visible columns */
	public var cols(get, set):Int;
	private inline function get_cols():Int return ta.cols;
	private inline function set_cols(v : Int):Int return (ta.cols = v);

	/* number of visible rows */
	public var rows(get, set):Int;
	private inline function get_rows():Int return ta.rows;
	private inline function set_rows(v : Int):Int return (ta.rows = v);

	/* the value of [this] TextArea */
	public var value(get, set):String;
	private inline function get_value():String return ta.value;
	private inline function set_value(v : String):String return (ta.value = v);
}
