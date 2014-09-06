
package ui;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{

  private var _elapsed:Float;

  private var _flash:FlxSprite;
  private var _flashDur:Float;


  private var _levelTxt:FlxText;

  private var _scoreTxt:FlxText;



  public function new():Void
  {
    super();


    var halfx = Std.int(FlxG.width*0.5);
    var halfy = Std.int(FlxG.height*0.5);

    _flash = new FlxSprite().makeGraphic(FlxG.width+40, FlxG.height+40);
    _flash.drawRect(0, 0, FlxG.width+40, FlxG.height+40, FlxColor.WHITE);
    _flash.x = _flash.y = -20;
    _flash.visible = false;
    add(_flash);

    _levelTxt = new FlxText(FlxG.width - 82, 12, 80, "Level: 0", 8);
    _levelTxt.alignment = "right";
    _levelTxt.borderColor = FlxColor.BLACK;
    _levelTxt.setBorderStyle(FlxText.BORDER_OUTLINE, FlxColor.BLACK, 1, 1);
    updateLevelTxt(0);
    add(_levelTxt);

    _scoreTxt = new FlxText(2, 2, 0, "Score: 0", 8);
    _scoreTxt.borderColor = FlxColor.BLACK;
    _scoreTxt.setBorderStyle(FlxText.BORDER_OUTLINE , FlxColor.BLACK, 1, 1);
    updateScoreTxt(0);
    add(_scoreTxt);


    // position: fixed; lol
    forEach(function(spr:FlxSprite) {
      spr.scrollFactor.set();
    });


  }


  override public function update():Void
  {

    _elapsed = FlxG.elapsed;

    if(_flashDur > 0) _flashDur--;
    if(_flashDur <= 0 && _flash.visible){
      _flash.visible = false;
    }

    super.update();
  }


  /**
   * Update one of the text fields on HUD
   * @param  field Name of text field. It should match variable name like so: _scoreTxt = "score". I'm using switch statement to assign new values.
   * @param  text  What should be written here?
   */
  public function updateText(field:String, text:Dynamic):Void
  {
    var str:String;
    str = Std.string(text);

    switch (field) {
      case "level":
        updateLevelTxt(str);
      case "score":
        updateScoreTxt(str);
    }
  }

  public function flash(duration:Float = 0.3):Void
  {
    _flashDur = duration;
    _flash.visible = true;
  }











  private function updateLevelTxt(text:Dynamic):Void
  {
    _levelTxt.text = "Level: "+Std.string(text);
  }

  private function updateScoreTxt(text:Dynamic):Void
  {
    _scoreTxt.text = "Score: "+Std.string(text);
  }

}