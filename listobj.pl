#!/usr/bin/perl

use strict;
use warnings;

use EBox;
use EBox::Global;

EBox::init();
my $obj = EBox::Global->modInstance('objects');

my $objects_ref = $obj->objects();

foreach my $object_ref (@{$objects_ref}) {
    my $id = "${$object_ref}{'id'}";
	my $name = "${$object_ref}{'name'}";
	print "OBJ: $name\n";
    my $members_ref = $obj->objectMembers($id);

    foreach my $member_ref (@{$members_ref}) {
        my $name = ${$member_ref}{'name'};
		my $ipaddr = ${$member_ref}{'ipaddr'};
        print "\tHOST: $name $ipaddr\n";
	}
}

