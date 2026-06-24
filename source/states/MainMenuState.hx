package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import backend.UpdateManager;
import objects.CheckboxThingie;
import objects.UpdateNotificationBar;
import objects.UpToDateNotification;
import flixel.ui.FlxButton;

enum MainMenuColumn {
	LEFT;
	CENTER;
	RIGHT;
}

class MainMenuState extends MusicBeatState
{
	public static var internetFavsVersion:String = '4.0'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	var allowMouse:Bool = true; //Turn this off to block mouse movement in menus

	var menuItems:FlxTypedGroup<FlxSprite>;
	var leftItem:FlxSprite;
	var rightItem:FlxSprite;

	//Centered/Text options
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		'credits'
	];

	var leftOption:String = #if ACHIEVEMENTS_ALLOWED 'achievements' #else null #end;
	var rightOption:String = 'options';

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var updateNotificationBar:UpdateNotificationBar;
	var hasCheckedUpdates:Bool = false;

	override function create()
	{
		super.create();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Main Menu", null);
		#end

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0.25;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.antialiasing = ClientPrefs.data.antialiasing;
		magenta.scrollFactor.set(0, yScroll);
		magenta.setGraphicSize(Std.int(magenta.width * 1.175));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (num => option in optionShit)
		{
			var item:FlxSprite = createMenuItem(option, 0, (num * 140) + 90);
			item.y += (4 - optionShit.length) * 70; // Offsets for when you have anything other than 4 items
			item.screenCenter(X);
		}

		if (leftOption != null)
			leftItem = createMenuItem(leftOption, 60, 490);
		if (rightOption != null)
		{
			rightItem = createMenuItem(rightOption, FlxG.width - 60, 490);
			rightItem.x -= rightItem.width;
		}
		var ifvVer:FlxText = new FlxText(12, FlxG.height - 44, 0, "Internet Favorites Engine v" + internetFavsVersion, 12);
		ifvVer.scrollFactor.set();
		ifvVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(ifvVer);
		var fnfVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		fnfVer.scrollFactor.set();
		fnfVer.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(fnfVer);
		changeItem();
		
		// Check for updates if enabled in settings
		if(ClientPrefs.data.checkForUpdates && !hasCheckedUpdates)
		{
			hasCheckedUpdates = true;
			checkForUpdatesAsync();
		}

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();

		FlxG.camera.follow(camFollow, null, 0.15);
	}

	function createMenuItem(name:String, x:Float, y:Float):FlxSprite
	{
		var menuItem:FlxSprite = new FlxSprite(x, y);
		menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_$name');
		menuItem.animation.addByPrefix('idle', '$name idle', 24, true);
		menuItem.animation.addByPrefix('selected', '$name selected', 24, true);
		menuItem.animation.play('idle');
		menuItem.updateHitbox();
		
		menuItem.antialiasing = ClientPrefs.data.antialiasing;
		menuItem.scrollFactor.set();
		menuItems.add(menuItem);
		return menuItem;
	}

	var selectedSomethin:Bool = false;

	var timeNotMoving:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var allowMouse:Bool = allowMouse;
			if (allowMouse && ((FlxG.mouse.deltaScreenX != 0 && FlxG.mouse.deltaScreenY != 0) || FlxG.mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				allowMouse = false;
				FlxG.mouse.visible = true;
				timeNotMoving = 0;

				var selectedItem:FlxSprite;
				switch(curColumn)
				{
					case CENTER:
						selectedItem = menuItems.members[curSelected];
					case LEFT:
						selectedItem = leftItem;
					case RIGHT:
						selectedItem = rightItem;
				}

				if(leftItem != null && FlxG.mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && FlxG.mouse.overlaps(rightItem))
				{
					allowMouse = true;
					if(selectedItem != rightItem)
					{
						curColumn = RIGHT;
						changeItem();
					}
				}
				else
				{
					var dist:Float = -1;
					var distItem:Int = -1;
					for (i in 0...optionShit.length)
					{
						var memb:FlxSprite = menuItems.members[i];
						if(FlxG.mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - FlxG.mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - FlxG.mouse.screenY, 2));
							if (dist < 0 || distance < dist)
							{
								dist = distance;
								distItem = i;
								allowMouse = true;
							}
						}
					}

					if(distItem != -1 && selectedItem != menuItems.members[distItem])
					{
						curColumn = CENTER;
						curSelected = distItem;
						changeItem();
					}
				}
			}
			else
			{
				timeNotMoving += elapsed;
				if(timeNotMoving > 2) FlxG.mouse.visible = false;
			}

			switch(curColumn)
			{
				case CENTER:
					if(controls.UI_LEFT_P && leftOption != null)
					{
						curColumn = LEFT;
						changeItem();
					}
					else if(controls.UI_RIGHT_P && rightOption != null)
					{
						curColumn = RIGHT;
						changeItem();
					}

				case LEFT:
					if(controls.UI_RIGHT_P)
					{
						curColumn = CENTER;
						changeItem();
					}

				case RIGHT:
					if(controls.UI_LEFT_P)
					{
						curColumn = CENTER;
						changeItem();
					}
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			var mouseBlockedByOverlay:Bool = isMouseBlockedByOverlay();
			if (subState == null && (controls.ACCEPT || (FlxG.mouse.justPressed && allowMouse && !mouseBlockedByOverlay)))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					FlxG.mouse.visible = false;

					if (ClientPrefs.data.flashing)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					var item:FlxSprite;
					var option:String;
					switch(curColumn)
					{
						case CENTER:
							option = optionShit[curSelected];
							item = menuItems.members[curSelected];

						case LEFT:
							option = leftOption;
							item = leftItem;

						case RIGHT:
							option = rightOption;
							item = rightItem;
					}

					FlxFlicker.flicker(item, 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (option)
						{
							case 'story_mode':
								MusicBeatState.switchState(new StoryMenuState());
							case 'freeplay':
								MusicBeatState.switchState(new FreeplayState());

							#if MODS_ALLOWED
							case 'mods':
								MusicBeatState.switchState(new ModsMenuState());
							#end

							#if ACHIEVEMENTS_ALLOWED
							case 'achievements':
								MusicBeatState.switchState(new AchievementsMenuState());
							#end

							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						case 'donate':
							CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
							selectedSomethin = false;
							item.visible = true;
						default:
							trace('Menu Item ${option} doesn\'t do anything');
							selectedSomethin = false;
							item.visible = true;
						}
					});
					
					for (memb in menuItems)
					{
						if(memb == item)
							continue;

						FlxTween.tween(memb, {alpha: 0}, 0.4, {ease: FlxEase.quadOut});
					}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				FlxG.mouse.visible = false;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0)
	{
		if(change != 0) curColumn = CENTER;
		curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);
		FlxG.sound.play(Paths.sound('scrollMenu'));

		for (item in menuItems)
		{
			item.animation.play('idle');
			item.centerOffsets();
		}

		var selectedItem:FlxSprite;
		switch(curColumn)
		{
			case CENTER:
				selectedItem = menuItems.members[curSelected];
			case LEFT:
				selectedItem = leftItem;
			case RIGHT:
				selectedItem = rightItem;
		}
		selectedItem.animation.play('selected');
		selectedItem.centerOffsets();
		camFollow.y = selectedItem.getGraphicMidpoint().y;
	}
	
	function isMouseBlockedByOverlay():Bool
	{
		if (subState != null)
		{
			if (subState is UpdateOptionsSubState)
				return cast(subState, UpdateOptionsSubState).shouldBlockMouse();
			if (subState is UpdateProgressSubState)
				return cast(subState, UpdateProgressSubState).shouldBlockMouse();
		}

		if (updateNotificationBar != null && updateNotificationBar.shouldBlockMouse())
			return true;

		return false;
	}

	function checkForUpdatesAsync():Void
	{
		// Initialize versions first
		UpdateManager.initializeVersions();
		UpdateManager.checkForUpdates(onUpdateCheckComplete);
	}
	
	function onUpdateCheckComplete(updateAvailable:Bool, engineAvail:Bool, modAvail:Bool, error:String):Void
	{
		if(error.length > 0)
		{
			trace('Update check failed: $error');
			return;
		}

		if(updateAvailable && updateNotificationBar == null)
		{
			updateNotificationBar = new UpdateNotificationBar(engineAvail, modAvail, 
				'${UpdateManager.CURRENT_ENGINE_VERSION}',
				'${UpdateManager.CURRENT_MOD_VERSION}',
				onUpdatePressed,
				onUpdateDismissed);
			add(updateNotificationBar);
		}
		else
		{
			// Show up-to-date notification
			var upToDateNotif = new UpToDateNotification(
				'${UpdateManager.CURRENT_ENGINE_VERSION}',
				'${UpdateManager.CURRENT_MOD_VERSION}');
			add(upToDateNotif);
		}
	}
	
	function onUpdatePressed():Void
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		if(updateNotificationBar != null)
			updateNotificationBar.visible = false;
		openSubState(new UpdateOptionsSubState(onUpdateSelectionComplete));
	}
	
	function onUpdateSelectionComplete(includeMod:Bool):Void
	{
		openSubState(new UpdateProgressSubState(onUpdateComplete));
		UpdateManager.downloadAndApplyUpdates(onUpdateComplete, includeMod);
	}
	
	function onUpdateDismissed():Void
	{
		// User dismissed update notification - do nothing
	}
	
	function onUpdateComplete(success:Bool, message:String):Void
	{
		if(success && UpdateManager.pendingUpdate)
		{
			// Show message and restart
			var popup = new flixel.util.FlxSignal();
			FlxG.sound.play(Paths.sound('confirmMenu'));
			
			// Restart the game
			UpdateManager.restartGame();
		}
		else
		{
			// Show error message
			trace('Update failed: $message');
			if(updateNotificationBar != null)
				updateNotificationBar.visible = true;
		}
	}
}

