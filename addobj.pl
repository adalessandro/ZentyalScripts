#!/usr/bin/perl

use strict;
use warnings;

use EBox;
use EBox::Global;

EBox::init();
my $obj = EBox::Global->modInstance('objects');

my $input_file = 'iphpr.csv';
my $split_char = ';';

my @members;  # obj's members array
my $objname;  # obj's name

# archivo = ( linea_obj (linea_host)* )*
# linea_obj = objname;
# linea_host = hostname; subred; ip_host;
# importante que cada linea termine con ;
open (my $HOSTS, $input_file);

while (my $line = <$HOSTS>) {
    chomp ($line);
    my ($hostname, $subred, $ip_host, $mac_addr) = split($split_char, $line);
    if (not $objname) {  # first line is a linea_obj
        $objname = $hostname;  # set the obj's name
    }
    elsif (not $ip_host) {  # in case of a reading linea_obj
        my $res=$obj->addObject( name => $objname, members => \@members );  # add obj
        $objname = $hostname;  # set the new obj's name
        @members = ();  # reset members array
    }
    else {  # otherwise it's a linea_host
        my $ip_addr = '19.54.' . $subred . '.' . $ip_host;
        if ($mac_addr) {
            push(@members, {name=>$hostname,  # add host to the members array
                            address_selected=>'ipaddr',
                            ipaddr_ip=>$ip_addr, 
                            ipaddr_mask=> '32',
                            macaddr=>$mac_addr});
        }
        else {
            push(@members, {name=>$hostname,  # add host to the members array
                            address_selected=>'ipaddr',
                            ipaddr_ip=>$ip_addr, 
                            ipaddr_mask=> '32'});
        }
    }
}

my $res=$obj->addObject( name => $objname, members => \@members );  # add last obj

