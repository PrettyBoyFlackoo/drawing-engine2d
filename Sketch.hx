package sketch;

import h2d.col.Point;
import h2d.Graphics;

import hxd.Key as K;

using StringTools;

class Sketch {

    var sprite:Graphics;

    var x:Float;
    var y:Float;
    
    var pixelX:Int;
    var pixelY:Int;
    var pixelWidth:Float;
    var pixelHeight:Float;

    var width:Float = 256;
    var height:Float = 256;

    var grid:Array<Cell> = [];

    var showGrid:Bool;

    public var color(default, null):Int;

    var parent:h2d.Scene;

    public function new(pixelX:Int, pixelY:Int, parent:h2d.Scene) {
        this.pixelX = pixelX;
        this.pixelY = pixelY;
        this.parent = parent;
        
        x += parent.width / 2 - width / 2;
        y += parent.height / 2 - height / 2;

        ///Create Pixel Grid
        for (x in 0...pixelX) {
            for (y in 0...pixelY) {
                grid.push({
                    pos: new Point(y, x),
                    color: 0xFFFFFF
                });
            }
        }

        calculatePixelSize();

        sprite = new Graphics(parent);
    }

    public function update(dt:Float):Void {
        if (K.isPressed(K.TAB)) {
            showGrid = !showGrid;
        }

        if (K.isPressed(K.NUMBER_1)) {
            color = 0xFFFFFF;
        }

        if (K.isPressed(K.NUMBER_2)) {
            color = 0xE21717;
        }

        if (K.isPressed(K.NUMBER_3)) {
            color = 0x27E021;
        }

        if (K.isPressed(K.NUMBER_4)) {
            color = 0x6F2DDA;
        }

        if (K.isPressed(K.MOUSE_WHEEL_DOWN)) {
            scaleSketch(-.25);
        }

        if (K.isPressed(K.MOUSE_WHEEL_UP)) {
            scaleSketch(.25);
        }
        
        if (K.isDown(K.MOUSE_LEFT)) {
            var mouse = new Point(parent.mouseX, parent.mouseY);

            for (i in grid) {
                var x = this.x + i.pos.x * pixelWidth;
                var y = this.y + i.pos.y * pixelHeight;

                if (mouse.x > x && mouse.x < x + pixelWidth && mouse.y > y && mouse.y < y + pixelHeight) {
                    i.color = color;
                }
            }
        }

        draw();
    }

    function draw():Void {
        sprite.clear();

        sprite.beginFill(0xFFFFFF);
        sprite.drawRect(x, y, width, height);
        sprite.endFill();

    
        ///Draw
        for (i in grid) {
            sprite.beginFill(i.color);

            sprite.drawRect(x + i.pos.x * pixelWidth, y + i.pos.y * pixelHeight, pixelWidth, pixelHeight);

            sprite.endFill();
        }


        ///Draw Grid
        var alpha = 1.0;

        showGrid ? alpha = 1 : alpha = 0;

        sprite.lineStyle(1, 0x00FF00, alpha);

        for (x in 0...pixelX) {
            sprite.moveTo(this.x + x * pixelWidth, this.y + 0);
            sprite.lineTo(this.x + x * pixelWidth, this.y + height);

            for (y in 0...pixelY) {
                sprite.moveTo(this.x + 0, this.y + y * pixelHeight);
                sprite.lineTo(this.x + width, this.y + y * pixelHeight);

            }
        }

        sprite.lineStyle();
    }

    public inline function setColor(c:Int):Int {
        color = c;
        
        return color;
    }

    public inline function getColor():String {
        return '0x' + color.hex();
    }

    inline function calculatePixelSize():Void {
        pixelWidth = width / pixelX;
        pixelHeight = height / pixelY;
    }

    function scaleSketch(abs:Float) {
        abs *= 100;

        width += abs;
        height += abs;

        if (width < 32) {
            width = 32;
        }

        if (height < 32) {
            height = 32;
        }

        calculatePixelSize();
      
        x = parent.width / 2 - width / 2;
        y = parent.height / 2 - height / 2;
    }
}