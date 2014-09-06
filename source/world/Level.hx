
package world;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.shapes.FlxShapeLine;
import flixel.addons.editors.tiled.*;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxPoint;
import flixel.util.FlxSpriteUtil;

import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Level
{

  private var _map:TiledMap;
  private var _tilemap:FlxNapeTilemap;

  /**
   * Static world polygons, platforms etc.
   */
  // private var _polymap:FlxTypedGroup<FlxNapeSprite>;
  // public var polymap(get_polymap, null):FlxTypedGroup<FlxNapeSprite>;
  // public function get_polymap():FlxTypedGroup<FlxNapeSprite>{
  //   return _polymap;
  // }

  /**
   * World lines visible to player
   */
  private var _linemap:FlxTypedGroup<FlxSprite>;
  public var linemap(get_linemap, null):FlxTypedGroup<FlxSprite>;
  public function get_linemap():FlxTypedGroup<FlxSprite>{
    return _linemap;
  }
  /**
   * Prevent drawing lines out of FlxSprite boundries
   */
  private var _linesOffset:Int = 5;
  
  /**
   * Player starting position, get from the map
   */
  private var _spawnPoint:FlxPoint;
  public var spawnPoint(get, null):FlxPoint;
  public function get_spawnPoint():FlxPoint{
    return _spawnPoint;
  }

  private var _gravity:Vec2;


  // private var _napeSprite:FlxNapeSprite;
  private var _body:Body;
  private var _poly:Polygon;
  private var _geomPoly:GeomPoly;
  private var _geomPolyList:GeomPolyList;
  private var _verts:Array<Vec2>;
  private var _vec:Vec2;
  private var _vec2:Vec2;

  /**
   * Static polygons layer that player can move on
   */
  private var _worldGroup:TiledObjectGroup;
  /**
   * Functional volumes and points in game
   */
  private var _volumesGroup:TiledObjectGroup;


  public function new():Void
  {
    FlxG.log.add("In Level new()");
    _map = new TiledMap(AssetPaths.protolvl_001__tmx);
    // _polymap = new FlxTypedGroup<FlxNapeSprite>();
    _linemap = new FlxTypedGroup<FlxSprite>();


    _spawnPoint = new FlxPoint(0,0);

    // TODO: Get gravity from Tiled map config
    // FlxNapeState.space.gravity = new Vec2(0, 600);

    initWorld();
  }
  

  /**
   * Initialize the static world
   */
  private function initWorld():Void
  {
    // FlxG.log.add("In Level initWorld()");
    _worldGroup = _map.getObjectGroup("world");
    FlxG.log.add("got "+_worldGroup.objects.length+" objects.");

    for(o in _worldGroup.objects)
    {
      // Get all vertices
      _verts = new Array<Vec2>();
      var vminx:Float = 0;
      var vminy:Float = 0;

      for(v in o.points)
      {
        _vec = new Vec2(v.x, v.y);

        if(_vec.x < vminx){
          vminx = _vec.x;
          // FlxG.log.add("new min x: "+vminx);
        }
        if(_vec.y < vminy){
          vminy = _vec.y;
          // FlxG.log.add("new min y: "+vminy);
        }

        _verts.push(_vec);
      }

      // Start physics shapes
      _geomPoly = new GeomPoly(_verts);
      // FlxG.log.add("_______________________________");
      // FlxG.log.add("_geomPoly ["+_geomPoly.size()+"] area:"+_geomPoly.area());
      // FlxG.log.add("_geomPoly.isDegenerate() = "+_geomPoly.isDegenerate());

      _geomPolyList = new GeomPolyList();

      if(!_geomPoly.isConvex())
      {
        _geomPolyList = _geomPoly.convexDecomposition();
        // FlxG.log.add("DECOMPOSE");
        // FlxG.log.add("_geomPolyList.length = "+_geomPolyList.length);
      }else{
        _geomPolyList.add(_geomPoly);
      }

      for(g in _geomPolyList)
      {
        // FlxG.log.add("loop - g: "+g.toString());
        _poly = new Polygon(g);

        _body = new Body(BodyType.STATIC, new Vec2(o.x, o.y));
        _body.shapes.add(_poly);
        _body.space = FlxNapeState.space;

        // _napeSprite = new FlxNapeSprite(o.x, o.y);
        // _napeSprite.addPremadeBody(_body);
      }


      // Draw all lines
      // FlxG.log.add("#### DRAW ALL LINES");
      var bounds:AABB = _geomPoly.bounds();
      var polySprite:FlxSprite = new FlxSprite(bounds.x + o.x - _linesOffset, bounds.y + o.y - _linesOffset);
      var sw:Int = Std.int(bounds.max.x - bounds.min.x)+_linesOffset*2;
      var sh:Int = Std.int(bounds.max.y - bounds.min.y)+_linesOffset*2;

      polySprite.makeGraphic(sw, sh, 0x00000000);
      polySprite.antialiasing = false;

      for(i in 0..._verts.length)
      {
        _vec = _verts[i];
        if(i >= _verts.length-1){
          _vec2 = _verts[0];
        }else{
          _vec2 = _verts[i+1];
        }

        FlxSpriteUtil.drawLine(polySprite,
          _vec.x-vminx+_linesOffset, _vec.y-vminy+_linesOffset,
          _vec2.x-vminx+_linesOffset, _vec2.y-vminy+_linesOffset,
          {thickness: 3, color: 0xFF66FF66},
          {smoothing: false}
        );
      }


      _linemap.add(polySprite);

    }
    // FlxG.log.add("Out Level initWorld()");
  }


  /**
   * Initialize volumes like playerStart, enemySpawn, deathVolume etc.
   */
  private function initVolumes():Void
  {
    _volumesGroup = _map.getObjectGroup("volumes");

    for(o in _worldGroup.objects)
    {
      if(o.name == "playerStart")
      {
        _spawnPoint.x = o.x - Std.int(o.width/2);
        _spawnPoint.y = o.y - Std.int(o.height/2);
      }
    }
  }
  

}

// interface ILevel 
// {

//   public function get_polymap():FlxTypedGroup<FlxNapeSprite>;
//   public function get_linemap():FlxTypedGroup<FlxSprite>;
//   public function get_spawnPoint():FlxPoint;

// }

