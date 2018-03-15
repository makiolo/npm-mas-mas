<?php

$stats = 'stats.txt';

// class MutexStatic {
// 	public static $handler = Mutex::create();
//
// 	public function lock()
// 	{
// 		Mutex::lock($handler);
// 	}
//
// 	public function unlock()
// 	{
// 		Mutex::unlock($handler);
// 	}
// }
//
// $mutex = new MutexStatic();


// scheme
// 		0 -> counter
//		1 -> last_download

function read_stats()
{
	global $stats;
	// global $mutex;
    //
	// $mutex->lock();

	if(file_exists($stats))
	{
		if (!is_writable($stats))
		{
			 echo "Cannot write in file ($stats) !!<br /><br />";
		};
		$f = fopen($stats, 'r');
		$data = fread($f, filesize($stats));
		$data = unserialize($data);
		fclose($f);
	}
	else
	{
		$data = array();
	}

	// $mutex->unlock();

	return $data;
}

function inc_stats($data, $key)
{
	$key = basename($key);

	if(array_key_exists($key, $data))
	{
		$data[$key][0] = $data[$key][0] + 1;
		$data[$key][1] = new DateTime('NOW');
	}
	else
	{
		$data[$key] = array(1, new DateTime('NOW'));
	}
	return $data;
}

function get_hits($data, $key)
{
	$key = basename($key);

	if(array_key_exists($key, $data))
	{
		return $data[$key];
	}
	else
	{
		return array(0, NULL);
	}
}

function write_stats($data)
{
	global $stats;
	// global $mutex;
    //
	// $mutex->lock();

	$f = fopen($stats, 'w');
	$data = serialize($data);
	fwrite($f, $data);
	fclose($f);

	// $mutex->unlock();
}

?>

