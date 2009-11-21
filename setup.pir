#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

Currently, the only dependency is 'prove' (in 'test' step).

=head1 USAGE

    $ parrot setup.pir
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    load_bytecode 'distutils.pbc'

    # build
    $P0 = new 'Hash'
    $P1 = new 'Hash'
    $P1['Math/Random/mt19937ar.pbc'] = 'Math/Random/mt19937ar.pir'
    $P0['pbc_pir'] = $P1

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    # install
    $P0['inst_lib'] = 'Math/Random/mt19937ar.pbc'

    # build doc
    $P4 = new 'Hash'
    $P4['Math/Random/mt19937ar.html'] = 'Math/Random/mt19937ar.pir'
    $P0['html_pod'] = $P4

    .tailcall setup(args :flat, $P0 :flat :named)
.end

=pod p6

    setup(
        :pbc_pir( {
            'Math/Random/mt19937ar.pbc' => 'Math/Random/mt19937ar.pir',
        } ),
        :prove_exec( get_parrot() ),
        :inst_lib( 'Math/Random/mt19937ar.pbc' ),
        :html_pod( {
            'Math/Random/mt19937ar.html' => 'Math/Random/mt19937ar.pir',
        } )
    );

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
