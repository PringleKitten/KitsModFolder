package backend;

class Highscore
{
	public static var weekScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songRating:Map<String, Float> = new Map<String, Float>();
	public static var weekCheated:Map<String, Int> = new Map();
	public static var songCheatedSave:Map<String, Int> = new Map<String, Int>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScoreCheated(daSong, 0);
		setScore(daSong, 0);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0);
		setWeekCheated(daWeek, 0);
	}

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1):Void
	{
		if(song == null) return;
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
			{
				setScore(daSong, score);
				if(rating >= 0) setRating(daSong, rating);
			}
		}
		else
		{
			setScore(daSong, score);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
			if (weekScores.get(daWeek) < score)
				setWeekScore(daWeek, score);
		}
		else setWeekScore(daWeek, score);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	static function setRating(song:String, rating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, rating);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0);

		return songScores.get(daSong);
	}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0);

		return songRating.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int
	{
		var daWeek:String = formatSong(week, diff);
		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0);

		return weekScores.get(daWeek);
	}

	public static function saveScoreCheated(song:String, songCheated:Int, ?diff:Int = 0):Void
	{
		if(song == null) return;
		var daSongCheated:String = formatSong(song, diff);

		if (songCheatedSave.exists(daSongCheated))
		{
			if (songCheatedSave.get(daSongCheated))
			{
				setScoreCheated(daSongCheated, songCheated);
			}
		}
		else
		{
			setScoreCheated(daSongCheated, songCheated);
		}
		Sys.println(songCheated);
	}
	
	public static function saveWeekCheated(week:String, songCheated:Int, ?diff:Int = 0):Void
	{
		var daWeekCheated:String = formatSong(week, diff);

		if (weekCheated.exists(daWeekCheated))
		{
			if (weekCheated.get(daWeekCheated))
				setWeekCheated(daWeekCheated, songCheated);
		}
		else setWeekCheated(daWeekCheated, songCheated);
	}

	static function setWeekCheated(week:String, songCheated:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekCheated.set(week, songCheated);
		FlxG.save.data.weekCheated = weekCheated;
		FlxG.save.flush();
	}

	public static function getWeekCheated(week:String, diff:Int):Int
    {
		var daWeekCheated:String = formatSong(week, diff);
		if (!weekCheated.exists(daWeekCheated))
			setWeekCheated(daWeekCheated, 0);

		return weekCheated.get(daWeekCheated);
	}

	static function setScoreCheated(song:String, songCheated:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songCheatedSave.set(song, songCheated);
		FlxG.save.data.songCheatedSave = songCheated;
		FlxG.save.flush();
	}

	public static function getScoreCheated(song:String, diff:Int):Int
	{
		var daSongCheated:String = formatSong(song, diff);
		if (!songCheatedSave.exists(daSongCheated))
			setScoreCheated(daSongCheated, 0);

		return songCheatedSave.get(daSongCheated);
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
			weekScores = FlxG.save.data.weekScores;

		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;

		if (FlxG.save.data.songRating != null)
			songRating = FlxG.save.data.songRating;

		if (FlxG.save.data.weekCheated != null)
			weekCheated = FlxG.save.data.weekCheated;

		if (FlxG.save.data.songCheatedSave != null)
			songCheatedSave = FlxG.save.data.songCheatedSave;
	}
}