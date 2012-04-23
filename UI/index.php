<?php

//Includes
require_once 'libs/Mustache.php';
require_once 'libs/MustacheLoader.php';
require_once 'libs/functions.php';

//Globals
define("API_PATH", "http://maplecrew.herokuapp.com/api/");
$m = new Mustache();
$ml = new MustacheLoader(dirname(__FILE__).'/templates');


$data[0] = array("img"=>"http://photos-h.ak.fbcdn.net/hphotos-ak-ash3/556524_10101142755271083_1229271_63317478_922457948_a.jpg", "img_big"=>"http://photos-h.ak.fbcdn.net/hphotos-ak-ash3/s720x720/556524_10101142755271083_1229271_63317478_922457948_n.jpg", "name"=>"Tonya", "caption"=>"test 123...");
$data[1] = array("img"=>"http://photos-a.ak.fbcdn.net/hphotos-ak-ash3/561876_10101142759208193_1229271_63317497_829744965_a.jpg", "img_big"=>"http://photos-a.ak.fbcdn.net/hphotos-ak-ash3/s720x720/561876_10101142759208193_1229271_63317497_829744965_n.jpg", "name"=>"Tonya", "caption"=>"test 123...");
for($i=0;$i<100;$i++) $c['interests'][] = $data[rand(0,1)];

if($_REQUEST['page']) $c['page'] = $_REQUEST['page']+1;
else $c['page'] = 1;

if($_REQUEST['use_api'] || 1) {
	$c['interests'] = callAPI("board", array("index"=>$c['page']-1));
	//$c['interests'] = json_decode(file_get_contents("boardjson.txt"), true);
	//var_dump($c);
	//exit;
}



//routes
switch($_REQUEST['section']) {
	
	case "interests" :
		//$c['interests'] = callAPI("board", array("limit"=>100, "index"=>0));
		echo $m->render($ml["home"], $c);
		break;

	case "add_interests":
		//$c['interests'] = callAPI("board", array("limit"=>100, "index"=>0));
		echo $m->render($ml["header"], array());
		//echo $m->render($ml["top"], array());
		echo $m->render($ml["add_interests"], $c);
		echo $m->render($ml["footer"], array());
		break;
	
	default:
		//$c['interests'] = callAPI("board", array("limit"=>100, "index"=>0));
		echo $m->render($ml["header"], array());
		//echo $m->render($ml["top"], array());
		echo $m->render($ml["home"], $c);
		echo $m->render($ml["footer"], array());
		break;
}






?>
