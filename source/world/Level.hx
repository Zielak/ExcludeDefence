
package world;

import flixel.FlxG;
import flixel.addons.editors.tiled.*;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.addons.nape.FlxNapeSprite;
import flixel.addons.nape.FlxNapeState;
import flixel.group.FlxTypedGroup;

import nape.geom.AABB;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.geom.Vec2;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;

class Level implements ILevel
{

  private var _map:TiledMap;
  private var _tilemap:FlxNapeTilemap;
  private var _polymap:FlxTypedGroup<FlxNapeSprite>;
  public var polymap(get_polymap, null):FlxTypedGroup<FlxNapeSprite>;
  public function get_polymap():FlxTypedGroup<FlxNapeSprite>{
    return _polymap;
  }
  

  private var _gravity:Vec2;


  private var _napeSprite:FlxNapeSprite;
  private var _body:Body;
  private var _poly:Polygon;
  private var _geomPoly:GeomPoly;
  private var _geomPolyList:GeomPolyList;
  private var _verts:Array<Vec2>;
  private var _vec:Vec2 = new Vec2(0,0);

  /**
   * Static polygons layer that player can move on
   */
  private var _worldGroup:TiledObjectGroup;


  public function new():Void
  {
    FlxG.log.add("In Level new()");
    _map = new TiledMap(AssetPaths.protolvl_001__tmx);
    _polymap = new FlxTypedGroup<FlxNapeSprite>();

    // TODO: Get gravity from Tiled map config
    // FlxNapeState.space.gravity = new Vec2(0, 600);

    initWorld();

    FlxG.log.add("_polymap: "+_polymap.toString());


    FlxG.log.add("Out Level new()");
  }
  
  private function initWorld():Void
  {
    FlxG.log.add("In Level initWorld()");
    _worldGroup = _map.getObjectGroup("world");

    for(o in _worldGroup.objects)
    {

      // FlxG.log.add("loop - object with "+ o.points.length+" points.");
      _verts = new Array<Vec2>();

      for(v in o.points)
      {
        _vec = new Vec2(v.x, v.y);
        // if(_vec.x == 0 && _vec.y == 0) continue;

        FlxG.log.add("loop - vec: "+_vec.toString());
        _verts.push(_vec);
      }

      // _vec.x = o.points[0].x;
      // _vec.y = o.points[0].y;
      // _verts.push(_vec);

      _geomPoly = new GeomPoly(_verts);
      FlxG.log.add("_______________________________");
      FlxG.log.add("_geomPoly ["+_geomPoly.size()+"] area:"+_geomPoly.area());
      FlxG.log.add("_geomPoly.isDegenerate() = "+_geomPoly.isDegenerate());

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

        _napeSprite = new FlxNapeSprite(o.x, o.y);
        _napeSprite.addPremadeBody(_body);

        _polymap.add(_napeSprite);

      }

    }
    // FlxG.log.add("Out Level initWorld()");
  }




  

}

interface ILevel 
{

  public function get_polymap():FlxTypedGroup<FlxNapeSprite>;

}

