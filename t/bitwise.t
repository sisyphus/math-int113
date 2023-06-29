use strict;
use warnings;
use Math::Int113;
use Config;

use Test::More;

if($Config{ivsize} != 8) {
  warn "Skipping tests - bitwise operators not yet available for perls whose ivsize is not 8";
  cmp_ok(1, '==', 1, "dummy test");
  done_testing();
  exit 0;
}

my $obj1 = Math::Int113->new(~0) * 54321;
my $obj2 = Math::Int113->new(~0) * 12345;

cmp_ok($obj1, '==', 1002045584827976553278415, "1st object assigned correctly");
cmp_ok($obj2, '==', 227725055589944414687175,  "2nd object assigned correctly");

cmp_ok($obj1 >> 5, '==', 31313924525874267289950, "1st >> 5 == 31313924525874267289950");
cmp_ok($obj2 >> 5, '==', 7116407987185762958974,  "2nd >> 5 == 7116407987185762958974");

cmp_ok($obj1 >> 64, '==', 54320, "1st >> 64 == 54320");
cmp_ok($obj2 >> 64, '==', 12344, "2nd >> 64 == 12344");

cmp_ok($obj1 << 11, '==', 2052189357727695981114193920, "1st << 11 == 2052189357727695981114193920");
cmp_ok($obj2 << 11, '==', 466380913848206161279334400,  "2nd << 11 == 466380913848206161279334400");

cmp_ok($obj1 & $obj2, '==', 76461754185526091385799, "1st & 2nd evaluates correctly");
cmp_ok($obj1 | $obj2, '==', 1153308886232394876579791, "1st | 2nd evaluates correctly");
cmp_ok($obj1 ^ $obj2, '==', 1076847132046868785193992, "1st ^ 2nd evaluates correctly");

my $not_obj1 = ~$obj1;
my $not_obj2 = ~$obj2;

cmp_ok($not_obj1, '==', 10384593716067609672233016105161776, "~1st evaluates correctly");
cmp_ok($not_obj2, '==', 10384593716841930201471048243753016, "~2nd evaluates correctly");

cmp_ok(~$not_obj1, '==', $obj1, "~(~1st) evaluates correctly");
cmp_ok(~$not_obj2, '==', $obj2, "~(~2nd) evaluates correctly");


done_testing();
