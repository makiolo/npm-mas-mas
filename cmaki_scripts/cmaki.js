#!/usr/bin/env node
var os = require('os')
var fs = require('fs');
var path = require('path')
var shelljs = require('shelljs');

if(!process.env.CMAKI_PWD)
{
	if (fs.existsSync(path.join("..", "..", "node_modules", "cmaki_scripts"))) {
		shelljs.env['CMAKI_PWD'] = path.join(process.cwd(), '..', '..');
		process.env['CMAKI_PWD'] = path.join(process.cwd(), '..', '..');
	} else {
		shelljs.env['CMAKI_PWD'] = path.join(process.cwd());
		process.env['CMAKI_PWD'] = path.join(process.cwd());
	}
}
else
{
	shelljs.env['CMAKI_PWD'] = process.env['CMAKI_PWD'];
}

if(!process.env.CMAKI_INSTALL)
{
	shelljs.env['CMAKI_INSTALL'] = path.join(process.env['CMAKI_PWD'], 'bin');
	process.env['CMAKI_INSTALL'] = path.join(process.env['CMAKI_PWD'], 'bin');
}
else
{
	shelljs.env['CMAKI_INSTALL'] = process.env['CMAKI_INSTALL'];
}

if(!process.env.MODE)
{
	shelljs.env['MODE'] = 'Debug';
	process.env['MODE'] = 'Debug';
}
else
{
	shelljs.env['MODE'] = process.env['MODE'];
}

function trim(s)
{
	return ( s || '' ).replace( /^\s+|\s+$/g, '' );
}

var environment_vars = [];
next_is_environment_var = false;
process.argv.forEach(function(val, index, array)
{
	if(next_is_environment_var)
	{
		environment_vars.push(val);
	}
	next_is_environment_var = (val == '-e');
});
environment_vars.forEach(function(val, index, array)
{
	var chunks = val.split("=");
	if( chunks.length == 2 )
	{
		shelljs.env[chunks[0]] = chunks[1];
		process.env[chunks[0]] = chunks[1];
	}
	else
	{
		console.log("Error in -e with value: " + val)
	}
});

var is_win = (os.platform() === 'win32');
var dir_script;
var script = process.argv[2];
if (is_win)
{
	if(fs.existsSync(path.join(process.cwd(), script+".cmd")))
	{
		dir_script = process.cwd();
	}
	else
	{
		dir_script = path.join(process.env['CMAKI_PWD'], 'node_modules', 'cmaki_scripts');
	}
}
else
{
	if(fs.existsSync(path.join(process.cwd(), script+".sh")))
	{
		dir_script = process.cwd();
	}
	else
	{
		dir_script = path.join(process.env['CMAKI_PWD'], 'node_modules', 'cmaki_scripts');
	}
}

if (is_win)
{
	script_execute = path.join(dir_script, script+".cmd");
	exists = fs.existsSync(script_execute)
	caller_execute = "cmd /c "
	script_execute = script_execute.replace(/\//g, "\\");
}
else
{
	script_execute = path.join(dir_script, script+".sh");
	exists = fs.existsSync(script_execute)
	caller_execute = "bash "
	script_execute = script_execute.replace(/\\/g, "/");
}

if(exists)
{
	var child = shelljs.exec(caller_execute + script_execute, {async:true, silent:true}, function(err, stdout, stderr) {
		process.exit(err);
	});
	child.stdout.on('data', function(data) {
		console.log(trim(data));
	});
	child.stderr.on('data', function(data) {
		console.log(trim(data));
	});
}
else
{
	console.log("[error] dont exits: " + script_execute);
	process.exit(1);
}

