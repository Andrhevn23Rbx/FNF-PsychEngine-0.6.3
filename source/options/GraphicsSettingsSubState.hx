package options;

import objects.Character;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.FlxG;

class GraphicsSettingsSubState extends BaseOptionsMenu
{
	var antialiasingOption:Int;
	var boyfriend:Character = null;

	var limitCount:Option;

	public function new()
	{
		#if DISCORD_ALLOWED
		DiscordClient.changePresence("Graphics/Performance Settings Menu", null);
		#end

		title = 'Graphics & Performance';
		rpcTitle = 'Graphics Settings Menu';

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		boyfriend.animation.finishCallback = function (_:String) boyfriend.dance();
		boyfriend.visible = false;

		// === Graphics ===
		addOption(new Option('Low Quality',
			'Disables some background details.\nImproves performance.',
			'lowQuality',
			OptionType.BOOL));

		var aaOption = new Option('Anti-Aliasing',
			'Disables anti-aliasing for better performance.',
			'antialiasing',
			OptionType.BOOL);
		aaOption.onChange = onChangeAntiAliasing;
		addOption(aaOption);
		antialiasingOption = optionsArray.length - 1;

		addOption(new Option('Shaders',
			"Disables shader effects (may improve performance).",
			'shaders',
			OptionType.BOOL));

		addOption(new Option('GPU Caching',
			"Allows GPU to cache textures.\nHelpful on low RAM systems.",
			'cacheOnGPU',
			OptionType.BOOL));

		#if !html5
		var frameOpt = new Option('Framerate',
			'Set the maximum framerate.',
			'framerate',
			OptionType.INT);
		frameOpt.minValue = 60;
		frameOpt.maxValue = 240;
		frameOpt.changeValue = 1;
		frameOpt.displayFormat = '%v FPS';
		frameOpt.defaultValue = 60;
		frameOpt.onChange = onChangeFramerate;
		addOption(frameOpt);
		#end

		// === Performance Optimizations ===

		addOption(new Option('Show Notes',
			"Uncheck to skip notes visually.\nBoosts performance. Forces botplay.",
			'showNotes',
			OptionType.BOOL));

		addOption(new Option('Show Notes again after Skip',
			"Attempts to restore notes partway through.",
			'showAfter',
			OptionType.BOOL));

		addOption(new Option('Keep Notes in Screen',
			"Force notes to render longer.\nMay hurt or help performance depending on count.",
			'keepNotes',
			OptionType.BOOL));

		addOption(new Option('Sort Notes',
			"Controls when note sorting happens.\nMore sorting = more lag.",
			'sortNotes',
			OptionType.STRING, [
				'Never',
				'After Note Spawned',
				'After Note Processed',
				'After Note Finalized',
				'Reversed',
				'Chaotic',
				'Random',
				'Shuffle'
			]));

		addOption(new Option('Faster Sort',
			"Sort only visible notes (recommended).",
			'fastSort',
			OptionType.BOOL));

		addOption(new Option('Better Recycling',
			"Reuses note memory to reduce lag spikes.",
			'betterRecycle',
			OptionType.BOOL));

		var limitOpt = new Option('Max Notes Shown:',
			"Set a cap to notes shown.\nSet to 0 for unlimited.",
			'limitNotes',
			OptionType.INT);
		limitOpt.minValue = 0;
		limitOpt.maxValue = 99999;
		limitOpt.changeValue = 1;
		limitOpt.defaultValue = 0;
		limitOpt.displayFormat = '%v';
		limitOpt.onChange = onChangeLimitCount;
		limitCount = limitOpt;
		addOption(limitOpt);

		addOption(new Option('Process Notes before Spawning',
			"Processes notes early (faster gameplay).",
			'processFirst',
			OptionType.BOOL));

		addOption(new Option('Skip Process for Spawned Note',
			"Skips heavy logic during spawn if possible.",
			'skipSpawnNote',
			OptionType.BOOL));

		addOption(new Option('Break on Time Limit Exceeded',
			"Ends note spawn loop early if it's lagging.",
			'breakTimeLimit',
			OptionType.BOOL));

		addOption(new Option('Optimize Process for Spawned Note',
			"Hit detection runs immediately.",
			'optimizeSpawnNote',
			OptionType.BOOL));

		addOption(new Option('Disable GC (Experimental)',
			"Turns off memory cleanup (OpenFL).\nMore stable FPS, but may use more RAM.",
			'disableGC',
			OptionType.BOOL));

		addOption(new Option('No Botplay Lag',
			"Reduces lag when bot is active.",
			'noBotLag',
			OptionType.BOOL));

		addOption(new Option('Light Bot Strums',
			"Removes animations for bot strums.",
			'botLightStrum',
			OptionType.BOOL));

		addOption(new Option('Light Player Strums',
			"Removes animations for player strums.",
			'playerLightStrum',
			OptionType.BOOL));

		addOption(new Option('Light Opponent Strums',
			"Removes animations for opponent strums.",
			'oppoLightStrum',
			OptionType.BOOL));

		addOption(new Option('Disable Combo Limits',
			"Disables FNF combo cap to avoid edge cases.",
			'deactivateComboLimit',
			OptionType.BOOL));

		addOption(new Option('noHitFuncs',
			"Skips heavy note hit logic. Useful for joke mods.",
			'noHitFuncs',
			OptionType.BOOL));

		addOption(new Option('noSpawnFunc',
			"Skips heavy note spawn logic. Use if very laggy.",
			'noSpawnFunc',
			OptionType.BOOL));

		super();
		insert(1, boyfriend);
	}

	override function changeSelection(change:Int = 0)
	{
		super.changeSelection(change);
		boyfriend.visible = (curSelected == antialiasingOption);
	}

	function onChangeAntiAliasing()
	{
		for (member in members)
		{
			var spr:FlxSprite = cast member;
			if (spr != null && !(spr is FlxText))
			{
				spr.antialiasing = ClientPrefs.data.antialiasing;
			}
		}
	}

	function onChangeFramerate()
	{
		var fps = ClientPrefs.data.framerate;
		FlxG.updateFramerate = fps;
		FlxG.drawFramerate = fps;
	}

	function onChangeLimitCount()
	{
		limitCount.scrollSpeed = 50;
	}
}
