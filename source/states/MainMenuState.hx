package states;

import flixel.FlxObject;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import backend.UpdateManager;
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
	public static var internetFavsVersion:String = '6.2.1'; // This is also used for Discord RPC
	public static var curSelected:Int = 0;
	public static var curColumn:MainMenuColumn = CENTER;
	public var allowMouse:Bool = true; //Turn this off to block mouse movement in menus

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
	var pendingUpdateCheckStart:Bool = false;

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
			pendingUpdateCheckStart = true;
			if(UpdateManager.isVersionInitializationReady())
				checkForUpdatesAsync();
			else
				UpdateManager.initializeVersionsAsync();
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

	public var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if(pendingUpdateCheckStart && UpdateManager.isVersionInitializationReady())
		{
			pendingUpdateCheckStart = false;
			var versionInitError:String = UpdateManager.getVersionInitializationError();
			if(versionInitError != null && versionInitError.length > 0)
				trace('Update version initialization failed: $versionInitError');
			checkForUpdatesAsync();
		}

		if (FlxG.sound.music != null && FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume = Math.min(FlxG.sound.music.volume + 0.5 * elapsed, 0.8);

		var mouse = FlxG.mouse;
		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			var mouseBlockedByOverlay:Bool = isMouseBlockedByOverlay();
			allowMouse = !mouseBlockedByOverlay;
			if (allowMouse && ((mouse.deltaScreenX != 0 && mouse.deltaScreenY != 0) || mouse.justPressed)) //FlxG.mouse.deltaScreenX/Y checks is more accurate than FlxG.mouse.justMoved
			{
				mouse.visible = true;

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

				if(leftItem != null && mouse.overlaps(leftItem))
				{
					allowMouse = true;
					if(selectedItem != leftItem)
					{
						curColumn = LEFT;
						changeItem();
					}
				}
				else if(rightItem != null && mouse.overlaps(rightItem))
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
						if(mouse.overlaps(memb))
						{
							var distance:Float = Math.sqrt(Math.pow(memb.getGraphicMidpoint().x - mouse.screenX, 2) + Math.pow(memb.getGraphicMidpoint().y - mouse.screenY, 2));
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
				mouse.visible = true;
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
				mouse.visible = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (subState == null && (controls.ACCEPT || (mouse.justPressed && allowMouse)))
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;
					mouse.visible = true;

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
				mouse.visible = true;
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
		// Version initialization is started before this and may complete asynchronously.
		if(!UpdateManager.isVersionInitializationReady())
		{
			UpdateManager.initializeVersionsAsync();
			pendingUpdateCheckStart = true;
			return;
		}
		UpdateManager.checkForUpdates(onUpdateCheckComplete);
	}
	
	function onUpdateCheckComplete(updateAvailable:Bool, engineAvail:Bool, modAvail:Bool, error:String):Void
	{
		if(error.length > 0)
		{
			trace('Update check failed: $error');
			return;
		}

		var shouldShowUpdateBanner = (engineAvail || (modAvail && UpdateManager.hasInternetFavoritesMod)) && (engineAvail || UpdateManager.hasInternetFavoritesMod);
		if(shouldShowUpdateBanner && updateNotificationBar == null)
		{
			updateNotificationBar = new UpdateNotificationBar(engineAvail, modAvail, UpdateManager.hasInternetFavoritesMod,
				'${UpdateManager.CURRENT_ENGINE_VERSION}',
				'${UpdateManager.CURRENT_MOD_VERSION}',
				'${UpdateManager.latestEngineVersionDisplay}',
				'${UpdateManager.latestModVersionDisplay}',
				onUpdatePressed,
				onUpdateDismissed);
			add(updateNotificationBar);
		}
		else if(updateNotificationBar == null)
		{
			// Show up-to-date notification only when there is nothing to update
			var upToDateNotif = new UpToDateNotification(
				'${UpdateManager.CURRENT_ENGINE_VERSION}',
				'${UpdateManager.CURRENT_MOD_VERSION}');
			add(upToDateNotif);
		}
	}
	
	function onUpdatePressed():Void
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		selectedSomethin = false;
		allowMouse = true;
		var mouse = FlxG.mouse;
		mouse.visible = true;
		setUpdateNotificationVisible(false);

		if (subState == null)
		{
			openSubState(new UpdateOptionsSubState(function(includeMod:Bool)
			{
				UpdateManager.downloadAndApplyUpdates(onUpdateComplete, includeMod);
				openSubState(new UpdateProgressSubState(onUpdateComplete, includeMod));
			}, function()
			{
				if (UpdateManager.engineUpdateAvailable && UpdateManager.modUpdateAvailable)
				{
					openSubState(new UpdateOptionsSubState(function(modInclude:Bool)
					{
						if (modInclude)
						{
							UpdateManager.downloadAndApplyUpdates(onUpdateComplete, true);
							openSubState(new UpdateProgressSubState(onUpdateComplete, true));
						}
						else
						{
							setUpdateNotificationVisible(true);
						}
					}, null, 'mod'));
				}
			}, 'engine'));
		}
	}

	public function setUpdateNotificationVisible(visible:Bool):Void
	{
		if (updateNotificationBar != null)
			updateNotificationBar.visible = visible;
	}
	
	function onUpdateDismissed():Void
	{
		// User dismissed update notification - do nothing
	}
	
	function onUpdateComplete(success:Bool, message:String):Void
	{
		if(success && UpdateManager.pendingUpdate)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			if(UpdateManager.updateReadyToApply)
			{
				trace('Update staged; waiting for restart confirmation.');
			}
			else if(UpdateManager.postCloseInstallPending)
			{
				trace('Update files prepared for post-close install; exiting to apply them.');
				UpdateManager.exitForPostCloseInstall();
			}
			else
			{
				trace('Restarting game to apply update.');
				UpdateManager.restartGame();
			}
		}
		else
		{
			trace('Update failed: $message');
			setUpdateNotificationVisible(true);
		}
	}
}

