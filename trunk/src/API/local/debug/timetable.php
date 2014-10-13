<?php
include	'./include.php';

$json= read_from_local("./data/timetable.json");
dump_to_table(json_decode($json,true));
?>

<?php function dump_to_table($data_array) {	?>
<html>
<head>
<title>time	table</title>
<head>
<body>
<table border="1">
<tr>
<td>owl:sameAs</td>
<td>odpt:station</td>
<td>odpt:railway</td>
<td>odpt:operator</td>
<td>odpt:railDirection</td>
<td>odpt:weekdays</td>
<td>odpt:departureTime</td>
<td>odpt:destinationStation</td>
<td>odpt:trainType</td>
<td>odpt:isLast</td>
</tr>
<?php
for($i = 0;	$i<count($data_array); $i++)
{
	$values	= $data_array[$i];

	$sameAs	= "";
	$station = "";
	$railway = "";
	$operator =	"";
	$railDirection = "";
	$timeTableWeekDays;
	$timeTableHoliDays;
	$timeTableSaturdayDays;

	//find time	table
	foreach($values	as $key	=> $value) 
	{
		if($key== 'owl:sameAs'){
			$sameAs	= substr($value,strpos($value,":")+1);
		}else if ($key== 'odpt:station') {
			$station = substr($value,strpos($value,":")+1);
		}else if ($key== 'odpt:railway') {
			$railway = substr($value,strpos($value,":")+1);
		}else if ($key== 'odpt:operator') {
			$operator = substr($value,strpos($value,":")+1);
		}else if ($key== 'odpt:railDirection') {
			$railDirection = substr($value,strpos($value,":")+1);
		}else if ($key == 'odpt:weekdays'){
			$timeTableWeekDays = $value;
		}else if ($key == 'odpt:holidays'){
			$timeTableHoliDays = $value;
		}else if ($key == 'odpt:saturdays'){
			$timeTableSaturdayDays = $value;
		}
	}

	for($j = 0;	$j<count($timeTableWeekDays); $j++)
	{
		$timeTableItem = $timeTableWeekDays[$j];
		$timeTableType="1";
		$departureTime="";
		$destinationStation="";
		$trainType="";
		$isLast="";
		foreach($timeTableItem as $key => $value) 
		{
			if($key== 'odpt:departureTime'){
				$departureTime = str_replace(":","",$value);
			}else if ($key== 'odpt:destinationStation')	{
				$destinationStation	= substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:trainType') {
				$trainType = substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:isLast')	{
				$isLast	= $value;
			}
		}
		echo "<tr>
		<td>".$sameAs."</td>
		<td>".$station."</td>
		<td>".$railway."</td>
		<td>".$operator."</td>
		<td>".$railDirection."</td>
		<td>".$timeTableType."</td>
		<td>".$departureTime."</td>
		<td>".$destinationStation."</td>
		<td>".$trainType."</td>
		<td>".$isLast."</td>
		</tr>";
	}

	for($j = 0;	$j<count($timeTableSaturdayDays); $j++)
	{
		$timeTableItem = $timeTableSaturdayDays[$j];
		$timeTableType="2";
		$departureTime="";
		$destinationStation="";
		$trainType="";
		$isLast="";
		foreach($timeTableItem as $key => $value) 
		{
			if($key== 'odpt:departureTime'){
				$departureTime = str_replace(":","",$value);
			}else if ($key== 'odpt:destinationStation')	{
				$destinationStation	= substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:trainType') {
				$trainType = substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:isLast')	{
				$isLast	= $value;
			}
		}
		echo "<tr>
		<td>".$sameAs."</td>
		<td>".$station."</td>
		<td>".$railway."</td>
		<td>".$operator."</td>
		<td>".$railDirection."</td>
		<td>".$timeTableType."</td>
		<td>".$departureTime."</td>
		<td>".$destinationStation."</td>
		<td>".$trainType."</td>
		<td>".$isLast."</td>
		</tr>";
	}

	for($j = 0;	$j<count($timeTableHoliDays); $j++)
	{
		$timeTableItem = $timeTableHoliDays[$j];
		$timeTableType="3";
		$departureTime="";
		$destinationStation="";
		$trainType="";
		$isLast="";
		foreach($timeTableItem as $key => $value) 
		{
			if($key== 'odpt:departureTime'){
				$departureTime = str_replace(":","",$value);
			}else if ($key== 'odpt:destinationStation')	{
				$destinationStation	= substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:trainType') {
				$trainType = substr($value,strpos($value,":")+1);
			}else if ($key== 'odpt:isLast')	{
				$isLast	= $value;
			}
		}
		echo "<tr>
		<td>".$sameAs."</td>
		<td>".$station."</td>
		<td>".$railway."</td>
		<td>".$operator."</td>
		<td>".$railDirection."</td>
		<td>".$timeTableType."</td>
		<td>".$departureTime."</td>
		<td>".$destinationStation."</td>
		<td>".$trainType."</td>
		<td>".$isLast."</td>
		</tr>";
	}
}?>
</table>
<body>
</html>
<?php }	?>