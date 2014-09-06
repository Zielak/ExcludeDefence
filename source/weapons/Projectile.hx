
package weapons;

import util.Damage;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

using flixel.util.FlxSpriteUtil;

class Projectile extends FlxSprite
{

  public var damage:Damage = new Damage();
  public var maxLifeTime:Float = 1;
  private var _lifeTime:Float = 0;

  override public function new(pos:FlxPoint, vel:FlxPoint ):Void
  {
    super(pos.x,pos.y);

    makeGraphic(10, 10, FlxColor.RED);
    drawCircle();


    velocity.x = vel.x;
    velocity.y = vel.y;
  }



  override public function update():Void
  {
    super.update();

    _lifeTime += FlxG.elapsed;
    if(_lifeTime >= maxLifeTime)
    {
      kill();
    }
  }

  override public function kill():Void
  {
    super.kill();

    damage = null;

    destroy();
  }
}
