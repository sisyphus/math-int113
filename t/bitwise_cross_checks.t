# Cross check Math::Int113 bitwise operations against Math::BigInt,
# Math::GMPz (if available) and Math::GMP (if available).
use strict;
use warnings;
use Math::Int113;
use Math::BigInt;
use Test::More;

END { done_testing(); };

my ($gmpz, $gmp) = (1, 1);

eval {require Math::GMPz;};
$gmpz = 0 if($@);

eval {require Math::GMP;};
$gmp = 0 if($@);

my @objects = ("Math::BigInt");
if($gmpz) { push @objects, "Math::GMPz" }
if($gmp)  { push @objects, "Math::GMP"  }

my($max_obj, $max_int113);

for my $obj(@objects) {
  $max_obj = ($obj->new(1) << 113) - 1;
  $max_int113 = Math::Int113->new("$max_obj");

  for(1 .. 10) {
    my $neg = int(rand(~0)) * -1;
    my $pos = int(rand(~0));
    my $pos_113 = Math::Int113->new($pos);
    my $comp_113 = ~(Math::Int113->new(-$neg)) + 1;
    my $pos_obj = $obj->new($pos);
    my $comp_obj = complement($obj->new($neg));

    cmp_ok($comp_113, '==', Math::Int113->new("$comp_obj"), "A: Math::Int113 and $obj complements match");

    my $and_113 = $pos_113 & $comp_113;
    my $and_obj = $pos_obj & $comp_obj;
    cmp_ok("$and_113", 'eq', "$and_obj", "A: &: Math::Int113 and $obj concur");

    my $or_113 = $pos_113 | $comp_113;
    my $or_obj = $pos_obj | $comp_obj;
    cmp_ok("$or_113", 'eq', "$or_obj", "A: |: Math::Int113 and $obj concur");

    my $xor_113 = $pos_113 ^ $comp_113;
    my $xor_obj = $pos_obj ^ $comp_obj;
    cmp_ok("$xor_113", 'eq', "$xor_obj", "A: ^: Math::Int113 and $obj concur");
  }

  for(1 .. 10) {
    my $neg = int(rand(~0)) * -1;
    my $pos = int(rand(~0));
    my $pos_113 = Math::Int113->new($pos);
    my $comp_113 = ~(Math::Int113->new(-$neg) * 70000000000) + 1;
    my $pos_obj = $obj->new($pos);
    my $comp_obj = complement($obj->new($neg) * 70000000000);

    cmp_ok($comp_113, '==', Math::Int113->new("$comp_obj"), "B: Math::Int113 and $obj complements match");

    my $and_113 = $pos_113 & $comp_113;
    my $and_obj = $pos_obj & $comp_obj;
    cmp_ok("$and_113", 'eq', "$and_obj", "B: &: Math::Int113 and $obj concur");

    my $or_113 = $pos_113 | $comp_113;
    my $or_obj = $pos_obj | $comp_obj;
    cmp_ok("$or_113", 'eq', "$or_obj", "B: |: Math::Int113 and $obj concur");

    my $xor_113 = $pos_113 ^ $comp_113;
    my $xor_obj = $pos_obj ^ $comp_obj;
    cmp_ok("$xor_113", 'eq', "$xor_obj", "B: ^: Math::Int113 and $obj concur");
  }

  for(1 .. 10) {
    my $neg = int(rand(~0)) * -1;
    my $pos = int(rand(~0));
    my $pos_113 = Math::Int113->new($pos) * 70000000000;
    my $comp_113 = ~(Math::Int113->new(-$neg) * 70000000000) + 1;
    my $pos_obj = $obj->new($pos) * 70000000000;
    my $comp_obj = complement($obj->new($neg) * 70000000000);

    cmp_ok($comp_113, '==', Math::Int113->new("$comp_obj"), "C: Math::Int113 and $obj complements match");

    my $and_113 = $pos_113 & $comp_113;
    my $and_obj = $pos_obj & $comp_obj;
    cmp_ok("$and_113", 'eq', "$and_obj", "C: &: Math::Int113 and $obj concur");

    my $or_113 = $pos_113 | $comp_113;
    my $or_obj = $pos_obj | $comp_obj;
    cmp_ok("$or_113", 'eq', "$or_obj", "C: |: Math::Int113 and $obj concur");

    my $xor_113 = $pos_113 ^ $comp_113;
    my $xor_obj = $pos_obj ^ $comp_obj;
    cmp_ok("$xor_113", 'eq', "$xor_obj", "C: ^: Math::Int113 and $obj concur");
  }

  for(1 .. 10) {
    my $neg = int(rand(10000)) * -1;
    my $pos = int(rand(~0));
    my $pos_113 = Math::Int113->new($pos);
    my $comp_113 = ~(Math::Int113->new(-$neg)) + 1;
    my $pos_obj = $obj->new($pos);
    my $comp_obj = complement($obj->new($neg));

    cmp_ok($comp_113, '==', Math::Int113->new("$comp_obj"), "D: Math::Int113 and $obj complements match");

    my $and_113 = $pos_113 & $comp_113;
    my $and_obj = $pos_obj & $comp_obj;
    cmp_ok("$and_113", 'eq', "$and_obj", "D: &: Math::Int113 and $obj concur");

    my $or_113 = $pos_113 | $comp_113;
    my $or_obj = $pos_obj | $comp_obj;
    cmp_ok("$or_113", 'eq', "$or_obj", "D: |: Math::Int113 and $obj concur");

    my $xor_113 = $pos_113 ^ $comp_113;
    my $xor_obj = $pos_obj ^ $comp_obj;
    cmp_ok("$xor_113", 'eq', "$xor_obj", "D: ^: Math::Int113 and $obj concur");
  }
}

###################################################################################
###################################################################################
###################################################################################

sub complement {
  if($_[0] < 0) {
    return ($max_obj + $_[0]) + 1;
  }
}
