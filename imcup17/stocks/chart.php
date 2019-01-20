<?php
require_once '../library/simple_date.php';
require_once 'MSNprices.php';

if (isset($_GET['company'])) {
	$company = $_GET['company'];
} else {
	$company = "MSFT";
}


/*$MSFTprices = new PricesLastWeek($company);
$prices = $MSFTprices->getPrices();
//$prices = array_reverse($prices);

$strPrices = "Time,Price,Company".PHP_EOL;
foreach($prices as $price) {
	$strPrices = $strPrices."".$price->getPriceDate()->woSeconds().",".$price->getClosePrice().",".$company.PHP_EOL;
}

$filename = $company."-data.csv";
file_put_contents($filename, $strPrices);

$filename = "chart-data.csv";
file_put_contents($filename, $strPrices);*/
?>
<html>
<head>
	 <script src="plotly-latest.min.js"></script>
</head>
<body>
	<div id="chart" style="width: 650px; height: 260px;"></div>
	<script src="plotting.js"></script>
</body>
</html>
