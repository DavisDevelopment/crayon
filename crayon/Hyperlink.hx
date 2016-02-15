package crayon;

import tannus.http.Url;
import tannus.sys.Mime;

class Hyperlink extends Component {
	/* Constructor Function */
	public function new(txt:String, ?href:String):Void {
		super();

		elem = createElement( 'a' );
		text = txt;
		if (href != null) {
			this.href = href;
		}

		bindEvents( Component.MOUSE_EVENTS );
	}

/* === Computed Instance Fields === */

	/* the 'href' attribute of [this] Hyperlink */
	public var href(get, set):String;
	private inline function get_href():String return attributes['href'];
	private inline function set_href(v : String):String return (attributes['href'] = v);

	/* the 'target' attribute of [this] Hyperlink */
	public var target(get, set):String;
	private inline function get_target():String return attributes['target'];
	private inline function set_target(v : String):String return (attributes['target'] = v);

	/* the media-type of the linked document */
	public var type(get, set):Mime;
	private inline function get_type():Mime return attr['type'];
	private inline function set_type(v : Mime):Mime return (attr['type'] = v);

	/* the 'download' attribute of the hyperlink */
	public var download(get, set):Null<String>;
	private inline function get_download():Null<String> return (attr.exists('download') ? attr['download'] : null);
	private function set_download(v : Null<String>):Null<String> {
		if (v == null) {
			e.removeAttribute( 'download' );
			return null;
		}
		else {
			return (attr['download'] = v);
		}
	}
}
