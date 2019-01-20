<?php
include_once '../library/simple_html_dom.php';
include_once '../library/simple_date.php';

class BloombergArticle
{
	private $title;
	private $abstractText;
	private $content;
	private $articleDate;
	private $articleLink;
	
	public function __construct($link)
	{
		$this -> articleLink = $link;
		$articleMainPage = str_get_html(file_get_contents_curl($link));
		if ($articleMainPage == null) {
			echo "<br/>Error #3: Cannot load main page of the article<br/>";
			return;
		}
		
		$articleMainPage = $articleMainPage -> find("main", 0);
		if ($articleMainPage == null) 
		{	
			$articleMainPage = str_get_html(file_get_contents_curl($link));
					
			$this -> title = $articleMainPage -> find("#app > div > div > section > div:nth-child(1) > div:nth-child(2) > article > div:nth-child(1) > h1", 0) -> plaintext;
			if ($this -> title == null) {
				$this -> title = $articleMainPage -> find("body > article > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > div > div > h1 > a", 0) -> plaintext;
			}
			$this -> abstractText = "";
						
			$this -> articleDate = $articleMainPage -> find("#app > div > div > section > div:nth-child(1) > div:nth-child(2) > article > div:nth-child(1)", 0);
			if ($this -> articleDate == null) {
				$this -> articleDate = $articleMainPage -> find("#article > div:nth-child(2) > div:nth-child(1)", 0) -> find("time",0) -> datetime;
			}
			else {
				$this -> articleDate = $this -> articleDate -> find("time",0) -> datetime;
			}
			
			$text = $articleMainPage -> find("#app > div > div > section > div:nth-child(1) > div:nth-child(2) > article > div:nth-child(2) > div:nth-child(1)", 0);
			if ($text == null) {
				$text = $articleMainPage -> find("#article > div:nth-child(2) > div:nth-child(2)", 0) -> find("p");	
			}
			else {
				$text =	$text -> find("p");	
			}
			
			if ($this -> title == null || $text == null || $this -> articleDate == null) {
				echo "</br>Error #4: Cannot find element: MAIN</br>";
			}
			else
			{
				foreach ($text as $tempText) {
					$tempText = $tempText -> plaintext;
				}
				$this -> content = implode("", $text);
			}
			
			$this -> makeDateBetter();
			return;
		}
		
		$this -> title = $articleMainPage -> find("h1[class=lede-text-only__hed]", 0) -> plaintext;
		if ($this -> title == null) {
			$this -> title = $articleMainPage -> find("h1[class=lede-large-content__hed]", 0) -> plaintext;
			if ($this -> title == null) {
				$this -> title = $articleMainPage -> find("h1[class=full-width-image-lede-text-above__hed]", 0) -> plaintext;
				if ($this -> title == null) {
					$this -> title = $articleMainPage -> find("h1[class=not-quite-full-width-image-lede-text-above__hed]", 0) -> plaintext;
					if ($this -> title == null) {
						$this -> title = $articleMainPage -> find("h1[class=video-info__headline]", 0) -> plaintext;
						if ($this -> title == null) {
							$this -> title = $articleMainPage -> find("h1[class=lede-headline]", 0) -> plaintext;
							if ($this -> title == null) {
								$this -> title = $articleMainPage -> find("body > article > div:nth-child(1) > div:nth-child(1) > div:nth-child(3) > div > div > h1 > a",0) -> plaintext;
								if ($this -> title == null) {
									echo "</br>Error #4: Cannot find element: TITLE</br>";
								}	
							}
						}
						else
						{
							$this -> content = $articleMainPage -> find("h2[class=video-info__summary]", 0) -> plaintext;
							if ($this -> content == null) {
								echo "</br>Error #4: Cannot find element: TEXT VIDEO ARTICLE</br>";
							}
							
							$this -> articleDate = $articleMainPage -> find("div[class=content-details]", 0) -> find("time", 0) -> datetime;						
							if ($this -> articleDate == null) {
								echo "</br>Error #4: Cannot find element: DATE VIDEO ARTICLE</br>";
							}
							
							$this -> makeDateBetter();
							return;
						}
					}
				}
			}
		}
		
		$this -> abstractText = $articleMainPage -> find("div[class=lede-text-only__dek]", 0) -> plaintext;
		if ($this -> abstractText == null) {
			$this -> abstractText = "";
		}
		
		$text = $articleMainPage -> find("div[class=body-copy]", 0);
		if ($text == null) {
			$text = $articleMainPage -> find("section[class=article-body]", 0);
			if($text == null) {
				echo "</br>Error #4: Cannot find element: DIV.BODY-COPY</br>";
			}
		}
		
		if ($text != null)
		{	
			$text = $text -> find("p");
			if ($text == null) {
				echo "</br>Error #4: Cannot find element: TEXT</br>";
			}
			else 
			{
				foreach ($text as $tempText) {
					$tempText = $tempText -> plaintext;
				}
				$this -> content = implode("", $text);
			}
		}
		
		$this -> articleDate = $articleMainPage -> find("time[class=article-timestamp]", 0) -> datetime;
		if ($this -> articleDate == null) {
			$this -> articleDate = $articleMainPage -> find("time[class=time-based]", 0) -> datetime;
			if ($this -> articleDate == null) {
				echo "</br>Error #4: Cannot find element: DATE</br>";
			}
		}
		
		$this -> makeDateBetter();
	}
	
	private function makeDateBetter()
	{
		$simpleDate = new SimpleDate();
		$simpleDate -> setDateFromMSN($this->articleDate);
		$this->articleDate = $simpleDate;
	}
	
