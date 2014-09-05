
package weapons;

class Weapon 
{

  private var _fireRate:Float = 0.15;
  private var _recoil:Float = 0.5;

  private var _damage:Damage;
  private var _damageMin:Int = 1;
  private var _damageMax:Int = -1;

  public function new():Void
  {

    damage = new Damage(_damageMin, _damageMax);
  }

}
