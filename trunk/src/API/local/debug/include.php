<?php
function read_from_local($filename)
{
	$handle=fopen($filename,"r");
	$content=fread($handle,filesize($filename));
	fclose($handle);
	return $content;
};

function read_from_server($url)
{
	$ctx=stream_context_create(array(
			'http' => array(
		       'timeout' => 1
		    )
		)
	);
	return file_get_contents($url,0,$ctx);
};
?>