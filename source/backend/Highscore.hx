package backend;

class Highscore
{
	public static var weekScores:Map<String, {score:Float, cheated:Int}> = new Map();
	public static var songScores:Map<String, {score:Float, cheated:Int, recentScore:Float, rcheat:Int}> = new Map();
	public static var songRating:Map<String, {rating:Float, recentRating:Float, rate:Float, recentRate:Float}> = new Map<String, {rating:Float, recentRating:Float, rate:Float, recentRate:Float}>();

	public static function resetSong(song:String, diff:Int = 0):Void
	{
		var daSong:String = formatSong(song, diff);
		setScore(daSong, 0, -1, 0, -1);
		setRating(daSong, 0, 0, 1, 1);
	}

	public static function resetWeek(week:String, diff:Int = 0):Void
	{
		var daWeek:String = formatSong(week, diff);
		setWeekScore(daWeek, 0, -1);
	}

	public static function saveScore(song:String, songCheatedSave:Int = -1, score:Float = 0, ?diff:Int = 0, ?rating:Float = -1, recentScore:Float = 0, recentRating:Float = 0, rate:Float = 1, recentRate:Float = 1, recC:Int = -1):Void
	{
		if(song == null) return;
		var daSong:String = formatSong(song, diff);

		if (songScores.exists(daSong))
		{
            var existingScore = songScores.get(daSong).score;
			var existingRating = songRating.get(daSong).rating;
			var existingRate = songRating.get(daSong).rate;
			var exC = songScores.get(daSong).cheated;
			if(score > existingScore) {
				setScore(daSong, score, songCheatedSave, recentScore, recC);
				setRating(daSong, rating, recentRating, rate, recentRate);
			}
			else
			{
				setScore(daSong, existingScore, exC, recentScore, recC);
				setRating(daSong, existingRating, recentRating, existingRate, recentRate);
			}				
		}
		else
		{
			setScore(daSong, score, songCheatedSave, recentScore, recC);
			setRating(daSong, rating, recentRating, rate, recentRate);
		}
	}

	public static function saveWeekScore(week:String, weekCheated:Int = -1, score:Float = 0, ?diff:Int = 0):Void
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
	static function setScore(song:String, score:Float, songCheatedSave:Int, recentScore:Float, recC:Int):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, {score: score, cheated: songCheatedSave, recentScore: recentScore, rcheat: recC});
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Float, weekCheated:Int):Void
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
			setScore(daSong, 0, -1, 0, -1);
	
		return songScores.get(daSong).cheated;
	}

	public static function getRCheatedStatus(song:String, diff:Int):Int
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0, -1, 0, -1);
	
		return songScores.get(daSong).rcheat;
	}
	static function setRating(song:String, rating:Float, recentRating:Float, rate:Float, recentRate:Float):Void
	{
		// Reminder that I don't need to format this song, it should come formatted!
		songRating.set(song, {rating: rating, recentRating: recentRating, rate: rate, recentRate: recentRate});
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String
	{
		return Paths.formatToSongPath(song) + Difficulty.getFilePath(diff);
	}

	public static function getScore(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songScores.exists(daSong))
			setScore(daSong, 0, -1, 0, -1);

		return songScores.get(daSong).score;
	}

	public static function getRScore(song:String, diff:Int):Float
		{
			var daSong:String = formatSong(song, diff);
			if (!songScores.exists(daSong))
				setScore(daSong, 0, -1, 0, -1);
	
			return songScores.get(daSong).recentScore;
		}

	public static function getRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0, 0, 1, 1);

		return songRating.get(daSong).rating;
	}

	public static function getRRating(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0, 0, 1, 1);

		return songRating.get(daSong).recentRating;
	}
	public static function getRate(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0, 0, 1, 1);

		return songRating.get(daSong).rate;
	}

	public static function getRRate(song:String, diff:Int):Float
	{
		var daSong:String = formatSong(song, diff);
		if (!songRating.exists(daSong))
			setRating(daSong, 0, 0, 1, 1);

		return songRating.get(daSong).recentRate;
	}

	public static function getWeekScore(week:String, diff:Int):Float
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