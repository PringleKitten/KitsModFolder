package options;

import states.MainMenuState;
import backend.StageData;
import flixel.FlxG;
import flixel.group.FlxGroup;
import haxe.ds.StringMap;

class OptionsState extends MusicBeatState
{
    var options:Array<String> = [
        'Note Colors',
        'Controls',
        'Adjust Delay and Combo',
        'Graphics',
        'Visuals',
        'Gameplay',
        'Internet Favorites Settings',
        'Update Settings'
        #if TRANSLATIONS_ALLOWED , 'Language' #end
    ];

    private var grpOptions:FlxGroup;
    private static var curSelected:Int = 3;
    public static var onPlayState:Bool = false;

    private var optionMap:StringMap<() -> Void>;
    private var scrollMenuSelected:Bool = true;

    var selectorLeft:Alphabet;
    var selectorRight:Alphabet;
    
    var scrollMenuText:FlxText;
    var scrollMenuCheckbox:FlxSprite;

    function openSelectedSubstate(label:String) {
        optionMap.get(label)();
    }

    override function create()
    {
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end

        FlxG.mouse.visible = true;

        optionMap = new StringMap();
        optionMap.set('Note Colors', () -> openSubState(new options.NotesColorSubState()));
        optionMap.set('Controls', () -> openSubState(new options.ControlsSubState()));
        optionMap.set('Graphics', () -> openSubState(new options.GraphicsSettingsSubState()));
        optionMap.set('Visuals', () -> openSubState(new options.VisualsSettingsSubState()));
        optionMap.set('Gameplay', () -> openSubState(new options.GameplaySettingsSubState()));
        optionMap.set('Internet Favorites Settings', () -> openSubState(new options.PringlekittenSettingsSubState()));
        optionMap.set('Update Settings', () -> openSubState(new options.UpdateSettingsSubState()));
        optionMap.set('Adjust Delay and Combo', () -> MusicBeatState.switchState(new options.NoteOffsetState()));
        #if TRANSLATIONS_ALLOWED
        optionMap.set('Language', () -> openSubState(new options.LanguageSubState()));
        #end

        grpOptions = new FlxGroup();
        add(grpOptions);

        for (i in 0...options.length) {
            var optionText:FlxText = new FlxText(0, 0, 0, options[i], 48);
            optionText.screenCenter();
            optionText.y = ((FlxG.height / 2) - 50) + (i * 60);
            optionText.ID = i;
            grpOptions.add(optionText);
        }

        scrollMenuText = new FlxText(20, FlxG.height / 2, 220, "Scroll Menu?", 20);
        scrollMenuText.color = FlxColor.WHITE;
        add(scrollMenuText);

        scrollMenuCheckbox = new FlxSprite(50, scrollMenuText.y + 25);
        scrollMenuCheckbox.makeGraphic(50, 50, FlxColor.WHITE);
        scrollMenuCheckbox.color = scrollMenuSelected ? 0xFF00FF : FlxColor.WHITE;
        add(scrollMenuCheckbox);

        selectorLeft = new Alphabet(0, 0, '>', true);
        add(selectorLeft);
        selectorRight = new Alphabet(0, 0, '<', true);
        add(selectorRight);

        changeSelection();
        ClientPrefs.saveSettings();

        super.create();
    }

    override function closeSubState()
    {
        super.closeSubState();
        ClientPrefs.saveSettings();
        #if DISCORD_ALLOWED
        DiscordClient.changePresence("Options Menu", null);
        #end
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
        var mousePoint:FlxPoint = new FlxPoint(FlxG.mouse.screenX, FlxG.mouse.screenY);

        if (FlxG.mouse.justPressed) {
            if (scrollMenuCheckbox.overlapsPoint(mousePoint)) {
                scrollMenuSelected = !scrollMenuSelected;
                scrollMenuCheckbox.color = scrollMenuSelected ? 0xFF00FF : FlxColor.WHITE ;
                changeSelection();
            }
        }

        if (controls.UI_UP_P) {
            curSelected = Std.int(Math.max(0, curSelected - 1));
            changeSelection();
        }
        if (controls.UI_DOWN_P) {
            curSelected = Std.int(Math.min(options.length - 1, curSelected + 1));
            changeSelection();
        }

        if (controls.BACK) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            if(onPlayState) {
                StageData.loadDirectory(PlayState.SONG);
                LoadingState.loadAndSwitchState(new PlayState());
                FlxG.sound.music.volume = 0;
            } else {
                MusicBeatState.switchState(new MainMenuState());
            }
        } else if (controls.ACCEPT) {
            openSelectedSubstate(options[curSelected]);
        }
    }

    function changeSelection(change:Int = 0)
    {
        var baseY:Float = (FlxG.height / 2) - 50;
        curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
    
        if (scrollMenuSelected) {
    
            for (item in grpOptions.members) {
                var textItem:FlxText = cast(item, FlxText);
                if (textItem != null) {
                    textItem.alpha = 0.4;
                    textItem.color = FlxColor.WHITE;
                    textItem.y = baseY + (textItem.ID - curSelected) * 60;
    
                    if (textItem.ID == curSelected) {
                        textItem.alpha = 1;
                        textItem.color = 0xFF00FF;
    
                        var textWidth = textItem.width;
                        selectorLeft.x = textItem.x - 55;
                        selectorLeft.y = textItem.y;
                        selectorRight.x = textItem.x + textWidth;
                        selectorRight.y = textItem.y;
                    }
                }
            }
        } else {
            var centerY:Float = FlxG.height / 2 - (options.length * 60) / 2;
            for (item in grpOptions.members) {
                var textItem:FlxText = cast(item, FlxText);
                if (textItem != null) {
                    textItem.alpha = 0.4;
                    textItem.color = FlxColor.WHITE;
                    textItem.y = centerY + (textItem.ID * 60);
    
                    if (textItem.ID == curSelected) {
                        textItem.alpha = 1;
                        textItem.color = 0xFF00FF;

                        var textWidth = textItem.width;
                        selectorLeft.x = textItem.x - 55;
                        selectorLeft.y = textItem.y;
                        selectorRight.x = textItem.x + textWidth;
                        selectorRight.y = textItem.y;
                    }
                }
            }
        }
    
        FlxG.sound.play(Paths.sound('scrollMenu'));
    }        

    override function destroy()
    {
        ClientPrefs.loadPrefs();
        super.destroy();
    }
}