class UpdateOptionsSubState extends MusicBeatSubstate
{
	var onComplete:Bool->Void;
	var includeModCheckbox:CheckboxThingie;
	var toggleArea:FlxSprite;
	var includeMod:Bool = false;

	public function new(onComplete:Bool->Void)
	{
		super();
		this.onComplete = onComplete;
	}

	override function create()
	{
		super.create();
		var bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.alpha = 0.95;
		bg.setGraphicSize(680, 260);
		bg.updateHitbox();
		bg.x = Std.int((FlxG.width - bg.width) / 2);
		bg.y = 120;
		bg.scrollFactor.set(0, 0);
		add(bg);

		var border = new FlxSprite(bg.x - 4, bg.y - 4).makeGraphic(Std.int(bg.width) + 8, Std.int(bg.height) + 8, 0xFFFFFFFF);
		border.alpha = 0.8;
		border.scrollFactor.set(0, 0);
		add(border);

		var title = new FlxText(0, bg.y + 20, 620, 'Update options', 24);
		title.alignment = CENTER;
		title.x = bg.x + 20;
		title.scrollFactor.set(0, 0);
		add(title);

		var desc = new FlxText(0, title.y + 46, 620, 'Install the latest engine update?\nYou can also include the Internet Favorites mod package if you want the newest mod folder.', 18);
		desc.alignment = CENTER;
		desc.x = bg.x + 30;
		desc.scrollFactor.set(0, 0);
		add(desc);

		var label = new FlxText(0, desc.y + 74, 0, 'Include mod update', 20);
		label.x = bg.x + 180;
		label.scrollFactor.set(0, 0);
		add(label);

		includeModCheckbox = new CheckboxThingie(bg.x + 420, label.y - 4, false);
		includeModCheckbox.scale.set(1.35, 1.35);
		includeModCheckbox.updateHitbox();
		includeModCheckbox.scrollFactor.set(0, 0);
		add(includeModCheckbox);

		toggleArea = new FlxSprite(bg.x + 360, label.y - 12);
		toggleArea.makeGraphic(150, 70, 0x11FFFFFF);
		toggleArea.scrollFactor.set(0, 0);
		add(toggleArea);

		var confirm = new FlxButton(0, bg.y + bg.height - 44, 'Start update', function() {
			includeMod = includeModCheckbox.daValue;
			onComplete(includeMod);
			close();
		});
		confirm.x = bg.x + 170;
		confirm.scrollFactor.set(0, 0);
		add(confirm);

		var cancel = new FlxButton(0, bg.y + bg.height - 44, 'Cancel', close);
		cancel.x = bg.x + 350;
		cancel.scrollFactor.set(0, 0);
		add(cancel);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed && includeModCheckbox != null)
		{
			if (FlxG.mouse.overlaps(includeModCheckbox) || (toggleArea != null && FlxG.mouse.overlaps(toggleArea)))
				includeModCheckbox.daValue = !includeModCheckbox.daValue;
		}
	}

	public function shouldBlockMouse():Bool
	{
		for (member in members)
		{
			if (member != null && member.visible && Std.isOfType(member, FlxSprite))
			{
				var sprite:FlxSprite = cast member;
				if (FlxG.mouse.overlaps(sprite))
					return true;
			}
		}
		return false;
	}
}

