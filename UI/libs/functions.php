<?php

function callAPI($call, $data) {
	
	$call = API_PATH.$call."?access_token=".$_COOKIE['access_token'];
	
	foreach($data as $k=>$v) $call .= $k."=".$v."&";
	
	$res = file_get_contents($call);
	$res = json_decode($res, true);
	
	return $res;
}

?>