package akaifirehx.util;


class Grid<T> {
	var width:Int;
	var height:Int;

	public var cells(default, null):Array<Null<T>>;

	public function new(defaultValue:T, width:Int, height:Int) {
		this.width = width;
		this.height = height;
		cells = [for (i in 0...width * height) defaultValue];
	}

	inline function i(x:Int, y:Int) {
		return x + width * y;
	}

	public function set(x:Int, y:Int, v:T) {
		cells[i(x, y)] = v;
	}

	public function get(x:Int, y:Int):Null<T> {
		return cells[i(x, y)];
	}
}