	public function getTitle()
	{
		return $this -> title;
	}
	public function getAbstract()
	{
		return $this -> abstractText;
	}
	public function getContent()
	{
		return $this -> content;
	}
	public function getArticleDate()
	{
		return $this -> articleDate;
	}
	public function getLink()
	{
		return $this -> articleLink;
	}
	
	public function toJSON()
	{	
		return 
'{
	"Title": "'.trim(strip_tags($this->title)).'",
	"Content": "'.strip_tags($this->content).'",
	"Date": "'.$this->articleDate.'"
}';
	}
	
	public function toJSONwoText()
	{
		return 
'{
	"Title": "'.trim(strip_tags($this->title)).'",
	"Date": "'.$this->articleDate->toMySQL().'",
	"Link": "'.$this->articleLink.'"
}';
	}
	
	
	public function toMSJSON()
	{
		return 
'{
	"language": "en",
	"id": "'.$this->articleDate.'",
	"text": "'.strip_tags(substr($this->content,0,5000)).'"
}';
	}
	
}


class BloombergSearchResult
{
	private $articles;
	private $tag;
	
	public function __construct($tag, $nOfPages)
	{
		if ($nOfPages == -1)
		{
			return json_decode(file_get_contents($tag."-news.txt"));		
		}
		//error_reporting(E_ALL & ~E_WARNING);
		$this -> tag = $tag;
		
		$mainResultPage = self::loadSearchResultPage($tag, 1) or die("</br>Error #1: Cannot load page with results of the search</br>"); 
		if ($mainResultPage == null) {
			echo "</br>Error #1: Cannot load page with results of the search</br>";
			$articles = 0;
			return;
		}

		$searchResultItem = $mainResultPage -> find("div[class=search-result]", 0);
		if ($searchResultItem == null) {
			echo "</br>Error #2: Cannot find first search result item on the first page</br>";
			$articles = 0;
			return;
		}
	
		$this -> articles = array();
		if ($nOfPages == 0)
		{
			$page = 1;
			while ($searchResultItem != null)
			{
				$this -> loadPageOfArticles($mainResultPage, $searchResultItem);
				$this -> nextPageOfArticles($mainResultPage, $searchResultItem, $page);
			}
		}
		else if ($nOfPages > 0)
		{
			$page = 1;
			for ( ; $page < $nOfPages+1; )
			{
				$this -> loadPageOfArticles($mainResultPage, $searchResultItem, $page);
				$this -> nextPageOfArticles($mainResultPage, $searchResultItem, $page);
				//echo "</br>---------------------------------------------------PAGE: $page</br>";
			}
		}
		else
		{
			echo "</br>Error #5: Number of pages must be positive</br>";
		}
		
		//error_reporting(E_ALL);
	}
	
	private function loadPageOfArticles($mainResultPage, &$searchResultItem, $page)
	{
		$iteration = 0;
		
		while ($searchResultItem != null)
		{
			$link = $searchResultItem -> find("article > div.search-result-story__container > h1 > a", 0) -> href;
			if ($link == null) {
				echo "</br>Error #4: Cannot find element: LINK</br>";
			}

			array_push($this -> articles, new BloombergArticle($link));
			//echo $iteration.": ".$this->articles[$iteration + 10*($page-1)]->getTitle()."<br>Date: ";
			//echo strip_tags($this->articles[$iteration + 10*($page-1)]->getContent())."<br><br>";
				
			$searchResultItem -> clear();
			unset($searchResultItem);
				
			$iteration += 1;
			$searchResultItem = $mainResultPage -> find("div[class=search-result]", $iteration);
		}
	}
	
	private function nextPageOfArticles(&$mainResultPage, &$searchResultItem, &$page)
	{	
		$mainResultPage -> clear();
		$searchResultItem -> clear();
		//unset($mainResultPage);
		//unset($searchResultItem);
	
		$page += 1; 
		$mainResultPage = self::loadSearchResultPage($this -> tag, $page);
		if ($mainResultPage == null) {
			echo "</br>Error #1: Cannot load page with results of the search //nextPage function, page: $page</br>";
			$articles = 0;
			return;
		}
		
	
		$searchResultItem = $mainResultPage -> find("div[class=search-result]", 0);	
	}
	
	public static function loadSearchResultPage($tag, $page)
	{
		$mainSearchURL = "https://www.bloomberg.com/search?query=$tag&sort=time:desc&page=$page";
		return str_get_html(file_get_contents_curl($mainSearchURL));
	}
	
	
	public function getArticles()
	{
		return $this -> articles;
	}
	
	public function toJSONArray()
	{
		$articlesJSON = array();
		foreach ($this->articles as $article)
		{
			array_push($articlesJSON, $article -> toJSON());
		}
		
		return $articlesJSON;
	}
	
	public function newsToMSJSON()
	{
		$json = 
'{
	"documents": [
';
		foreach ($this->articles as $article)
		{
			$json = $json."".PHP_EOL."".$article->toMSJSON().",";
		}
		
		$json = substr($json,0,-1)."
]
}";	
		return $json;
	}
	
	public function newsToJSONwoTEXT()
	{
		$json = 
'{
	"documents": [
';
		foreach ($this->articles as $article)
		{
			$json = $json."".PHP_EOL."".$article->toJSONwoText().",";
		}
		$json = substr($json,0,-1)."
]
}";	
		return $json;
	}
	
}




function file_get_contents_curl($url) 
{
	$ch = curl_init();

	curl_setopt($ch, CURLOPT_HEADER, 0);
	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($ch, CURLOPT_URL, $url);

	$data = curl_exec($ch);
	curl_close($ch);

	return $data;
}


?>