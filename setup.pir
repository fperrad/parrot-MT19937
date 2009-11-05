#! /usr/local/bin/parrot
# Copyright (C) 2009, Parrot Foundation.

=head1 NAME

setup.pir - Python distutils style

=head1 DESCRIPTION

No Configure step, no Makefile generated.

Currently, the only dependency is 'prove' (in 'test' step).

Note: this setup.pir is a toy for Plumage.
A final solution is a setup.nqp which uses a distutils library written in NQP
and available in or with Plumage.

See: L<http://docs.python.org/distutils/>

=head1 USAGE

    $ parrot setup.pir build
    $ parrot setup.pir test
    $ sudo parrot setup.pir install

=cut

.sub 'main' :main
    .param pmc args
    $S0 = shift args
    $I0 = args
    unless $I0 == 0 goto L0
    build()
    end
  L0:
    .local string cmd
    cmd = shift args
    unless cmd == 'build' goto L1
    build()
    end
  L1:
    unless cmd == 'clean' goto L2
    clean()
    end
  L2:
    unless cmd == 'install' goto L3
    install()
    end
  L3:
    unless cmd == 'test' goto L4
    test()
    end
  L4:
    unless cmd == 'uninstall' goto L5
    uninstall()
    end
  L5:
    usage()
    end
.end

.sub 'build'
    $I0 = exist('Math/Random/mt19937ar.pbc')
    if $I0 goto L1
    .local string cmd
    cmd = get_parrot()
    cmd .= " -o Math/Random/mt19937ar.pbc Math/Random/mt19937ar.pir"
    system(cmd)
  L1:
.end

.sub 'clean'
    unlink('Math/Random/mt19937ar.pbc')
.end

.sub 'install'
    build()
    $S0 = get_libdir()
    $S0 .= "/library/Math/Random"
    mkpath($S0)
    $S0 .= '/mt19937ar.pbc'
    cp('Math/Random/mt19937ar.pbc', $S0)
.end

.sub 'test'
    build()
    .local string cmd
    cmd = "prove --exec="
    $S0 = get_parrot()
    cmd .= $S0
    cmd .= " t/*.t"
    system(cmd)
.end

.sub 'uninstall'
    $S0 = get_libdir()
    $S0 .= "/library/Math/Random/mt19937ar.pbc"
    unlink($S0)
.end

.sub 'usage'
    say <<'USAGE'
    Following targets are available for the user:

        build:          mt19937ar.pbc

        test:           Run the test suite.

        install:        Install the library.

        uninstall:      Uninstall the library.

        clean:          Basic cleaning up.

        help:           Print this help message.
USAGE
.end

.sub 'system' :anon
    .param string cmd
    say cmd
    $I0 = spawnw cmd
.end

.include 'stat.pasm'

.sub 'exist' :anon
    .param string filename
    $I0 = stat filename, .STAT_EXISTS
    .return ($I0)
.end

.sub 'mkpath' :anon
    .param string pathname
    $I1 = 1
  L1:
    $I1 = index pathname, '/', $I1
    if $I1 < 0 goto L2
    $S0 = substr pathname, 0, $I1
    inc $I1
    $I0 = exist($S0)
    if $I0 goto L1
    mkdir($S0)
    goto L1
  L2:
    $I0 = exist(pathname)
    if $I0 goto L3
    mkdir(pathname)
  L3:
.end

.sub 'mkdir' :anon
    .param string dirname
    $P0 = new 'OS'
    $I1 = 0o775
    $P0.'mkdir'(dirname, $I1)
.end

.sub 'cp' :anon
    .param string src
    .param string dst
    $P0 = new 'FileHandle'
    $S0 = $P0.'readall'(src)
    $P0.'open'(dst, 'w')
    $P0.'puts'($S0)
    $P0.'close'()
.end

.sub 'unlink' :anon
    .param string filename
    new $P0, 'OS'
    push_eh _handler
    $P0.'rm'(filename)
    pop_eh
  _handler:
    .return ()
.end

.include 'iglobals.pasm'

.sub 'get_config' :anon
    $P0 = getinterp
    $P1 = $P0[.IGLOBALS_CONFIG_HASH]
    .return ($P1)
.end

.sub 'get_parrot' :anon
    $P0 = get_config()
    $S0 = $P0['bindir']
    $S0 .= '/parrot'
    $S1 = $P0['exe']
    $S0 .= $S1
    .return ($S0)
.end

.sub 'get_libdir' :anon
    $P0 = get_config()
    $S0 = $P0['libdir']
    $S1 = $P0['versiondir']
    $S0 .= $S1
    .return ($S0)
.end
