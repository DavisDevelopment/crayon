package crayon;

class BaseInput<T> extends Component {
	/* Constructor Function */
	public function new():Void {
		super();
	}

/* === Instance Methods === */

	/**
	  * shift focus to [this] Input
	  */
	public function focus():Void {
		try {
			var f:Void->Void = e.field('focus');
			f();
		}
		catch (err : Dynamic) {
			trace( err );
		}
	}

	/**
	  * remove focus from [this] Input
	  */
	public function blur():Void {
		try {
			var f:Void->Void = e.field( 'blur' );
			f();
		}
		catch (err : Dynamic) {
			trace( err );
		}
	}

/* === Computed Instance Fields === */

	/* the value of [this] Input */
	public var value(get, set):Null<T>;
	private function get_value():Null<T> return null;
	private function set_value(v : Null<T>):Null<T> return null;
}
