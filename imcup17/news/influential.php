<?php
require_once '../library/simple_date.php';

if (isset($_GET['search-tag'])) {
	$searchTag = $_GET['search-tag'];
} else {
	$searchTag = "microsoft";
}
$stocksTag = "";
if ($searchTag == "microsoft") {
	$stocksTag = "MSFT";
}

$news = json_decode(file_get_contents($searchTag."-news.txt"));
$news = $news->documents;

$score = json_decode(file_get_contents($searchTag."-score.txt"));
$score = $score->documents;

$prices = json_decode(file_get_contents("../stocks/".$searchTag."-stocks.txt"));
$prices = $prices->documents;

$DPRICE = 0.1;
$PRICE_OFFSET = 4;
$influentialPLUS = array();
$influentialMINUS = array();

$nOfGreens = 0;
$nOfReds = 0;

$i=0;
foreach ($news as $article)
{
	if ($score[$i]->score > $GOOD_MOOD) {
		$nOfGreens += 1;
	}
	else if ($score[$i]->score < $BAD_MOOD) {
		$nOfReds += 1;
	}
	else {
		$color = "Black";
	}
	
	$i += 1;
}

$nOfGoodGNews = 0;
$nOfGoodRNews = 0;

foreach ($news as $article)
{
	$aDate = $article->Date."";
	$priceDateIndex = 0;
	$i=0;
	foreach ($prices as $pr)
	{
		//echo $aDate;
		if ( SimpleDate::isFirstLaterThanSecond($pr->Date."", $aDate) ) {
			$priceDateIndex = $i;
			break;
		}
		$i += 1;
	}
	//echo $priceDateIndex;
	//echo $prices[$priceDateIndex]->Date."<br>";
	
	$firstPrice = $prices[$priceDateIndex]->Price;
	$secondPrice = $prices[$priceDateIndex + $PRICE_OFFSET]->Price;
	if ($secondPrice == null) {
		$secondPrice = $prices[$priceDateIndex + $PRICE_OFFSET - 1]->Price;
		if ($secondPrice == null) {
			$secondPrice = $prices[$priceDateIndex + $PRICE_OFFSET - 2]->Price;
			if ($secondPrice == null) {
				continue;
			}
		}
	}
	
	if (abs($secondPrice - $firstPrice) > $DPRICE){
		if (($secondPrice - $firstPrice) > 0 ) {
			array_push($influentialPLUS, $article);
		} else {
			array_push($influentialMINUS, $article);
		}
	}	
}?>
<html>
<head>
	<meta charset = "UTF-8">
	<link href="https://fonts.googleapis.com/css?family=Slabo+27px" rel="stylesheet">
	<link rel="stylesheet" href="influentialStyle.css" type="text/css">
</head>
<body>
<div class="main-page-articles"> 
<?php
	
$GOOD_MOOD = 0.94;
$BAD_MOOD = 0.25;
	$i=0; $isBadArt = false;
foreach ($influentialPLUS as $article)
{
	foreach ($score as $s) 
	{
		$simpleDate = new SimpleDate();
		$simpleDate -> setDateFromThisString($s->id);
		$articleDate = new SimpleDate();
		$articleDate -> setDateFromMSN($article->Date);
		//echo $simpleDate." ".$articleDate;
		//echo ".";
		
		if ($simpleDate->toMSN() == $articleDate->toMSN()) {
			//echo gettype($s->score)." ".$s->score;
			if ($s->score > $GOOD_MOOD) 
			{
				$color = "Green";
				$nOfGoodGNews += 1;
			}
			else if ($s->score < $BAD_MOOD)
				 $isBadArt = true;
				
			else
				$isBadArt = true;
			break;
		}	
	}
	$i+=1;
	if ($isBadArt == true) {
		$isBadArt = false;
		continue;
	}
	//$color = "Black";
	echo '<div class="anArticle"><h3><a style="color: '.$color.'" target="_top" href="'.$article->Link.'">'.$article->Title.
	'</a></h3><div class="time-block"><span></span><time datetime="">'.
	$article->Date.'</time></div></div><hr>';	
}
	echo "<hr>";
	//echo "Influential/All = ".($nOfGoodGNews*100/$nOfGreens)."%<hr>"; $i=0;  $isBadArt = false;
foreach ($influentialMINUS as $article)
{
	foreach ($score as $s) 
	{
		$simpleDate = new SimpleDate();
		$simpleDate -> setDateFromThisString($s->id);
		$articleDate = new SimpleDate();
		$articleDate -> setDateFromMSN($article->Date);
		//echo $simpleDate." ".$articleDate;
		//echo ".";
		
		if ($simpleDate->toMSN() == $articleDate->toMSN()) {
			//echo gettype($s->score)." ".$s->score;
			if ($s->score > $GOOD_MOOD)
				 $isBadArt = true;
			else if ($s->score < $BAD_MOOD)
			{
				$color = "Red";
				$nOfGoodRNews += 1;	
			}
			else
				 $isBadArt = true;
				
		}	
	}
	$i+=1;
	if ($isBadArt == true) {
		$isBadArt = false;
		continue;
	}
	echo '<div class="anArticle"><h3><a style="color: '.$color.'" target="_top" href="'.$article->Link.'">'.$article->Title.
	'</a></h3><div class="time-block"><span></span><time datetime="">'.
	$article->Date.'</time></div></div><hr>';	
}	//echo gettype($nOfGoodRNews)." ".gettype($nOfReds);
	//echo $nOfReds;
	//echo "Influential/All = ".($nOfGoodRNews*100/$nOfReds)."%<hr>";
?>
</div>
</body>
</html>
