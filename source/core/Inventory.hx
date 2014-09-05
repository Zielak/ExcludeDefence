
package core;

class Inventory 
{







  /**
   * Items
   */
  private var _items:Array<Item>;
  /**
   * How much Items can an Inventory handle
   */
  private var _itemsMax:Int = 6;


  /**
   * Perks
   */
  private var _perks:Array<Perk>;
  /**
   * How much Perks can player have
   */
  private var _perksMax:Int = 2;





  public function new():Void
  {
    _items = new Array<Item>();
    _perks = new Array<Perk>();
  }

  /**
   * Add new Item to the Inventory.
   * @param item Item that you want to add
   * @return new index of item in array or -1 on fail
   */
  public function addItem(item:Item):Int
  {
    if(_items.length < _itemsMax)
    {
      return _items.push(item);
    }else{
      return -1;
    }
  }

  /**
   * Drop the item from inventory (TODO: drop it on the ground)
   * @param  item Item that you want to get rid of
   * @return      Bool for success
   */
  public function dropItem(item:Item):Bool
  {
    return _items.remove(item);
  }



  


}
