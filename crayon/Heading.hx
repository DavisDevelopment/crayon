package crayon;

using tannus.math.TMath;

class Heading extends Component {
	/* Constructor Function */
	public function new(level:Int, txt=''):Void {
		super();
		level = level.clamp(1, 6);
		elem = createElement( 'h$level' );
		text = txt;
	}
}
