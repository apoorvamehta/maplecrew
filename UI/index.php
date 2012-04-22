<?php

//Includes
require_once 'libs/Mustache.php';
require_once 'libs/MustacheLoader.php';

//Globals
$m = new Mustache();
$ml = new MustacheLoader(dirname(__FILE__).'/templates');

echo $m->render($ml["header"], array());




?>
