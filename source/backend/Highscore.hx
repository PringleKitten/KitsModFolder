package backend;

class Highscore
{
	public static var weekScores:Map<String, {score:Int, cheated:Int}> = new Map();
	public static var songScores:Map<String, {score:Int, cheated:Int, recentScore:Int}> = new Map();
	public static var songRating:Map<String, {rating:Float, recentRating:Float}> = new Map<String, {rating:Float, recentRating:Float}>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0, -1, 0);
		setRating(daSong, 0, 0);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0, -1);
	}

	public static function saveScore(song:String, songCheatedSave:Int = -1, score:Int = 0, ?diff:Int = 0, ?rating:Float = -1, recentScore:Int = 0, recentRating:Float = 0):Void
	{
		if(song == null) return;
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
            var existingScore = songScores.get(daSong).score;
			var existingRating = songRating.get(daSong).rating;
			if(score > existingScore) {
				setScore(daSong, score, songCheatedSave, recentScore);
			}
			else
			{
				setScore(daSong, existingScore, songCheatedSave, recentScore);
			}				
			if(rating > existingRating) {
				setRating(daSong, rating, recentRating);
			}
			else
			{
				setRating(daSong, existingRating, recentRating);
            }
		}
		else
		{
			setScore(daSong, score, songCheatedSave, recentScore);
			setRating(daSong, rating, recentRating);
		}
	}

	public static function saveWeekScore(week:String, weekCheated:Int = -1, score:Int = 0, ?diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);

		if (weekScores.exists(daWeek))
		{
            var existingScore = weekScores.get(daWeek).score;
				if(score > existingScore) {
					setWeekScore(daWeek, score, weekCheated);
				}
				else
				{
					setWeekScore(daWeek, score, weekCheated);
				}
		}
		else setWeekScore(daWeek, score, weekCheated);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, songCheatedSave:Int, recentScore:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, {score: score, cheated: songCheatedSave, recentScore: recentScore});
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
	static function setRating(song:String, rating:Float, recentRating:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, {rating: rating, recentRating: recentRating});
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
			setScore(daSong, 0, -1, 0);

		return songScores.get(daSong).score;
	}

	public static function getRScore(song:String, diff:Int):Int
		{
			var daSong:String = formatSong(song, diff);
			if (!songScores.exists(daSong))
				setScore(daSong, 0, -1, 0);
	
			return songScores.get(daSong).recentScore;
		}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0, 0);

		return songRating.get(daSong).rating;
	}

	public static function getRRating(song:String, diff:Int):Float
		{
			var daSong:String = formatSong(song, diff);
			if (!songRating.exists(daSong))
				setRating(daSong, 0, 0);
	
			return songRating.get(daSong).recentRating;
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