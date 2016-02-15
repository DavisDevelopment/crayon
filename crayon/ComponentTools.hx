package crayon;

import tannus.io.Ptr;
import tannus.io.Asserts.*;
import tannus.ds.Obj;
import tannus.graphics.Color;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

@:access( crayon.Component )
class ComponentTools {
	/**
	  * get/set the font-configuration of the given Component
	  */
	public static function font(c:Component, ?data:SetFont):Font {
		var s = c.styles;
		if (data == null) {
			return {
				'family': s['font-family'],
				'size': s['font-size']
			};
		}
		else {
			if (data.family != null)
				s['font-family'] = data.family;
			if (data.size != null)
				s['font-size'] = data.size;
			return font( c );
		}
	}

	/**
	  * get/set the color of a Component
	  */
	public static function color(c:Component, ?v:Color):Color {
		if (v == null) {
			var curr:Color = Color.fromString(c.styles['color']);
			var bits:Array<Int> = [curr.red, curr.green, curr.blue];
			var str:Void->String = (function() return (new Color(bits[0], bits[1], bits[2]).toString()));

			var _r = Ptr.create(bits[0]);
			var _g = Ptr.create(bits[1]);
			var _b = Ptr.create(bits[2]);
			for (ref in [_r, _g, _b]) {
				ref.setter.wrap(function(set, i) {
					var res = set.set( i );
					c.styles.set('color', str());
					return res;
				});
			}
			var bound = Color._linked(_r, _g, _b);
			return bound;
		}
		else {
			c.styles.set('color', v.toString());
			return v.clone();
		}
	}

	/**
	  * get/set the background-color of a Component
	  */
	public static function backgroundColor(c:Component, ?v:Color):Color {
		if (v == null) {
			var curr:Color = Color.fromString(c.styles['background-color']);
			var bits:Array<Int> = [curr.red, curr.green, curr.blue];
			var str:Void->String = (function() return (new Color(bits[0], bits[1], bits[2]).toString()));

			var _r = Ptr.create(bits[0]);
			var _g = Ptr.create(bits[1]);
			var _b = Ptr.create(bits[2]);
			for (ref in [_r, _g, _b]) {
				ref.setter.wrap(function(set, i) {
					var res = set.set( i );
					c.styles.set('background-color', str());
					return res;
				});
			}
			var bound = Color._linked(_r, _g, _b);
			return bound;
		}
		else {
			c.styles.set('color', v.toString());
			return v.clone();
		}
	}

	/**
	  * get/set margin
	  */
	public static function margin(c:Component, ?data:SetMargin):Margin {
		if (data == null) {
			var raw = c.styles.pluck(['margin-top', 'margin-right', 'margin-bottom', 'margin-left']);
			var res:Obj = {};
			for (k in raw.keys)
				res.set(k.after('margin-'), raw.get( k ));
			return untyped res.toDyn();
		}
		else {
			var d = data;
			var s = c.styles;

			nn(d.top, s['margin-top'] = (_ + 'px'));
			nn(d.right, s['margin-right'] = (_ + 'px'));
			nn(d.bottom, s['margin-bottom'] = (_ + 'px'));
			nn(d.left, s['margin-left'] = (_ + 'px'));

			trace('here');
			return margin( c );
		}
	}

	/**
	  * get/set padding
	  */
	public static function padding(c:Component, ?data:SetMargin):Margin {
		if (data == null) {
			var raw = c.styles.pluck(['padding-top', 'padding-right', 'padding-bottom', 'padding-left']);
			var res:Obj = {};
			for (k in raw.keys)
				res.set(k.after('padding-'), raw.get( k ));
			return untyped res.toDyn();
		}
		else {
			var d = data;
			var vals = [d.top, d.right, d.bottom, d.left].macmap(_ + 'px');
			var val = vals.join(' ');
			c.styles['padding'] = val;
			return padding( c );
		}
	}

	/**
	  * get/set border
	  */
	public static function border(c:Component, ?data:SetBorder):Border {
		var s = c.styles;
		if (data == null) {
			return {
				'style': s['border-style'],
				'color': s['border-color'],
				'width': Std.parseFloat(s['border-color'])
			};
		}
		else {
			var d = data;
			if (d.style != null)
				s['border-style'] = d.style;
			if (d.color != null)
				s['border-color'] = d.color;
			if (d.width != null)
				s['border-width'] = '${d.width}px';
			return border( c );
		}
	}

	/**
	  * get/set the floating
	  */
	public static function float(c:Component, ?value:String):String {
		if (value == null) {
			return c.styles['float'];
		}
		else {
			return (c.styles['float'] = value);
		}
	}

	/**
	  * get/set the width
	  */
	public static function width(c:Component, ?val:Dynamic):Float {
		var s = c.styles;
		if (val == null) {
			return Std.parseFloat(s['width']);
		}
		else {
			s['width'] = Std.string( val );
			return width(c);
		}
	}

	/**
	  * get/set the height
	  */
	public static function height(c:Component, ?val:Dynamic):Float {
		var s = c.styles;
		if (val == null) {
			return Std.parseFloat(s['height']);
		}
		else {
			s['height'] = Std.string( val );
			return height(c);
		}
	}
}

typedef Font = {family : String, size : String};
typedef SetFont = {?family:String, ?size:String};

typedef Margin = {top:Int, right:Int, bottom:Int, left:Int};
typedef SetMargin = {?top:Int, ?right:Int, ?bottom:Int, ?left:Int};

typedef SetBorder = {?style:String, ?color:String, ?width:Float};
typedef Border = {style:String, color:String, width:Float};
