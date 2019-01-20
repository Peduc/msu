<?php

class SimpleDate
{
	private $second;
	private $minute;
	private $hour;
	private $day;
	private $month;
	private $year;
	
	private $timeZone;
	
	public function setDateFromMSN($date)
	{
		$this -> year = substr($date, 0, 4);
		$this -> month = substr($date, 5, 2);
		$this -> day = substr($date, 8, 2);
		$this -> hour = substr($date, 11, 2);
		$this -> minute = substr($date, 14, 2);
		$this -> second = substr($date, 17, 2);	
		
	}
	public function setDateFromThisString($date)
	{
		//echo $date." ";
		$this -> year = substr($date, 15, 4);
		$this -> month = substr($date, 12, 2);
		$this -> day = substr($date, 9, 2);
		$this -> hour = substr($date, 0, 2);
		$this -> minute = substr($date, 3, 2);
		$this -> second = substr($date, 6, 2);	
		
	}
	
	public function toMSN()
	{
		return $this->year."-".$this->month."-".$this->day."T".$this->hour.":".$this->minute.":".$this->second;
	}
	
	public static function isFirstLaterThanSecond($first, $second)
	{
		$firstDate = new SimpleDate();
		$secondDate = new SimpleDate();
		
		$firstDate->setDateFromMSN($first);
		$secondDate->setDateFromMSN($second);
		
		if ($firstDate->day > $secondDate->day) {
			return true;
		}
		else if ($firstDate->day == $secondDate->day) {
			if ($firstDate->hour > $secondDate->hour) {
				return true;
			}
			else if ($firstDate->hour == $secondDate->hour) {
			
				if ($firstDate->minute > $secondDate->minute) {
					return true;
				}
					else if ($firstDate->minute == $secondDate->minute) {
			
				if ($firstDate->second > $secondDate->second) {
					return true;
				}
					else if ($firstDate->second == $secondDate->second) {
			
					return false;
			
				}
				else {
					return false;	
				}
			
				}
				else {
					return false;	
				}
			
			}
			else {
				return false;	
			}
		}
		else {
			return false;	
		}
	}
	
	/*public function MSNnextDay() //BUGS WITH ZERO
	{
		if ( (($this->month == "01" || $this->month == "03" || $this->month == "05" || $this->month == "07" || 
			  $this->month == "08" || $this->month == "10" || $this->month == "12") && ($this->day == "31"))
			  ||
			  (($this->month == "04" || $this->month == "06" || $this->month == "09" || $this->month == "11") 
			  && ($this->day == "30"))
			  ||
			  (($this->month == "02") && ($this->day == "28"))
			)
		{
			if ($this->month == "12") {
				$this->year = (string)((int)$this->year + 1);
				$this->month = "01";
			} else {
				$this->month = (string)((int)$this->month + 1);
			}
			
			$this->day = "01";
		}
		else
		{
			$this->day = (string)((int)$this->day + 1);
		}
		$this -> hour = "09";
		$this -> minute = "30";
		$this -> second = "00";	
		
		//return $this;
	}
	
	public function MSNplus15min()
	{
		if ($this -> hour == "16")
		{
			if ((int)$this -> minute > 0)
			{
				$this -> MSNnextDay();
				return;
			}
		}
		
		if ((int)$this->minute >= 45)
		{
			//if ($this -> hour == "15")
			$this -> hour = (string)((int)$this->hour + 1);
			$this -> minute = "00";
		}
		else
		{
			$this -> minute = (string)((int)$this->minute + 15);
		}
		$this -> second = "00";	

		//return $this;
	}
	
	public static function makeMSNdateStep($startDate, $stepMinutes)
	{
		if ($stepMinutes > 100000)
			$stepMinutes = 0;
		
		$currentDate = $startDate->toNumber() + (int)$stepMinutes;
		$currentDate = SimpleDate::checkNormalDate($currentDate);
		echo $currentDate."</br>";
		$returnDate = new SimpleDate();
		$returnDate->setDateFromNumber($currentDate);
		return $returnDate;
	}
	
	public static function checkNormalDate($currentDate)
	{
		$currentDate = (string)$currentDate;
		while ( substr($currentDate, 10, 2) >= "60" ) {
			$currentDate = substr($currentDate, 0, 8).((int)substr($currentDate, 8, 2)+1)."00";
		}
		
		while ( substr($currentDate, 8, 2) >= "24" ) {
			$currentDate = substr($currentDate, 0, 8)."0000";
		}
		
		$month = substr($currentDate, 4, 2)	
		if ( (($month == "01" || $month == "03" || $month == "05" || $month == "07" || 
			  $month == "08" || $month == "10" || $month == "12") && (substr($currentDate, 6, 2) == "31"))
			  ||
			  (($month == "04" || $month == "06" || $month == "09" || $month == "11") 
			  && (substr($currentDate, 6, 2) == "30"))
			  ||
			  (($month == "02") && (substr($currentDate, 6, 2) == "28"))
			)
			{
				$currentDate = substr($currentDate, 0, 4).((int)substr($currentDate, 4, 2)+1)."010000";
			}
		
	}
	
	public function toNumber()
	{
		return ($this->year."".$this->month."".$this->day."".$this->hour."".$this->minute);
	}
	
	public function setDateFromNumber($date)
	{
		$this -> year = substr($date, 0, 4);
		$this -> month = substr($date, 4, 2);
		$this -> day = substr($date, 6, 2);
		$this -> hour = substr($date, 8, 2);
		$this -> minute = substr($date, 10, 2);
		//$this -> second = substr($date, 17, 2);	
	}*/
	
	public function toMySQL()
	{
		return $this->year."-".$this->month."-".$this->day." ".$this->hour.":".$this->minute.":".$this->second;
	}
	
	public function toPloty()
	{
		return $this->year."-".$this->month."-".$this->day." ".$this->hour.":".$this->minute;
	}
	
	public function woSeconds()
	{
		return $this->hour.":".$this->minute." ".$this->month."-".$this->day;
	}
	
	public function __toString()
	{
		return $this->hour.":".$this->minute.":".$this->second." ".$this->day."-".$this->month."-".$this->year;
	}
	
	public function getYear()
	{
		return $this -> year;
	}
	
	public function getMonth()
	{
		return $this -> month;
	}
	
	public function getDay()
	{
		return $this -> day;
	}
	
	public function getHour()
	{
		return $this -> hour;
	}
	
	public function getMinute()
	{
		return $this -> minute;
	}
	
	public function getSecond()
	{
		return $this -> second;
	}
}

?>
