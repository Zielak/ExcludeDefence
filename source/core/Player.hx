
package core;

import flash.display.BitmapData;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxPoint;





@:bitmap("assets/images/zakk.png") class PlayerANI extends BitmapData {}
// TODO: Separate legs and top?
// @:bitmap("assets/images/zakkbottom.png") class PlayerANI extends BitmapData {}






class Player extends FlxSpriteGroup
{

  private static var UP:Int = FlxObject.UP;
  private static var DOWN:Int = FlxObject.DOWN;
  private static var LEFT:Int = FlxObject.LEFT;
  private static var RIGHT:Int = FlxObject.RIGHT;

  /**
   * Movement
   */
  private var _movement =
  { maxSpeed: 200
  , acceleration: 500
  , airControlRate: 1.0
  , drag: 800
  , dashRatio: 0.8
  };

  /**
   * Jumping
   */
  private var _jump =
  { can: true
  , canDouble: true
  , canVariable: true
  , speed: -335
  };

  // Just getter, cooldown is private
  private var onGround(get, null):Bool;
  function get_onGround() {
    return sprites.bot.isTouching(DOWN);
  }

  



  /**
   * Look and move directions
   */
  private var _direction =
  { look: RIGHT
  , move: RIGHT
  };


  /**
   * Visuals and Sprites
   */
  private var sprites = 
  { top: new FlxSprite()
  , bot: new FlxSprite()
  , weapon: new FlxSprite()
  };

  private var _camTarget:FlxPoint = new FlxPoint(0,0);
  public var camTarget(get, null):FlxPoint;
  function get_camTarget(){
    return _camTarget;
  }



  /**
   * Input
   */
  typedef SA = Array<String>;
  typedef inputBind =
  { jump: SA
  , left: SA
  , right: SA
  , up: SA
  , down: SA
  , fire: SA
  , switchWeapon: SA
  , skill: SA
  , pause: SA
  , menu: SA
  }
  private var _input =
  { jump: false
  , left: false
  , right: false
  , up: false
  , down: false
  , fire: false
  , switchWeapon: false
  , skill: false
  , pause: false
  , menu: false
  }



  public var inventory:Inventory = new Inventory();
  public var weapons:WeaponManager = new WeaponManager();
  



  private var _spawnPoint:FlxPoint;
  private var _tmpPoint:FlxPoint = new FlxPoint(0,0);


  private var _aniArmedOffset:Int = 16;
  private var _weaponOffsetMap:Array<Int>;


  public function new(spawnPoint:FlxPoint, ?options:Dynamic):Void
  {
    super(spawnPoint.x, spawnPoint.y);

    _spawnPoint.x = spawnPoint.x;
    _spawnPoint.y = spawnPoint.y;

    sprites.top.loadGraphic(PlayerANI, true, 16, 16);


    initAnimations();

    add(sprites.top);
    add(sprites.weapon);



    /**
     * Input definition
     */
    inputBind.jump = new Array(FlxKey.SPACE);
    inputBind.left = new Array(FlxKey.LEFT);
    inputBind.right = new Array(FlxKey.RIGHT);
    inputBind.up = new Array(FlxKey.UP);
    inputBind.down = new Array(FlxKey.DOWN);
    inputBind.switchWeapon = new Array(FlxKey.Q);
    inputBind.fire = new Array(FlxKey.E);
    inputBind.skill = new Array(FlxKey.W);
    inputBind.pause = new Array(FlxKey.P);
    inputBind.menu = new Array(FlxKey.ESCAPE);
  }

  private function initAnimations():Void
  {
    /**
     * Animations
     */
    sprites.top.animations.add('stand', [0]);
    sprites.top.animations.add('walk', [1,2,3,4,5], 20, true);
    sprites.top.animations.add('jump', [6,7], 18, false);
    sprites.top.animations.add('fall', [8,9], 6, true);
    sprites.top.animations.add('sliding', [10]);
    sprites.top.animations.add('landing', [11,12],22);
    // Armed
    sprites.top.animations.add('armedstand', [16]);
    sprites.top.animations.add('armedwalk', [17,18,19,20,21], 20, true);
    sprites.top.animations.add('armedjump', [22,23], 18, false);
    sprites.top.animations.add('armedfall', [24,25], 6, true);
    sprites.top.animations.add('armedsliding', [26]);
    sprites.top.animations.add('armedlanding', [11,12],22);


    sprites.weapon.loadGraphic(Weapon.WeaponANI, true, 16, 16);
    _weaponOffsetMap = 
    [ {x:2, y:0}  // 16
    , {x:2, y:0}  // 17
    , {x:2, y:1}  // 18
    , {x:2, y:1}  // 19
    , {x:2, y:0}  // 20
    , {x:2, y:0}  // 21
    , {x:2, y:0}  // 22
    , {x:1, y:0}  // 23
    , {x:2, y:-1} // 24
    , {x:2, y:-1} // 25
    , {x:1, y:0}  // 26
    , {x:2, y:2}  // 27
    , {x:2, y:1}  // 28
    ]
  }



  /**
   * Change player's acceleration
   * @param  dir should be 0, -1 or 1
   */
  private function accelerate(dir:Int):Void
  {
    acceleration.x = _movement.acceleration * dir;

    // TODO: Get rid of air control?
    // if(!isTouching(DOWN)){
    //   acceleration.x *= _movement.airControlRate;
    // }
  }

