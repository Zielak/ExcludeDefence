package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

import flixel.addons.nape.FlxNapeState;

import weapons.Projectile;
import world.Level;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{


  public var projectiles:FlxTypedGroup<Projectile>;

  private var _currentLevel:Level;

  /**
   * Function that is called up when to state is created to set it up. 
   */
  override public function create():Void
  {
    super.create();

    napeDebugEnabled = true;

    projectiles = new FlxTypedGroup<Projectile>();


    _currentLevel = new Level();
    FlxG.log.add(_currentLevel.polymap.toString());
    add(_currentLevel.polymap);

    add(projectiles);
  }
  
  /**
   * Function that is called when this state is destroyed - you might want to 
   * consider setting all objects this state uses to null to help garbage collection.
   */
  override public function destroy():Void
  {
    super.destroy();
  }

  /**
   * Function that is called once every frame.
   */
  override public function update():Void
  {
    super.update();

    if (FlxG.mouse.justPressed)
    {

      var bullet = new Projectile(new FlxPoint(FlxG.mouse.x,FlxG.mouse.y), new FlxPoint(FlxRandom.intRanged(-100,100),FlxRandom.intRanged(-100,100) ));
      projectiles.add(bullet);
    }
  }
}
