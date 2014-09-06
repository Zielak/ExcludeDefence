package;

import flixel.FlxCamera;
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

import core.Player;
import ui.HUD;
import weapons.Projectile;
import world.Level;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxNapeState
{


  public var projectiles:FlxTypedGroup<Projectile>;
  // public var enemies:FlxTypedGroup<Enemy>;

  private var _currentLevel:Level;


  public var player:Player;
  public var hud:HUD;

  /**
   * Function that is called up when to state is created to set it up. 
   */
  override public function create():Void
  {
    super.create();
    FlxG.stage.quality = flash.display.StageQuality.LOW;
    napeDebugEnabled = true;


    projectiles = new FlxTypedGroup<Projectile>();
    add(projectiles);


    _currentLevel = new Level();
    add(_currentLevel.linemap);


    player = new Player(_currentLevel.spawnPoint);
    add(player);

    
    hud = new HUD();
    add(hud);


    FlxG.camera.focusOn( new FlxPoint(player.x, player.y));
    FlxG.camera.follow(player, FlxCamera.STYLE_LOCKON, 5);
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




  public function addBullet(projectile:Projectile):Void
  {
    projectiles.add(projectile);
  }
}