class UpdateOptionsSubState extends MusicBeatSubstate
{
	var onComplete:Bool->Void;
	var onSkip:Void->Void;
	var confirmationBg:FlxSprite;
	var updateButton:FlxButton;
	var laterButton:FlxButton;
	var changelogLinkText:FlxText;
	var includeMod:Bool = false;
	var startUpdateCallback:Void->Void;
	var releaseUrl:String = '';
	var promptKind:String = 'engine';

	public function new(onComplete:Bool->Void, ?onSkip:Void->Void, ?promptKind:String)
	{
		super();
		this.onComplete = onComplete;
		this.onSkip = onSkip;
		if(promptKind != null && promptKind.length > 0) this.promptKind = promptKind;
	}

	override function create()
	{
		super.create();
		confirmationBg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		confirmationBg.alpha = 0.95;
		confirmationBg.setGraphicSize(680, 260);
		confirmationBg.updateHitbox();
		confirmationBg.x = Std.int((FlxG.width - confirmationBg.width) / 2);
		confirmationBg.y = 120;
		confirmationBg.scrollFactor.set(0, 0);
		add(confirmationBg);

		var border = new FlxSprite(confirmationBg.x - 4, confirmationBg.y - 4).makeGraphic(Std.int(confirmationBg.width) + 8, Std.int(confirmationBg.height) + 8, 0xFF111111);
		border.alpha = 0.95;
		border.scrollFactor.set(0, 0);
		add(border);

		var title = new FlxText(0, confirmationBg.y + 20, 620, 'Update options', 24);
		title.alignment = CENTER;
		title.x = confirmationBg.x + 20;
		title.scrollFactor.set(0, 0);
		add(title);

		var isModPrompt = promptKind == 'mod';
		var descText = 'Nothing to update.';
		if(isModPrompt) {
			descText = 'A newer Internet Favorites mod version is available.\nDo you want to install the mod update?';
		} else if(UpdateManager.pendingModUpdatePrompt && UpdateManager.updateReadyToApply) {
			descText = 'The engine update is ready.\nInstall the mod update now or later?';
		} else if(UpdateManager.engineUpdateAvailable && UpdateManager.modUpdateAvailable) {
			descText = 'The engine update will be installed first.\nAfter that, you can install the mod update now or later.';
		} else if(UpdateManager.engineUpdateAvailable) {
			descText = 'Install the latest engine update?';
		} else if(UpdateManager.modUpdateAvailable) {
			descText = 'A newer Internet Favorites mod version is available.\nDo you want to install the mod update?';
		}
		var desc = new FlxText(0, title.y + 46, 620, descText, 18);
		desc.alignment = CENTER;
		desc.x = confirmationBg.x + 30;
		desc.scrollFactor.set(0, 0);
		add(desc);

		var selectedReleaseKind = isModPrompt ? 'mod' : ((UpdateManager.modUpdateAvailable && !UpdateManager.engineUpdateAvailable) ? 'mod' : 'engine');
		releaseUrl = UpdateManager.getReleaseUrlForUpdateKind(selectedReleaseKind);
		if(releaseUrl.length == 0) releaseUrl = UpdateManager.latestReleaseUrl.length > 0 ? UpdateManager.latestReleaseUrl : 'https://github.com/${UpdateManager.REPO}/releases';
		var releaseTagText = UpdateManager.getReleaseTagForUpdateKind(selectedReleaseKind);
		if(releaseTagText.length == 0) releaseTagText = UpdateManager.latestReleaseTag.length > 0 ? UpdateManager.latestReleaseTag : 'latest release';
		changelogLinkText = new FlxText(0, confirmationBg.y + confirmationBg.height - 98, 620, 'Update Changelog (${releaseTagText})', 16);
		changelogLinkText.alignment = CENTER;
		changelogLinkText.x = confirmationBg.x + 20;
		changelogLinkText.scrollFactor.set(0, 0);
		changelogLinkText.color = 0xFF00C8FF;
		changelogLinkText.setFormat(null, 16, 0xFF00C8FF, CENTER);
		add(changelogLinkText);

		var buttonY:Float = confirmationBg.y + confirmationBg.height - 54;
		updateButton = new FlxButton(0, buttonY, 'Update');
		updateButton.scale.set(1.08, 1.08);
		updateButton.updateHitbox();
		updateButton.x = confirmationBg.x + 210;
		updateButton.scrollFactor.set(0, 0);
		add(updateButton);

		laterButton = new FlxButton(0, buttonY, 'Skip');
		laterButton.scale.set(1.08, 1.08);
		laterButton.updateHitbox();
		laterButton.x = confirmationBg.x + 370;
		laterButton.scrollFactor.set(0, 0);
		add(laterButton);

		startUpdateCallback = function() {
			includeMod = promptKind == 'mod';
			if(!includeMod && UpdateManager.pendingModUpdatePrompt && UpdateManager.updateReadyToApply) {
				includeMod = true;
			}
			if(!includeMod && UpdateManager.modUpdateAvailable && !UpdateManager.engineUpdateAvailable) {
				includeMod = true;
			}
			onComplete(includeMod);
			close();
		};
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER)
		{
			startUpdateCallback();
			return;
		}

