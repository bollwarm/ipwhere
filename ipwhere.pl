#!/bin/env perl

# ./ipwhere.pl 8.8.8.8 8.8.8.6
use Data::Dumper;
use LWP::Simple;
use JSON;
use Encode;
#binmode(STDOUT, ':encoding(utf8)');

print map{getTbeIParea($_)} validIP(@ARGV);
#print map{getSinaIParea($_)} validIP(@ARGV);
print map{getBaiduIParea($_)} validIP(@ARGV);
print map{getPcoIParea($_)} validIP(@ARGV);
my %ipcache;

sub validIP(){
my $re=qr([0-9]|[0-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5]);
my @ip=grep{/^($re\.){3}$re$/} @_;
return @ip;
}

sub gbk2utf {

  my $str=shift;
  return encode("utf-8", decode("gbk", $str));
  return;

}


sub cached {
    my $ip  = shift;
    print "DEBUG\::cached\::IN $input\n" if $DEBUG;
    return $cache{$ip} ? 1 : 0;
}

sub clear {

    my $ip  = shift;
   print "DEBUG\::clear\::IN $ip\n" if $DEBUG;
    if ($ip) {
        undef $cache{$ip};
    }
    else {
        undef %cache;
    }
}

sub getBaiduIParea()
{

my $ip=shift;
my $key="BD_".$ip;
#return encode("utf-8",$ipcache{$key}) if exists($ipcache{$key});

my $url=qq(http://opendata.baidu.com/api.php?query=$ip&co=&resource_id=6006&t=1433920989928&ie=utf8&oe=gbk&format=json);
my $code = get($url);
#my $jso=$1 if $code =~/var remote_ip_info =(.*);$/;
print $code,"\n"  if $DEBUG;
my $json = new JSON;
my $obj = $json->decode($code) if $code;
print Dumper($obj),"\n" if $DEBUG;
print "baidu $_:$obj->{msg}\n"  if $DEBUG;
my $ipArea="baidu $_:$obj->{data}->[0]->{location}\n";
$ipcache{$key}=$ipArea;
return gbk2utf($ipArea);
}
sub getPcoIParea()
{

my $ip=shift;
my $key="pco_".$ip;
return encode("utf-8",$ipcache{$key}) if exists($ipcache{$key});
#print $ip,"\n";
my $url=qq(http://whois.pconline.com.cn/ipJson.jsp?callback=YSD&ip=$ip);
my $code = get($url);
#print $code,"\n";
my $jso=$1 if $code =~/\{YSD\((.*)\)\;\}$/ms;
#print $jso,"\n";
my $json = new JSON;
my $obj = $json->decode($jso) if $jso;
#print Dumper($obj),"\n";
#print "pconline $_:$obj->{msg}\n if $DEBUG";
my $ipArea="pconline $_:$obj->{pro},$obj->{city},$obj->{region},$obj->{addr}\n";
$ipcache{$key}=$ipArea;
return encode("utf-8", $ipArea);
}
sub getSinaIParea()
{
my $ip=shift;
my $key="SL_".$ip;
return encode("utf-8",$ipcache{$key}) if exists($ipcache{$key});
my $url=qq(http://int.dpool.sina.com.cn/iplookup/iplookup.php?format=js&ip=$ip);
my $code = get($url);
my $jso=$1 if $code =~/var remote_ip_info =(.*);$/;
#print $jso,"\n";
my $json = new JSON;
my $obj = $json->decode($jso);
#print Dumper($obj),"\n";
my $ipArea="sina $_:$obj->{country},$obj->{province},$obj->{city},$obj->{isp}\n";
$ipcache{$key}=$ipArea;
return encode("utf-8", $ipArea);
}

sub getTbeIParea()
{
my $ip=shift;
my $key="TB_".$ip;
unless (exists($ipcache{$key})){
my $url=qq(http://ip.taobao.com/service/getIpInfo.php?ip=$ip);
my $code = get($url);
#print Dumper($code),"\n";
my $json = new JSON;
my $obj = $json->decode($code) if $code;
my $ipArea="taobao $obj->{data}->{ip}:$obj->{data}->{country},$obj->{data}->{region},$obj->{data}->{city},$obj->{data}->{isp}\n";
$ipcache{$key}=$ipArea;

return encode("utf-8", $ipArea);
}else {return encode("utf-8",$ipcache{$key});

}

}

