
package weapons;

class WeaponSlot 
{

  public var weapon:Weapon;

  /**
   * No gun, no fun.
   */
  public var isEmpty(get, null):Bool;

  public function new():Void
  {
    empty();
  }

  public function empty():Void
  {
    weapon = null;
  }



  function get_isEmpty():Bool{
    if(weapon == null){
      return true;
    }else{
      return false;
    }
  }
}
