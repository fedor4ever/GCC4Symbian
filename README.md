# GCCE4Symbian

Project goal - build blleding-edge GNU toolchain.
Known issues:
1) can't build gdb due errors(I forgot which)
2) can't build libsupc++ because autoconf file in libstdc++ can't deduce foe EOF, SEEK_CUR and SEEK_END and integer types and void type
3) should edit build script in abld build system. Details here: https://fedor4ever.wordpress.com/
