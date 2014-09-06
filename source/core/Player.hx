
package core;

import flash.display.BitmapData;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxPoint;

import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;

import nape.shape.Circle;
import nape.shape.Shape;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.geom.Vec2;

import weapons.WeaponManager;
import weapons.Weapon;


@:bitmap("assets/images/zakk.png") class PlayerANI extends BitmapData {}
// TODO: Separate legs and top
// @:bitmap("assets/images/zakkbottom.png") class PlayerANI extends BitmapData {}






class Player extends FlxSpriteGroup
{

  private static var UP:Int = FlxObject.UP;
  private static var DOWN:Int = FlxObject.DOWN;
  private static var LEFT:Int = FlxObject.LEFT;
  private static var RIGHT:Int = FlxObject.RIGHT;


  /**
   * Main physics body of the player
   */
  public var body(get, null):Body;
  public function get_body():Body{
    return _body;
  }
  private var _body:Body;


  /**
   * Sprites
   */
  private var _topSprite:FlxNapeSprite;
  private var _botSprite:FlxNapeSprite;

  /**
   * Get position of the nape's body in FlxPoint
   */
  public var position(get, null):FlxPoint;
  public function get_position():FlxPoint{
    _position.x = _body.position.x;
    _position.y = _body.position.y;
    return _position;
  }
  private var _position:FlxPoint = new FlxPoint();

  /**
   * Movement data
   */
  private var _movement =
  {
    maxSpeed: 200,
    acceleration: 500,
    airControlRate: 1.0,
    drag: 800,
    dashRatio: 0.8
  };
  private var _acceleration:Vec2;
  

  /**
   * Jumping
   */
  private var _jump =
  {
    can: true,
    canDouble: true,
    canVariable: true,
    speed: -335
  };


  /**
   * Feet is here only to check if body is "on the floor"
   */
  private var _feet:Body;

  /**
   * Are we standing on the floor?
   */
  private var onGround(get, null):Bool;
  function get_onGround() {
    return false; // _body.isTouching(DOWN);
  }

  
  /**
   * Look and move directions
   */
  private var _direction:Dynamic<Int> =
  {
    look: RIGHT,
    move: RIGHT
  };


  /**
   * Visuals and Sprites
   */
  private var sprites:Dynamic<FlxSprite>;


  /**
   * Additional offset for the camera.
   */
  public var camTarget(get, null):FlxPoint;
  function get_camTarget(){
    return _camTarget;
  };
  private var _camTarget:FlxPoint = new FlxPoint(0,0);



  /**
   * Input
   */
  private var _inputBind:Dynamic<Array<String>>;
  private var _input:Dynamic<Bool>;


  /**
   * Inventory manager
   */
  public var inventory:Inventory;
  /**
   * Weapons manager
   */
  public var weapons:WeaponManager;
  



  private var _spawnPoint:FlxPoint;
  private var _tmpPoint:FlxPoint;


  private var _aniArmedOffset:Int;
  private var _weaponOffsetMap:Array<Dynamic<Int>>;


  override public function new(spawnPoint:FlxPoint, ?options:Dynamic):Void
  {
    super(spawnPoint.x, spawnPoint.y);
    _spawnPoint = new FlxPoint(spawnPoint.x, spawnPoint.y);


    initSprites();
    initAnimations();
    initPhysics();
    initInput();

    /**
     * Init stuff
     */
    inventory = new Inventory();
    weapons = new WeaponManager(this, 2);

    _tmpPoint = new FlxPoint(0,0);
    _aniArmedOffset = 16;

    

  }

  private function initSprites():Void
  {
    sprites = {};

    _topSprite = new FlxNapeSprite(0, -4);
    _botSprite = new FlxNapeSprite(0, 4);
    sprites.weapon = new FlxSprite();

    _topSprite.loadGraphic(PlayerANI, true, 16, 16);
    _topSprite.createRectangularBody(8, 8, BodyType.KINEMATIC);
    _topSprite.body.space = FlxNapeState.space;

    _botSprite.createRectangularBody(8, 8, BodyType.KINEMATIC);
    _botSprite.body.space = FlxNapeState.space;



    add(_topSprite);
    add(_botSprite);
    add(sprites.weapon);
  }
  private function initAnimations():Void
  {
    /**
     * Animations
     */
    _topSprite.animation.add('stand', [0]);
    _topSprite.animation.add('walk', [1,2,3,4,5], 20, true);
    _topSprite.animation.add('jump', [6,7], 18, false);
    _topSprite.animation.add('fall', [8,9], 6, true);
    _topSprite.animation.add('sliding', [10]);
    _topSprite.animation.add('landing', [11,12],22);
    // Armed
    _topSprite.animation.add('armedstand', [16]);
    _topSprite.animation.add('armedwalk', [17,18,19,20,21], 20, true);
    _topSprite.animation.add('armedjump', [22,23], 18, false);
    _topSprite.animation.add('armedfall', [24,25], 6, true);
    _topSprite.animation.add('armedsliding', [26]);
    _topSprite.animation.add('armedlanding', [11,12],22);


    // sprites.weapon.loadGraphic(Weapon.WeaponANI, true, 16, 16);
    _weaponOffsetMap = 
    [
      {x:2, y:0} , // 16
      {x:2, y:0} , // 17
      {x:2, y:1} , // 18
      {x:2, y:1} , // 19
      {x:2, y:0} , // 20
      {x:2, y:0} , // 21
      {x:2, y:0} , // 22
      {x:1, y:0} , // 23
      {x:2, y:-1}, // 24
      {x:2, y:-1}, // 25
      {x:1, y:0} , // 26
      {x:2, y:2} , // 27
      {x:2, y:1}   // 28
    ];
  }

