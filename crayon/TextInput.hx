package crayon;

class TextInput extends BaseInput<String> {
	/* Constructor Function */
	public function new():Void {
		super();

		elem = createElement('input', {
			'type': 'text'
		});

		bindEvents( Component.KEYBOARD_EVENTS );
		bindEvents(['input', 'change']);
	}

/* === Instance Methods === */

/* === Computed Instance Fields === */

	/* the value of [this] Input */
	override private function get_value():Null<String> return e.field( 'value' );
	override private function set_value(v : Null<String>):Null<String> return e.field('value', v);

	/* the placeholder */
	public var placeholder(get, set):String;
	private inline function get_placeholder():String return attr['placeholder'];
	private inline function set_placeholder(v:String):String return (attr['placeholder'] = v);
}
