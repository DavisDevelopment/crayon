package crayon;

class Button extends Component {
	/* Constructor Function */
	public function new(txt : String):Void {
		super();

		elem = createElement( 'button' );
		text = txt;

		bindEvents( Component.MOUSE_EVENTS );
	}
}
