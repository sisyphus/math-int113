package Math::Int113;
use strict;
use warnings;
use Config;

$Math::Int113::VERSION = '0.01';

use constant  IVSIZE_IS_8  => $Config{ivsize} == 8 ? 1 : 0;

use overload
'+'    => \&oload_add,
'-'    => \&oload_sub,
'*'    => \&oload_mul,
'/'    => \&oload_div,
'**'   => \&oload_pow,
'++'   => \&oload_inc,
'--'   => \&oload_dec,
'>='   => \&oload_gte,
'<='   => \&oload_lte,
'=='   => \&oload_equiv,
'>'    => \&oload_gt,
'<'    => \&oload_lt,
'<=>'  => \&oload_spaceship,
'""'   => \&oload_stringify,
'&'    => \&oload_and,
'|'    => \&oload_or,
'^'    => \&oload_xor,
'~'    => \&oload_not,
'>>'   => \&oload_rshift,
'<<'   => \&oload_lshift,
;

if($Config{nvtype} ne '__float128') {
   if($Config{nvtype} ne 'long double' &&
      $Config{longdblkind} != 1        &&
      $Config{longdblkind} != 2) {
      die "Bailing out: NV must be either IEEE 754 long double or __float128";
  }
}

sub new {
  shift if(!ref($_[0]) && $_[0] eq "Math::Int113"); # 'new' has been called as a method

  if(ref($_[0]) eq "Math::Int113") {
    # return a copy of the given Math::Int113 object
    my $ret = shift;
    return $ret;
  }

  my $v = shift;
    if(overflows($v)) {
    my($package, $filename, $line) = caller;
    warn "overlow in package $package, file $filename, at line $line\n";
    die "Arg (", sprintf("%.36g", $v), "), given to new(), overflows 113 bits";
  }
  my %h = ('val' => int($v));
  return bless(\%h, 'Math::Int113');
}

sub overflows {
  my $v = shift;
  return 1
    if($v >=  1.0384593717069655257060992658440192e34 ||
       $v <= -1.0384593717069655257060992658440192e34);
  return 0;
}

sub oload_add {
  my($_1, $_2) = (shift, shift);
  if(ref($_2) eq 'Math::Int113') { return Math::Int113->new($_1->{val} + $_2->{val}) }

  die "Overflow in arg (", sprintf("%.36g", $_2), ") given to overloaded addition"
    if overflows(int($_2));

  return Math::Int113->new($_1->{val} + int($_2));
}

sub oload_mul {
  my($_1, $_2) = (shift, shift);
  if(ref($_2) eq 'Math::Int113') { return Math::Int113->new($_1->{val} * $_2->{val}) }

  die "Overflow in arg (", sprintf("%.36g", $_2), ") given to overloaded multiplication"
    if overflows(int($_2));

  return Math::Int113->new($_1->{val} * int($_2));
}

sub oload_sub {
  my($_1, $_2, $_3) = (shift, shift, shift);
  if(ref($_2) eq 'Math::Int113') {
    return Math::Int113->new($_2->{val} - $_1->{val})
      if $_3;
    return Math::Int113->new($_1->{val} - $_2->{val})
  }

  die "Overflow in arg (", sprintf("%.36g", $_2), ") given to overloaded subtraction"
    if overflows(int($_2));

  return Math::Int113->new(int(int($_2) - $_1->{val}))
    if $_3;
  return Math::Int113->new(int($_1->{val} - int($_2)));
}

sub oload_div {
  my($_1, $_2, $_3) = (shift, shift, shift);
  if(ref($_2) eq 'Math::Int113') {
    return Math::Int113->new(int($_2->{val} / $_1->{val}))
      if $_3;
    return Math::Int113->new(int($_1->{val} / $_2->{val}))
  }

  die "Overflow in arg (", sprintf("%.36g", $_2), ") given to overloaded division"
    if overflows(int($_2));

  return Math::Int113->new(int(int($_2) / $_1->{val}))
    if $_3;
  return Math::Int113->new(int($_1->{val} / int($_2)));
}

sub oload_pow {
  my($_1, $_2, $_3) = (shift, shift, shift);
  if(ref($_2) eq 'Math::Int113') {
    return Math::Int113->new(int($_2->{val} ** $_1->{val}))
      if $_3;
    return Math::Int113->new(int($_1->{val} ** $_2->{val}))
  }

  die "Overflow in arg (", sprintf("%.36g", $_2), ") given to overloaded division"
    if overflows(int($_2));
  # If $_2 is a fractional value, it remains unaltered.
  return Math::Int113->new($_2 ** $_1->{val})
    if $_3;
  return Math::Int113->new($_1->{val} ** $_2);
}

###################################
sub oload_gte {
  my $cmp = oload_spaceship($_[0], $_[1], $_[2]);
  return 1 if $cmp >= 0;
  return 0;
}

sub oload_lte {
  my $cmp = oload_spaceship($_[0], $_[1], $_[2]);
  return 1 if $cmp <= 0;
  return 0;
}

sub oload_equiv {
  return 1 if(oload_spaceship($_[0], $_[1], $_[2]) == 0);
  return 0;
}

