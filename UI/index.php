<?php

//Globals
$m = new Mustache();
$ml = new MustacheLoader(dirname(__FILE__).'/templates');

$m->render($ml["header"], array());




?>
