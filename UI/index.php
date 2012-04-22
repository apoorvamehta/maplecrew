<?php

//Includes
require_once 'libs/Mustache.php';
require_once 'libs/MustacheLoader.php';

//Globals
$m = new Mustache();
$ml = new MustacheLoader(dirname(__FILE__).'/templates');


$data = array("img"=>"http://photos-h.ak.fbcdn.net/hphotos-ak-ash3/556524_10101142755271083_1229271_63317478_922457948_a.jpg", "caption"=>"Tonya");
for($i=0;$i<100;$i++) $c['interests'][] = $data;


echo $m->render($ml["header"], array());
//echo $m->render($ml["top"], array());

echo $m->render($ml["home"], $c);
echo $m->render($ml["footer"], array());




?>
