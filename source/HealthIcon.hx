package;

import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import openfl.utils.Assets as OpenFlAssets;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	private var isPlayer:Bool = false;
	private var char:String = '';

	public var initialWidth:Float = 0;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	private var iconOffsets:Array<Float> = [0, 0];

	public function changeIcon(char:String)
	{
		if (this.char != char)
		{
			#if STORAGE_ACCESS
			if (SaveData.get(ALLOW_FILESYS))
			{
				var extIcon = features.StorageAccess.getIcon(char);
				if (extIcon != null)
					setupExt(extIcon);
				else
					setupFromAssets(char);
			}
			else
				setupFromAssets(char);
			#else
			setupFromAssets(char);
			#end

			initialWidth = width;
			animation.add(char, [0, 1], 0, false, isPlayer);
			animation.play(char);
			this.char = char;

			antialiasing = SaveData.get(ANTIALIASING);
			if (char.endsWith('-pixel'))
			{
				antialiasing = false;
			}
		}
	}

	override function updateHitbox()
	{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
	}

	public function getCharacter():String
	{
		return char;
	}

	private function setupFromAssets(char:String)
	{
		var name:String = 'icons/' + char;
		if (!Paths.fileExists('images/' + name + '.png', IMAGE))
			name = 'icons/icon-' + char; // Older versions of psych engine's support
		if (!Paths.fileExists('images/' + name + '.png', IMAGE))
			name = 'icons/icon-face'; // Prevents crash from missing icon
		var file:Dynamic = Paths.image(name);

		loadGraphic(file); // Load stupidly first for getting the file size
		loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); // Then load it fr
		iconOffsets[0] = (width - 150) / 2;
		iconOffsets[1] = (width - 150) / 2;
		updateHitbox();
	}

	private function setupExt(graph:FlxGraphic)
	{
		loadGraphic(graph);
		loadGraphic(graph, true, Math.floor(width / 2), Math.floor(height));
		iconOffsets[0] = (width - 150) / 2;
		iconOffsets[1] = (width - 150) / 2;
		updateHitbox();
	}
}
