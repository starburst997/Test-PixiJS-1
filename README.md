# Test-PixiJS-1
Just doing some experiment on getting PixiJS with haxe up and running.

I needed a way to progressively add new image to a spritesheet and display tiles.

Found a bug with PixiJS-Tilemap when using RenderTexture and found a weird [fix](https://github.com/starburst997/pixi-tilemap/commit/b026f88d1c2272d0c55cbaa000d27502a5d98de4).

Not going to go with Tilemap, performance are worse than using plain Sprite.

I think I'm going to go with PixiJS when on development for JS target (and still keep OpenFL on production). Compile time are near instantaneous and I mostly just use tilemap/spritesheet nowdays...