		if (FlxG.mouse.justPressed)
		{
			if (changelogLinkText != null && FlxG.mouse.overlaps(changelogLinkText))
			{
				CoolUtil.browserLoad(releaseUrl);
				return;
			}
			if (laterButton != null && FlxG.mouse.overlaps(laterButton))
			{
				FlxG.mouse.visible = true;
				if (FlxG.state != null && Std.isOfType(FlxG.state, MainMenuState))
				{
					var menu:MainMenuState = cast FlxG.state;
					menu.selectedSomethin = false;
					menu.allowMouse = true;
					menu.setUpdateNotificationVisible(true);
				}
				close();
				if (onSkip != null) onSkip();
				return;
			}
			if (updateButton != null && FlxG.mouse.overlaps(updateButton))
			{
				startUpdateCallback();
			}
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
	var bg:FlxSprite;
	var title:FlxText;
	var statusText:FlxText;
	var progressFill:FlxSprite;
	var progressBg:FlxSprite;
	var detailText:FlxText;
	var restartButton:FlxButton;
	var completionTimer:Float = 0;
	var completionStarted:Bool = false;

	public function new(resultCallback:Bool->String->Void, includeMod:Bool = false)
	{
		super();
		this.resultCallback = resultCallback;
	}

	override function create()
	{
		super.create();
		bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.alpha = 0.95;
		bg.setGraphicSize(660, 240);
		bg.updateHitbox();
		bg.x = Std.int((FlxG.width - bg.width) / 2);
		bg.y = 140;
		bg.scrollFactor.set(0, 0);
		add(bg);

		title = new FlxText(0, bg.y + 24, 620, UpdateManager.getUpdateTitleText(), 26);
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

		restartButton = new FlxButton(0, bg.y + bg.height - 34, 'Restart', function() {
			UpdateManager.applyPendingUpdate();
			close();
		});
		restartButton.scale.set(1.08, 1.08);
		restartButton.updateHitbox();
		restartButton.x = Std.int(bg.x + (bg.width - restartButton.width) / 2);
		restartButton.scrollFactor.set(0, 0);
		restartButton.visible = false;
		add(restartButton);
	}

	var autoApplyTriggered:Bool = false;
	var modPromptShown:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (title != null)
		{
			title.text = UpdateManager.getUpdateTitleText();
		}

		if (UpdateManager.updateThreadFinished)
		{
			if (!completionStarted)
			{
				completionStarted = true;
				completionTimer = 0.8;
				detailText.text = UpdateManager.updateThreadSuccessful ? 'Done! The update has been applied.' : 'The update could not be completed.';
				statusText.text = UpdateManager.updateThreadSuccessful ? 'Update complete' : 'Update failed';
				if (bg != null) FlxTween.tween(bg, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (title != null) FlxTween.tween(title, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (detailText != null) FlxTween.tween(detailText, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (statusText != null) FlxTween.tween(statusText, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (progressBg != null) FlxTween.tween(progressBg, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (progressFill != null) FlxTween.tween(progressFill, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
				if (restartButton != null) FlxTween.tween(restartButton, {alpha: 0}, 0.3, {ease: FlxEase.quadOut});
			}
			if (completionTimer > 0)
			{
				completionTimer -= elapsed;
				return;
			}
			if (resultCallback != null)
				resultCallback(UpdateManager.updateThreadSuccessful, UpdateManager.updateThreadMessage);
			close();
			return;
		}

		if (UpdateManager.updateReadyToApply)
		{
			if (UpdateManager.pendingModUpdatePrompt && !modPromptShown && subState == null)
			{
				modPromptShown = true;
				detailText.text = 'Engine update staged. Choose whether to install the mod update now.';
				statusText.text = 'Engine update ready';
				if(restartButton != null) restartButton.visible = false;
				openSubState(new UpdateOptionsSubState(function(includeMod:Bool)
				{
					if (includeMod)
					{
						UpdateManager.downloadModUpdateAfterEngine(resultCallback);
					}
					else
					{
						detailText.text = 'Engine update staged. You can install the mod update later.';
						statusText.text = 'Engine update ready';
						if(restartButton != null) restartButton.visible = true;
					}
				}, null, 'mod'));
				return;
			}
			if (UpdateManager.shouldAutoApplyPendingUpdate() && !autoApplyTriggered)
			{
				autoApplyTriggered = true;
				detailText.text = 'Applying update in place...';
				statusText.text = UpdateManager.activeUpdateType == 'mod' ? 'Applying mod update' : 'Applying engine update';
				if(restartButton != null) restartButton.visible = false;
				UpdateManager.applyPendingUpdate();
			}
			else
			{
				detailText.text = 'Update downloaded and staged. Click Restart to close the game, apply the new files, and relaunch.';
				statusText.text = UpdateManager.pendingModUpdatePrompt ? 'Engine update ready — mod update can be installed after restart' : (UpdateManager.activeUpdateType == 'mod' ? 'Mod update ready to apply' : 'Engine update ready to apply');
				if(restartButton != null) restartButton.visible = true;
			}
		}
		else if (statusText != null)
		{
			statusText.text = UpdateManager.progressLabel + (UpdateManager.progressTotal > 0 ? ' (${UpdateManager.progressCurrent}/${UpdateManager.progressTotal})' : '');
		}

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
