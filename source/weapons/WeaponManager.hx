
package weapons;

import flixel.FlxG;
import flixel.util.FlxPoint;


/**
 * WeaponSloManager is responsible for
 * - getting input
 * - managing weapon slots
 * - fireing projectiles
 * - etc.
 *
 * WeaponSlots and Weapons hold only DATA and TIMERS to be used
 * by THIS class
 */

class WeaponManager 
{

  private var _owner:Player;

  private var _slots:Array<WeaponSlot>;
  private var _currentSlotIndex:Int = 0;

  /**
   * Get current WeaponSlot
   */
  private var currentSlot(get, null):WeaponSlot;
  /**
   * Get current Weapon
   */
  private var currentWeapon(get, null):Weapon;



  /**
   * Is the trigger currently held down?
   */
  private var _trigger:Bool = false;


  /**
   * Did the gun just fired?
   */
  public var justFired(get, null):Bool;
  private var _justFired:Bool = false;

  /**
   * Did we just changed a weapon?
   */
  public var justChanged(get, null):Bool;
  private var _justChanged:Bool = false;

  /**
   * Is the player holding any weapon right now?
   */
  public var isArmed(get, null):Bool;




  /**
   * Dummy temp stuff
   */
  private var _projectilePos:FlxPoint = new FlxPoint(0,0);
  private var _projectileVel:FlxPoint = new FlxPoint(0,0);
  private var _projectile:Projectile;


  public function new(slots:Int):Void
  {
    _slots = new Array<WeaponSlot>();

    for(i in 0..slots){
      _slots.push(new WeaponSlot());
    }

  }

  /**
   * Update loop, timers, input etc.
   * @return [description]
   */
  public function update():Void
  {
    _justFired = false;
    _justChanged = false;

    if(_trigger)
    {
      // Try to fire current gun, it may be on cooldown.
      _justFired = currentWeapon.fire();

      if(_justFired)
      {
        // TODO: Fire projectiles in the air!
        //       Suck this dunctionality out from the Weapon
        fireWeapon
      }
    }

    for(s in slots)
    {
      if(!s.isEmpty)
      {
        s.updateWeapon();
      }
    }
  }








  /**
   * Add new weapon. Cancel if all or given slots are occupied. Force drops weapons from selected slot. 
   * @param weapon     New weapon you want in your inventory.
   * @param ?slotIndex Choose slot number.
   * @param ?force     Inser new weapon even if slot is occupied. Drops the old weapon. Works only when you choose slotIndex.
   */
  public function addWeapon(weapon:Weapon, ?slotIndex:Int = -1, ?force:Bool = false):Void
  {
    var targetSlot:Int = slotIndex;

    if(targetSlot < 0)
    {
      // Pick first empty slot
      for(i in 0.._slots.length)
      {
        if(_slots[i].isEmpty)
        {
          targetSlot = i;
        }
      }
      if(targetSlot < 0) return;
    }
    else
    {
      if(!_slots[i].isEmpty && !force) return;
      if(!_slots[i].isEmpty && force)
      {
        dropWeapon(targetSlot);
      }
    }

    _currentSlotIndex = targetSlot;
    currentSlot.weapon = weapon;

  }

  /**
   * Equip weapon of given index.
   * @param  index Index of weapon
   */
  public function changeWeapon(index:Int):Void
  {
    if(index < 0 || index > _slots.length) return;

    if(_slots[index].isEmpty) return;

    _currentSlotIndex = index;
    _justChanged = true;
  }

  public function dropWeapon(index:Int):Void
  {
    if(index > _slots.length-1) return;

    // Nothing to drop
    if(_slots[index].isEmpty) return;

    // TODO: drop that weapon on the ground!
    _slots[index].empty();
  }


  /**
   * Start holding your finger on the trigger (or start swinging your melee weapon)
   */
  public function holdTrigger():Void
  {
    _trigger = true;
  }

  /**
   * Release your finger from the trigger (or stop swinging melee weapon)
   */
  public function releaseTrigger():Void
  {
    _trigger = false;
  }








  private function fireWeapon():Void
  {
    _projectilePos.x = _owner.position.x;
    _projectilePos.y = _owner.position.y;
    _projectileVel.x = _owner.velocity.x;
    _projectileVel.y = _owner.velocity.y;

    _projectile = new Projectile(_projectilePos, _projectileVel);
    _projectile

    FlxG.state.addBullet();

  }







  function get_justChanged():Bool{
    return _justChanged;
  }
  function get_justFired():Bool{
    return _justFired;
  }
  function get_currentWeapon():Weapon{
    return currentSlot.weapon;
  }
  function get_currentSlot():WeaponSlot{
    return _slots[_currentSlotIndex];
  }
  function get_isArmed():Bool{
    if(currentSlot.isEmpty){
      return false;
    }else{
      return true;
    }
  }
}
