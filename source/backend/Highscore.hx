package backend;

class Highscore
{
	public static var weekScores:Map<String, {score:Int, cheated:Int}> = new Map();
	public static var songScores:Map<String, {score:Int, cheated:Int}> = new Map();
	public static var songRating:Map<String, Float> = new Map<String, Float>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0, -1);
		setRating(daSong, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0, -1);
	}

	public static function saveScore(song:String, songCheatedSave:Int = -1, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1):Void
	{
		if(song == null) return;
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
            var existingScore = songScores.get(daSong);
                setScore(daSong, score, songCheatedSave);
                if(rating >= 0) setRating(daSong, rating);
		}
		else
		{
			setScore(daSong, score, songCheatedSave);
			if(rating >= 0) setRating(daSong, rating);
		}
	}

	public static function saveWeekScore(week:String, weekCheated:Int = -1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
            var existingScore = weekScores.get(daWeek);
                setWeekScore(daWeek, score, weekCheated);
		}
		else setWeekScore(daWeek, score, weekCheated);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, songCheatedSave:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, {score: score, cheated: songCheatedSave});
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int, weekCheated:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, {score: score, cheated: weekCheated});
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	public static function getCheatedStatus(song:String, diff:Int):Int
		{
			var daSong:String = formatSong(song, diff);
			if (!songScores.exists(daSong))
				return -1;
		
			return songScores.get(daSong).cheated;
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
			setScore(daSong, 0, -1);

		return songScores.get(daSong).score;
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
			setWeekScore(daWeek, 0, -1);

		return weekScores.get(daWeek).score;
	}

	public static function load():Void
	{
		if (FlxG.save.data.weekScores != null)
			weekScores = FlxG.save.data.weekScores;

		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;

		if (FlxG.save.data.songRating != null)
			songRating = FlxG.save.data.songRating;
	}
}