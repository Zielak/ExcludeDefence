
package weapons;

import util.Damage;

class Weapon 
{

  private var _fireRate:Float = 0.15;
  private var _recoil:Float = 0.5;
  public var recoil(get, null):Float;
  public function get_recoil():Float{
    return _recoil;
  }

  private var _damage:Damage;
  private var _damageMin:Int = 1;
  private var _damageMax:Int = -1;

  public function new():Void
  {
    _damage = new Damage(_damageMin, _damageMax);
  }


  public function fire():Bool
  {
    // FIRE! conditions, timers and everything
    return false;
  }

  public function updateWeapon():Void
  {
    // Update timers and everything
  }

}


// interface IWeapon
// {



// }

