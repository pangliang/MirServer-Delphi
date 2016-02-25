DCPcrypt v2 BETA - 7th June 2000
================================

This is a beta version of DCPcrypt v2. It doesn't contain all that much
documentation but hopefully you will be able to get the idea of what does
what. There are a few sample programs for you to try but don't expect too
much.....

Main changes since v1
---------------------
There is now a new base cipher component TDCP_cipher from which the 
TDCP_blockcipher is derived. This is so stream ciphers can be derived
directly from the TDCP_cipher class (eg. RC4).

Addition of DES, Triple DES, ICE (and variants) block ciphers.

Addition of MD4 and MD5 hash algorithms.

Addition of RC4 stream cipher.

String encryption encorperated into the TDCP_cipher base class to allow
easier string encryption (the resulting string is Base64 encoded with 
the updated (faster) Base64 unit).

Stream encryption added to TDCP_cipher base class.

Stream hashing added to TDCP_hash class.

Addition of CFB block mode (blocksize=cipher blocksize), old CFB mode
renamed to CFB8bit.

Free Pascal support added (_should_ run on all i386 Linux platforms).

Added internal algorithm registration (ie. you can request an algorithm
by name or id number and it's class is returned if it has been compiled
into the project, see DCPcipherfromname, DCPcipherfromid, DCPhashfromname
and DCPhashfromid).


To Do
-----
Improve documentation (deleting it would do that ;-).

Add more sample programs.

Add some more ciphers (perhaps Skipjack and Serpent, any other suggestions ?).

Test throughly with Free Pascal (perhaps with GNU's pascal compiler also?)

Other suggestions welcome!


Installation
------------
Delphi1: Might work - probably won't, but install the DCPreg.pas file if you
         want to try.
Delphi2: Install the DCPreg.pas file.
Delphi3: Install the DCP_d3 package.
Delphi4: Install the DCP_d4 package.
Delphi5: I'm afraid that I don't have a copy of Delphi5 so you'll have to
         create a package yourself and add all the .pas files in the root
         directory and in the ciphers and hashes directory. Then install it.
FPK:     Make sure that Delphi support is enabled and the appropriate Delphi
         compatiblity files are included.


As this software is BETA there may be a few bugs in it. Please report any
you find to davebarton@bigfoot.com, a full error message and what you did 
to make it happen would be helpful when reporting an error. I haven't been 
able to add as many features as I would have liked due to my workload for
my university degree and the need to find a paying job to finance my way
through university. All donations are welcome (code, programs, documentation
that you have written, money, sponsorships, etc :-).

David Barton (davebarton@bigfoot.com)  7th June 2000