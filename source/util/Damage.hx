
package util;

import flixel.util.FlxRandom;

class Damage 
{

  private var _ranged:Bool;
  private var _min:Int;
  private var _max:Int;


  public function new(?A:Int = 1, ?B:Int = -1):Void
  {
    if(B > 0)
    {
      _ranged = true;
      _min = A;
      _max = B;
    }
    else
    {
      _ranged = false;
      _min = A;
      _max = A;
    }
  }


  /**
   * Retrieve amount of damage to deal. RNG if ranged.
   */
  function get_get():Int{
    // TODO: cool RNG
    if(_ranged)
    {
      return FlxRandom.intRanged(_min, _max);
    }
    else
    {
      return _min;
    }
  }

}
