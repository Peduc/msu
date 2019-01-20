<?php
include_once '../library/simple_html_dom.php';
include_once '../library/simple_date.php';
include_once 'BloombergArticle.php';

if (isset($_GET['search-tag'])) {
	$searchTag = $_GET['search-tag'];
} else {
	$searchTag = "microsoft";
}

if (isset($_GET['pages'])) {
	$pages = $_GET['pages'];
} else {
	$pages = "1";
}


//$news = new BloombergSearchResult($searchTag, $pages);
$news = json_decode(file_get_contents($searchTag."-news.txt"));
$news = $news->documents;

//$score = json_decode(file_get_contents($searchTag."-score.txt"));
//$score = $score->documents;
?>
<html>
<head>
	<meta charset = "UTF-8">
	<link href="https://fonts.googleapis.com/css?family=Slabo+27px" rel="stylesheet">
	<link rel="stylesheet" href="articlesStyle.css" type="text/css">
</head>
<body>
<div class="main-page-articles"> 
<?php
$i=0;
$GOOD_MOOD = 0.9;
$BAD_MOOD = 0.1;

foreach ($news as $article)
{
	/*if ($score[$i]->score > $GOOD_MOOD)
		$color = "Green";
	else if ($score[$i]->score < $BAD_MOOD)
		$color = "Red";
	else*/
		$color = "Black";
	
	echo '<div class="anArticle"><h3><a style="color: '.$color.'" target="_top" href="'.$article->Link.'">'.$article->Title.
	'</a></h3><div class="time-block"><span></span><time datetime="">'.
	$article->Date.'</time></div></div><hr>';	
	
	$i += 1;
}
?>
</div>
</body>
</html>