  private function initPhysics():Void
  {
    _acceleration = new Vec2(0,0);

    _body = new Body( BodyType.KINEMATIC, new Vec2(0, 0) );
    _body.shapes.add( new Circle(14) );
    _body.space = FlxNapeState.space;

    _feet = new Body( BodyType.KINEMATIC, new Vec2(0, 5) );
    _feet.shapes.add( new Circle(4) );
    _feet.space = FlxNapeState.space;
  }

  private function initInput():Void
  {
    _input = {
      jump: false,
      left: false,
      right: false,
      up: false,
      down: false,
      fire: false,
      switchWeapon: false,
      skill: false,
      pause: false,
      menu: false
    };
    _inputBind = {
      jump: new Array<String>(),
      left: new Array<String>(),
      right: new Array<String>(),
      up: new Array<String>(),
      down: new Array<String>(),
      fire: new Array<String>(),
      switchWeapon: new Array<String>(),
      skill: new Array<String>(),
      pause: new Array<String>(),
      menu: new Array<String>()
    };

    _inputBind.jump.push("SPACE");
    _inputBind.left.push("LEFT");
    _inputBind.right.push("RIGHT");
    _inputBind.up.push("UP");
    _inputBind.down.push("DOWN");
    _inputBind.switchWeapon.push("Q");
    _inputBind.fire.push("E");
    _inputBind.skill.push("W");
    _inputBind.pause.push("P");
    _inputBind.menu.push("ESCAPE");
  }



  /**
   * Change player's acceleration
   * @param  dir should be 0, -1 or 1
   */
  private function accelerate(dir:Int):Void
  {
    // acceleration.x = _movement.acceleration * dir;
    _acceleration.x = _movement.acceleration * dir;
    // _body.velocity.x = _movement.acceleration * dir;

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
      case Player.RIGHT:
        _body.velocity.x = _movement.acceleration * _movement.dashRatio;
      case Player.LEFT:
        _body.velocity.x = _movement.acceleration * _movement.dashRatio * -1;
      case Player.DOWN:
        _body.velocity.x = 0;
        _body.velocity.y = _movement.acceleration;
    }
  }

  /**
   * Perform jump
   */
  private function jump():Void
  {
    _body.velocity.y = _jump.speed;

    _jump.canDouble = false;
  }

  private function descend():Void
  {
    // TODO: Haxify & we're on polygons now...
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
  private function animPrefix(str:String):String
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
      _jump.canDouble = true;
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
      if( Math.abs(_body.velocity.x) > 5 )
      {
        // Bot shouldn't have animPrefix for armed state
        _botSprite.animation.play("walk");
      }
      else
      {
        _botSprite.animation.play("stand");
      }

      // Sliding
      if(
        _body.velocity.x > 0 && _direction.move == RIGHT ||
        _body.velocity.x < 0 && _direction.move == LEFT
      ){
        _botSprite.animation.play("sliding");
      }
    }
    else
    {
      // Not on the ground
      if(_input.jump)
      {
        if(_jump.canDouble)
        {
          // _botSprite.animation.stop();
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
      if(_body.velocity.y > 0)
      {
        _botSprite.animation.play("fall");
      }
      else
      {
        if(_botSprite.animation.name != "jump")
        {
          _botSprite.animation.play("jump");
        }
      }
    }


    // updateWeaponOffset();

    weapons.update();

    if(weapons.justFired)
    {
      _body.velocity.x += weapons.currentWeapon.recoil * -_direction.move;

      // TODO: Shake based on recoil and look direction: SHAKE_VERTICAL/HORIZONTAL
      FlxG.camera.shake(0.05, 0.1);
    }

    updateSpritePositions();
    updateCamTarget();
  }

  /**
   * Updates statuses of keys
   */
  private function getKeys():Void
  { 
    _input.jump = FlxG.keys.anyPressed(_inputBind.jump);
    _input.left = FlxG.keys.anyPressed(_inputBind.left);
    _input.right = FlxG.keys.anyPressed(_inputBind.right);
    _input.up = FlxG.keys.anyPressed(_inputBind.up);
    _input.down = FlxG.keys.anyPressed(_inputBind.down);
    _input.fire = FlxG.keys.anyPressed(_inputBind.fire);
    _input.switchWeapon = FlxG.keys.anyPressed(_inputBind.switchWeapon);
    _input.skill = FlxG.keys.anyPressed(_inputBind.skill);
    _input.pause = FlxG.keys.anyPressed(_inputBind.pause);
    _input.menu = FlxG.keys.anyPressed(_inputBind.menu);

    // TODO: add Touch input and Gamepad
  }

  /**
   * Update weapon's xy position according to animation on spritesheets
   */
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

  /**
   * Only one body is being moved by all calculations
   * This function updates all attached sprites and bodies to follow _body's position
   */
  private function updateSpritePositions():Void
  {
    _topSprite.body.position = _botSprite.body.position;

    sprites.weapon.x = _topSprite.body.position.x;
    sprites.weapon.y = _topSprite.body.position.y;
  }

  /**
   * Updates the target camera position
   */
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
