<?php
require_once '../library/simple_date.php';

class MSNprice
{
	private $highPrice;
	private $lowPrice;
	private $openPrice;
	private $closePrice;
	private $priceDate;
	
	
	public function __construct($serie, $startDate)
	{
		$this -> highPrice = $serie -> Hp;
		$this -> lowPrice = $serie -> Lp;
		$this -> openPrice = $serie -> Op;
		$this -> closePrice = $serie -> P;
		
		$step = $serie -> T;
		if ($step > 100000) {
			$step = 0;
		}	
		$startDate = $startDate->toMySQL();
		$simpleDate = new SimpleDate();
		$simpleDate -> setDateFromMSN( date("Y-m-d H:i:s", strtotime(" +$step minutes", strtotime($startDate))) );
		$this -> priceDate = $simpleDate;
	}
	
	public function getClosePrice()
	{
		return $this -> closePrice;
	}
	
	public function getPriceDate()
	{
		return $this -> priceDate;
	}
	
	public function toJSON()
	{
		return 
'{
	"Price": "'.$this->closePrice.'",
	"Date": "'.$this->priceDate->toMySQL().'"
}';
	}
}


class PricesLastWeek
{
	private $company;
	private $prices;
	private $dateOfLastPrice;
	
	public function __construct($company)
	{
		$this -> company = $company;
		$this -> prices = array();
		$serverAnswer = json_decode( self::getPricesFromServer($company) );
		
		$series = $serverAnswer[0] -> Series;
		
		$startDate = new SimpleDate();
		$startDate -> setDateFromMSN($serverAnswer[0] -> St);
		$nOfSeries = count($series);
		
		for ($i = 0; $i < $nOfSeries; $i++) {
			array_push( $this -> prices, new MSNprice($series[$i], $startDate) );
		}		
	}
	
	public function getPrices()
	{
		return $this -> prices;
	}
	
	
	public static function getPricesFromServer($company)
	{
		$URL = "https://finance.services.appex.bing.com/Market.svc/ChartDataV5?symbols=126.1.$company.NAS&chartType=5d&isEOD=False&lang=en-US&isCS=true&isVol=true";
		return file_get_contents($URL);
	}
}


?>