class UpdateProgressSubState extends MusicBeatSubstate
{
	var resultCallback:Bool->String->Void;
	var statusText:FlxText;
	var progressFill:FlxSprite;
	var progressBg:FlxSprite;
	var detailText:FlxText;

	public function new(resultCallback:Bool->String->Void)
	{
		super();
		this.resultCallback = resultCallback;
	}

	override function create()
	{
		super.create();
		var bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.alpha = 0.95;
		bg.setGraphicSize(660, 240);
		bg.updateHitbox();
		bg.x = Std.int((FlxG.width - bg.width) / 2);
		bg.y = 140;
		bg.scrollFactor.set(0, 0);
		add(bg);

		var title = new FlxText(0, bg.y + 24, 620, 'Updating game...', 26);
		title.alignment = CENTER;
		title.x = bg.x + 20;
		title.scrollFactor.set(0, 0);
		add(title);

		detailText = new FlxText(0, title.y + 44, 600, 'Please wait while the update downloads and applies in the background.', 18);
		detailText.alignment = CENTER;
		detailText.x = bg.x + 30;
		detailText.scrollFactor.set(0, 0);
		add(detailText);

		statusText = new FlxText(0, detailText.y + 60, 600, 'Preparing update...', 18);
		statusText.alignment = CENTER;
		statusText.x = bg.x + 30;
		statusText.scrollFactor.set(0, 0);
		add(statusText);

		progressBg = new FlxSprite(bg.x + 80, statusText.y + 44);
		progressBg.makeGraphic(500, 24, 0xFF222222);
		progressBg.scrollFactor.set(0, 0);
		add(progressBg);

		progressFill = new FlxSprite(progressBg.x + 2, progressBg.y + 2);
		progressFill.makeGraphic(1, 20, 0xFF00C8FF);
		progressFill.scrollFactor.set(0, 0);
		add(progressFill);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (UpdateManager.updateThreadFinished)
		{
			if (resultCallback != null)
				resultCallback(UpdateManager.updateThreadSuccessful, UpdateManager.updateThreadMessage);
			close();
			return;
		}

		if (statusText != null)
			statusText.text = UpdateManager.progressLabel + (UpdateManager.progressTotal > 0 ? ' (${UpdateManager.progressCurrent}/${UpdateManager.progressTotal})' : '');

		if (progressFill != null && progressBg != null)
		{
			var ratio:Float = Math.max(0, Math.min(1, UpdateManager.progressValue));
			progressFill.setGraphicSize(Std.int(496 * ratio), 20);
			progressFill.updateHitbox();
			progressFill.x = progressBg.x + 2;
			progressFill.y = progressBg.y + 2;
		}
	}

	public function shouldBlockMouse():Bool
	{
		for (member in members)
		{
			if (member != null && member.visible && Std.isOfType(member, FlxSprite))
			{
				var sprite:FlxSprite = cast member;
				if (FlxG.mouse.overlaps(sprite))
					return true;
			}
		}
		return false;
	}
}
