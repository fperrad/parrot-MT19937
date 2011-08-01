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

    $P0 = new 'Hash'
    $P0['name'] = 'mt19937'
    $P0['abstract'] = 'Mersenne Twisted pseudorandom number generator'
    $P0['authority'] = 'http://github.com/fperrad'
    $P0['description'] = 'Mersenne Twisted pseudorandom number generator in PIR for Parrot VM.'
    $P1 = split ',', 'random,prng'
    $P0['keywords'] = $P1
    $P0['license_type'] = 'Artistic License 2.0'
    $P0['license_uri'] = 'http://www.perlfoundation.org/artistic_license_2_0'
    $P0['copyright_holder'] = 'Parrot Foundation'
    $P0['checkout_uri'] = 'git://github.com/fperrad/parrot-MT19937.git'
    $P0['browser_uri'] = 'http://github.com/fperrad/parrot-MT19937'
    $P0['project_uri'] = 'http://github.com/fperrad/parrot-MT19937'

    # build
    $P2 = new 'Hash'
    $P2['Math/Random/mt19937ar.pbc'] = 'Math/Random/mt19937ar.pir'
    $P0['pbc_pir'] = $P2

    # test
    $S0 = get_parrot()
    $P0['prove_exec'] = $S0

    # install
    $P0['inst_lib'] = 'Math/Random/mt19937ar.pbc'

    # build doc
    $P3 = new 'Hash'
    $P3['Math/Random/mt19937ar.html'] = 'Math/Random/mt19937ar.pir'
    $P0['html_pod'] = $P3

    # build man
    $P4 = new 'Hash'
    $P4['man/man3/mt19937ar.3'] = 'Math/Random/mt19937ar.pir'
    $P0['man_pod'] = $P4

    # dist
    $P0['manifest_includes'] = 't/mt19937ar.txt'
    $P0['doc_files'] = 'README'

    .tailcall setup(args :flat, $P0 :flat :named)
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:
