#!/usr/bin/perl

use lib '/usr/end70/mnt/admin/perl';
use Locale::US;


$code='CA';
$state='California';

print code2state($code), $/;
print state2code($state), $/;
print join ':', sort ( &all_state_codes() ), $/;
print join ':', sort ( &all_state_names() ), $/;

%C = &all_code_hash;
%S = &all_state_hash;


print $C{'Wyoming'},$/;
print $S{WY},$/;


$R=&all_state_codes_ref();
print @{$R},$/;

$R=&all_state_names_ref();
print @{$R},$/;

