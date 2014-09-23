#! /usr/bin/perl

%map = ('a',1,'b',2);

if(exists($map{'c'}))
{
	$map{'c'}++;
}
else
{
	$map{'c'} = 1;
}

print("$map{'c'}\n");
$size = keys %map;
print("$size\n");