sub oload_gt {
  my $cmp = oload_spaceship($_[0], $_[1], $_[2]);
  return 1 if $cmp > 0;
  return 0;
}

sub oload_lt {
  my $cmp = oload_spaceship($_[0], $_[1], $_[2]);
  return 1 if $cmp < 0;
  return 0;
}
###################################

sub oload_spaceship {
  my($_1, $_2, $_3) = (shift, shift, shift);

  if(ref($_2) eq 'Math::Int113') {
    if($_3) {
      return $_2->{val} <=> $_1->{val};
    }
    return $_1->{val} <=> $_2->{val};
  }

  if($_3) {
    return int($_2) <=> $_1->{val};
  }

  return $_1->{val} <=> int($_2);
}

sub oload_inc {
  die "$_[0] overflows '++'"
    unless $_[0] < 1.0384593717069655257060992658440192e34 ;
  ($_[0]->{val})++;
}

sub oload_dec {
  die "$_[0] overflows '--'"
    unless $_[0] > -1.0384593717069655257060992658440192e34 ;
  ($_[0]->{val})--;
}

sub oload_stringify {
  my $self = shift;
  return sprintf("%.36g", $self->{val});
}

sub oload_rshift {
  my($_1, $_2) = (shift, shift);

  die ">> not done on negative value ($_1)"
    if $_1 < 0;
  die "Cannot right shift by a negative amount ($_2)"
    if $_2 < 0;

  if(ref($_2) eq 'Math::Int113') {
    return $_1 / (2 ** ($_2->{val}));
  }

  # No need to throw an error if overflows($_2)

  return $_1 / (2 ** int($_2));
}

sub oload_lshift {
  my($_1, $_2) = (shift, shift);

  die "<< not done on negative value ($_1)"
    if $_1 < 0;
  die "Cannot left shift by a negative amount ($_2)"
    if $_2 < 0;

  if(ref($_2) eq 'Math::Int113') {
    return $_1 * (2 ** ($_2->{val}));
  }

  # No need to throw an error if overflows($_2)

  return $_1 *  (2 ** int($_2));
}

sub oload_and {
  if(IVSIZE_IS_8) {
    my($_1, $_2) = (shift, shift);

    die "& not done on negative value ($_1)"
      if $_1 < 0;
    die "& not done on negative value ($_2)"
      if $_2 < 0;

    my($hi_1, $lo_1) = hi_lo($_1);
    my($hi_2, $lo_2) = hi_lo($_2);

    my $hi = $hi_1->{val} & $hi_2->{val};
    $hi *= 2 ** 64;

    my $lo = $lo_1->{val} & $lo_2->{val};

    return Math::Int113->new($hi + $lo);
  }
  else {
    die "Bitwise (&) operations not yet implemented when $Config{ivsize} is 4";
  }
}

sub oload_or {
  if(IVSIZE_IS_8) {
    my($_1, $_2) = (shift, shift);

    die "| not done on negative value ($_1)"
      if $_1 < 0;
    die "| not done on negative value ($_2)"
      if $_2 < 0;

    my($hi_1, $lo_1) = hi_lo($_1);
    my($hi_2, $lo_2) = hi_lo($_2);

    my $hi = $hi_1->{val} | $hi_2->{val};
    $hi *= 2 ** 64;

    my $lo = $lo_1->{val} | $lo_2->{val};

    return Math::Int113->new($hi + $lo);
  }
  else {
    die "Bitwise (|) operations not yet implemented when $Config{ivsize} is 4";
  }
}

sub oload_xor {
  if(IVSIZE_IS_8) {
    my($_1, $_2) = (shift, shift);

    die "^ not done on negative value ($_1)"
      if $_1 < 0;
    die "^ not done on negative value ($_2)"
      if $_2 < 0;

    my($hi_1, $lo_1) = hi_lo($_1);
    my($hi_2, $lo_2) = hi_lo($_2);

    my $hi = $hi_1->{val} ^ $hi_2->{val};
    $hi *= 2 ** 64;

    my $lo = $lo_1->{val} ^ $lo_2->{val};

    return Math::Int113->new($hi + $lo);
  }
  else {
    die "Bitwise (^) operations not yet implemented when $Config{ivsize} is 4";
  }
}

sub oload_not {
  if(IVSIZE_IS_8) {
    my($_1) = (shift);

    die "~ not done on negative value ($_1)"
      if $_1 < 0;

    my($hi_1, $lo_1) = hi_lo($_1);

    my $mask = (2 ** 49) - 1;
    my $hi = ~($hi_1->{val});
    $hi &= $mask;
    $hi *= 2 ** 64;

    my $lo = ~($lo_1->{val});

    return Math::Int113->new($hi + $lo);
  }
  else {
    die "Bitwise (~) operations not yet implemented when $Config{ivsize} is 4";
  }
}

sub hi_lo {
  my($hi, $lo, $obj);
  if(ref($_[0]) eq 'Math::Int 113') {
    $obj = shift;
  }
  else {
    $obj = Math::Int113->new(shift);
  }

  $hi = $obj >> 64;
  my $intermediate = $hi * (2 ** 64);
  $lo = $obj - $intermediate;

  return ($hi, $lo);
}
1;

