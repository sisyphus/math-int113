# The coverage() function, run with various arguments.
use strict;
use warnings;
use Math::Int113 qw(coverage);

use Test::More;

###############################################
# If the precision of the IV is 64 bits and the precision of the NV is 53 bits,
# then how many integer values in the range 1..(2**113)-1 are representible
# and how many are unrepresentible.

my($count_in, $count_out) = coverage(64, 53, 113);

cmp_ok($count_in, '==', 18888096837191860223, "64 53 113: Representible ok");
cmp_ok($count_out, '==', 10384593717069636368964155466579968, "64 53 113: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', 10384593717069655257060992658440191, "64 53 113: sum correct");

###############################################
# If the precision of the IV is 64 bits and the precision of the NV is 53 bits,
# then how many integer values in the range -((2**113)-1)..-1 are representible
# and how many are unrepresentible.

($count_in, $count_out) = coverage(63, 53, 113);

cmp_ok($count_in, '==', 9673731999591825407, "63 53 113: Representible ok");
cmp_ok($count_out, '==', 10384593717069645583328993066614784, "63 53 113: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', 10384593717069655257060992658440191, "63 53 113: sum correct");

###############################################
# If the precision of the IV is 64 bits and the precision of the NV is 64 bits,
# then how many integer values in the range 1..(2**113)-1 are representible
# and how many are unrepresentible.

($count_in, $count_out) = coverage(64, 64, 113);

cmp_ok($count_in, '==', 922337203685477580799, "64 64 113: Representible ok");
cmp_ok($count_out, '==', 10384593717068732919857307180859392, "64 64 113: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', 10384593717069655257060992658440191, "64 64 113: sum correct");

###############################################
# If the precision of the IV is 64 bits and the precision of the NV is 64 bits,
# then how many integer values in the range -((2**113)-1)..-1 are representible
# and how many are unrepresentible.

($count_in, $count_out) = coverage(63, 64, 113); # Should be the same as coverage(64, 64, 113);

cmp_ok($count_in, '==', 922337203685477580799, "63 64 113: Representible ok");
cmp_ok($count_out, '==', 10384593717068732919857307180859392, "63 64 113: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', 10384593717069655257060992658440191, "63 64 113: sum correct");

###############################################
# If the precision of the IV is 32 bits and the precision of the NV is 53 bits,
# then how many integer values in the range 1..(2**64)-1 are representible
# and how many are unrepresentible.

($count_in, $count_out) = coverage(32, 53, 64);

cmp_ok($count_in, '==', 108086391056891903, "32 53 64: Representible ok");
cmp_ok($count_out, '==', 18338657682652659712, "32 53 64: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', (2 ** 64) - 1, "32 53 64: sum correct");

###############################################
# If the precision of the IV is 32 bits and the precision of the NV is 53 bits,
# then how many integer values in the range -((2**64)-1)..-1 are representible
# and how many are unrepresentible.

($count_in, $count_out) = coverage(31, 53, 64); # Should be the same as coverage(32, 53, 64);

cmp_ok($count_in, '==', 108086391056891903, "31 53 64: Representible ok");
cmp_ok($count_out, '==', 18338657682652659712, "31 53 64: Unrepresentible ok");
cmp_ok($count_out + $count_in, '==', (2 ** 64) - 1, "31 53 64: sum correct");

# TODO (64, 53, 64) (63, 53, 64)

done_testing();