  /**
   * Performs dash in given direction.
   * Full speed acceleration in left, right or down
   * @param  dir
   */
  private function dash(dir:Int):Void
  {
    switch (dir) {
      case RIGHT:
        velocity.x = _movement.acceleration * _movement.dashRatio;
      case LEFT:
        velocity.x = _movement.acceleration * _movement.dashRatio * -1;
      case DOWN:
        velocity.x = 0;
        velocity.y = _movement.acceleration;
    }
  }

  /**
   * Perform jump
   */
  private function jump():Void
  {
    velocity.y = _jump.speed;

    jump.canDouble = false;
  }

  private function descend():Void
  {
    // TODO: Haxify
    // var tile = this.tileBelow

    // if(tile !== null && typeof tile.properties.isPlatform !== 'undefined'){
    //   if(tile.properties.isPlatform){
    //     this.sprite.body.y = this.sprite.body.y + 10
    //     this.sprite.body.velocity.y = 50
    //   }
    // }
  }















  /**
   * Prepend animation type before playing it, depending on player state
   * Does he carry a gun? -> 'armed'
   * @param  {String} str
   * @return {String}
   */
  private function animPrefix(str:String):Void
  {
    if( weapons.isArmed ){
      str = 'armed' + str;
    }
    return str;
  }
















  override public function update():Void
  {
    getKeys();

    /**
     * Acceleration
     */
    accelerate(0);
    if(_input.left && !_input.right){
      accelerate(LEFT);
    }else if(!_input.left && _input.right){
      accelerate(RIGHT);
    }


    /**
     * Jumping
     */
    if(onGround)
    {
      jump.canDouble = true;
      if(_input.jump && !_input.down)
      {
        jump();
      }
      else if(_input.jump && _input.down)
      {
        descend();
      }

      /**
       * Animations
       */
      if( Math.abs(velocity.x) > 5 )
      {
        // Bot shouldn't have animPrefix for armed state
        sprites.bot.animation.play("walk");
      }
      else
      {
        sprites.bot.animation.play("stand");
      }

      // Sliding
      if(
        velocity.x > 0 && _direction.move === RIGHT ||
        velocity.x < 0 && _direction.move === LEFT
      ){
        sprites.bot.animation.play("sliding");
      }
    }
    else
    {
      // Not on the ground
      if(_input.jump)
      {
        if(_jump.canDouble)
        {
          sprites.bot.animation.stop();
          jump();

          if(_input.left){
            dash(LEFT);
          }else if(_input.right){
            dash(RIGHT);
          }else if(_input.down){
            dash(DOWN);
          }
        }
      }

      /**
       * Animations
       */
      if(velocity.y > 0)
      {
        sprites.bot.animations.play("fall");
      }
      else
      {
        if(sprites.bot.animation.name != "jump")
        {
          sprites.bot.animation.play("jump");
        }
      }
    }


    // updateWeaponOffset();

    weapons.update();

    if(weapons.weaponFired)
    {
      velocity.x += weapons.current.recoil * -direction.move;

      // TODO: Shake based on recoil and look direction: SHAKE_VERTICAL/HORIZONTAL
      FlxG.camera.shake(0.05, 0.1);
    }

    updateCamTarget();
  }

  /**
   * Updates statuses of keys
   */
  private function getKeys():Void
  { 
    _input.jump = FlxG.keys.anyPressed(inputBind.jump);
    _input.left = FlxG.keys.anyPressed(inputBind.left);
    _input.right = FlxG.keys.anyPressed(inputBind.right);
    _input.up = FlxG.keys.anyPressed(inputBind.up);
    _input.down = FlxG.keys.anyPressed(inputBind.down);
    _input.fire = FlxG.keys.anyPressed(inputBind.fire);
    _input.switchWeapon = FlxG.keys.anyPressed(inputBind.switchWeapon);
    _input.skill = FlxG.keys.anyPressed(inputBind.skill);
    _input.pause = FlxG.keys.anyPressed(inputBind.pause);
    _input.menu = FlxG.keys.anyPressed(inputBind.menu);

    // TODO: add Touch input and Gamepad
  }


  private function updateWeaponOffset():Void
  {
    var frameIndex:Int = 0;
    // if( this.sprite.animations.currentFrame )
    // {
    //   frameIndex = this.sprite.animations.currentFrame.index
    // }
    // if( this.weapons.isArmed && frameIndex >= this.ANI_ARMED_OFFSET )
    // {
    //   frameIndex -= this.ANI_ARMED_OFFSET
    // }

    // this.weapon.x = this.sprite.x + this.sprite.body.deltaX() + this.weaponOffsetMap[frameIndex][0] * 2 * this.moveDirection;
    // this.weapon.y = this.sprite.y + this.sprite.body.deltaY() + this.weaponOffsetMap[frameIndex][1] * 2;
  }

  private function updateCamTarget():Void
  {
    _camTarget.x = x + velocity.x / 5;
    _camTarget.y = y + velocity.y / 20;
    _camTarget.subtract(FlxG.camera.width/2, FlxG.camera.height/2);

    var lookThere:Int = 30;
    if(_direction.look == LEFT){
      lookThere *= -1;
    }
    _camTarget.add(lookThere, 0);
  }


}




// static class PlayerInput
// {

//   public static function isJump():Void
//   {
    
//   }
// }
