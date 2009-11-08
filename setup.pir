#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

Currently, the only dependency is 'prove' (in 'test' step).

Note: this setup.pir is a toy for Plumage.

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    $P0 = new 'Hash'
    $P1 = new 'Hash'
    $P2 = split " ", "Math/Random/mt19937ar.pir"
    $P1['Math/Random/mt19937ar.pbc'] = $P2
    $P0['pbc_pir'] = $P1
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0
    $P3 = split " ", "Math/Random/mt19937ar.pbc"
    $P0['inst_lib'] = $P3
    .tailcall setup(args :flat, $P0 :flat :named)
.end

=pod p6

    setup(
        :pbc_pir( {
            'Math/Random/mt19937ar.pbc' => [ 'Math/Random/mt19937ar.pir' ],
        } ),
        :prove_exec( get_parrot() ),
        :inst_lib( [ 'Math/Random/mt19937ar.pbc' ] )
    );

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
