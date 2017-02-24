package;

import haxe.io.Bytes;
import haxe.crypto.Base64;
import haxe.Timer;
import js.html.CanvasElement;
import statistics.Stats;

import file.load.FileLoad;
import statistics.TraceTimer;

import js.Browser;
import js.html.ImageElement;

import pixi.core.sprites.Sprite;
import pixi.core.textures.BaseRenderTexture;
import pixi.core.textures.RenderTexture;
import pixi.core.textures.BaseTexture;
import pixi.core.textures.Texture;
import pixi.core.math.shapes.Rectangle;
import pixi.tilemap.CompositeRectTileLayer;
import pixi.plugins.app.Application;

/**
 * Test of PixiJS
 * 
 * Tilemap and Rendertexture experiment in WebGL
 */
class Main extends Application
{
  var stats = new Stats();
  
  // Images
  var image1:ImageElement;
  var image2:ImageElement;
  
  // Sprites
  var sprite1:Sprite;
  var sprite2:Sprite;
  
  // Tiles
  var cv:CanvasElement;
  var texture:RenderTexture;
  var tilemap:CompositeRectTileLayer;
  
  // Flag to add tiles
  var addTiles:Bool = false;
  
  // Init
	public function new() 
  {
    super();
    
    // Stage properties
    position = Application.POSITION_FIXED;
		width = Browser.window.innerWidth;
		height = Browser.window.innerHeight;
		backgroundColor = 0x006666;
		transparent = false;
		antialias = false;
    pixelRatio = 1;
		autoResize = true;
		onUpdate = enterframe;
    
    // Start stage
    super.start();
    
    // Activate statistics
    TraceTimer.activate();
    
    // Load / Decode image to texture
    loadImage("./assets/electric_piano.png", function(image)
    {
      trace("Image1 loaded!");
      image1 = image;
      
      loadImage("./assets/electric_snare.png", function(image)
      {
        trace("Image2 loaded!");
        image2 = image;
        
        // We can now experiment properly!
        begin();
      });
    });
    
    trace("TEST");
  }
  
  // Begin experiment
  function begin()
  {
    // Add sprite for fun
    sprite1 = new Sprite( new Texture(new BaseTexture(image1)) );
		sprite1.position.set(0, 0);
    stage.addChild( sprite1 );
    
    sprite2 = new Sprite( new Texture(new BaseTexture(image2)) );
		sprite2.position.set(0, 30);
    stage.addChild( sprite2 );
    
    // Create Canvas
    /*cv = cast(Browser.document.createElement('canvas'), CanvasElement);
    cv.width = 2048;
    cv.width = 2048;
    
    var context = cv.getContext2d();*/
    
    // Test Render Texture
    texture = RenderTexture.create( 2048, 2048 );
    
    // Test adding new tile inside texture after a little while
    var timer = new Timer(1000);
    timer.run = function()
    {
      renderer.render(sprite1, texture, false);
      renderer.render(sprite2, texture, false);
      
      timer.stop();
      
      addTiles = true;
    };
    
    // Test sprite
    var sprite3 = new Sprite( new Texture(texture.baseTexture, new Rectangle(0, 0, 15, 15)) );
    sprite3.position.set(0, 60);
    stage.addChild( sprite3 );
    
    // Test adding a lot of sprite
    var texture1 = new Texture(texture.baseTexture, new Rectangle(0, 0, 230, 230));
    var texture2 = new Texture(texture.baseTexture, new Rectangle(0, 30, 230, 230));
    
    for ( i in 0...1200 )
    {
      var sprite = new Sprite( Std.int(Math.random() * 2.0) == 0 ? texture1 : texture2 );
      sprite.position.set( Math.random() * width, Math.random() * height );
      
      stage.addChild( sprite );
    }
    
    // Test adding new tile inside texture after a little while
    /*var timer = new Timer(1000);
    timer.run = function()
    {
      renderer.render(sprite1, texture, false);
      
      timer.stop();
      
      //context.drawImage( image1, 0, 0, 15, 15, 0, 0, 15, 15 );
      
      randomTiles();
      addTiles = true;
    };
    
    // Create Tilemap
    tilemap = new CompositeRectTileLayer();
    tilemap.initialize( 0, [new Texture(texture.baseTexture)], false ); // RenderTexture
    //tilemap.initialize( 0, [new Texture(new BaseTexture(image1))], false ); // "Normal" texture
    stage.addChild(tilemap);
    
    //randomTiles();*/
  }
  
  // Random tiles for tests
  function randomTiles()
  {
    tilemap.clear();
    
    //trace(Std.int(Math.random() * 2.0) == 0);
    
    for ( i in 0...1000 )
    {
      tilemap.addRect( 0, 0, Std.int(Math.random() * 2.0) == 0 ? 0 : 30, Math.random() * width, Math.random() * height, 233, 233 );
    }
  }
  
  // Enterframe
  var i = 0;
  function enterframe( e:Float ) 
  {
    if ( addTiles )
    {
      for ( child in stage.children )
      {
        child.position.set( Math.random() * width, Math.random() * height );
      }
    }
	}
  
  // Load Bytes then as a Base64 Image
  function loadImage( url:String, handler:ImageElement->Void )
  {
    // Single Bytes Loader
    FileLoad.loadBytes(
    {
      url: url,
      complete: function(bytes)
      {
        trace("Downloading complete", bytes.length);
        
        // Load Base64 Image
        loadBytesImage( bytes, handler );
      },
      progress: function(percent)
      {
        trace("Progress:", percent);
      },
      error: function(error)
      {
        trace("Error", error);
      }
    });
  }
  
  // Load as a base64 image
  function loadBytesImage( bytes:Bytes, handler:ImageElement->Void )
  {
    trace("");
    var data = "data:image;base64," + Base64.encode(bytes);
    var image = cast(Browser.document.createElement('img'), ImageElement);
    
    image.onload = function()
    {
      handler( image );
    };
    
    image.onerror = function()
    {
      trace("Error image base64");
    };
    
    image.src = data;
  }
  
  // Main entry point
	static function main() 
	{
		new Main();
	}
}