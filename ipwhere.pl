#!/bin/env perl

# ./ipwhere.pl 8.8.8.8 8.8.8.6
use Data::Dumper;
use LWP::Simple;
use JSON;
binmode(STDOUT, ':encoding(utf8)');

print map{getTbeIParea()} validIP(@ARGV);

sub validIP(){
my $re=qr([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]);
my @ip=grep{/^($re\.){3}$re$/} @_;
return @ip;
}

sub getTbeIParea()
{
my $url=qq(http://ip.taobao.com/service/getIpInfo.php?ip=$_);
my $code = get($url);
my $json = new JSON;
my $obj = $json->decode($code);
my $ipArea="$obj->{data}->{ip}:$obj->{data}->{country},$obj->{data}->{region},$obj->{data}->{city},$obj->{data}->{isp}\n";
return $ipArea;
}

