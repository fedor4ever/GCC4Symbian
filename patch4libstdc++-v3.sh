#License - Attribution-NonCommercial 4.0 International

# this is tesbed autopatcher for gcc sources
# patch for the EOF, SEEK_CUR, and SEEK_END integer constants
# because autoconf can't set them
find='as_fn_error "computing EOF failed" "$LINENO" 5'
replace='$as_echo "computing EOF failed" "$LINENO" >\&5'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='as_fn_error "computing SEEK_CUR failed" "$LINENO" 5'
replace='$as_echo "computing SEEK_CUR failed" "$LINENO" >\&5'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='as_fn_error "computing SEEK_END failed" "$LINENO" 5'
replace='$as_echo "computing SEEK_END failed" "$LINENO" >\&5'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

patch for the void, int, short and long
because autoconf can't set them
find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (void \*))" "ac_cv_sizeof_void_p"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (void \*))" "ac_cv_sizeof_void_p"'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (long))" "ac_cv_sizeof_long"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (long))" "ac_cv_sizeof_long"'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (int))" "ac_cv_sizeof_int"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (int))" "ac_cv_sizeof_int"'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (short))" "ac_cv_sizeof_short"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (short))" "ac_cv_sizeof_short"'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

find='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (char))" "ac_cv_sizeof_char"        "$ac_includes_default"'
replace='if ac_fn_c_compute_int "$LINENO" "(long int) (sizeof (char))" "ac_cv_sizeof_char"'
sed -i -e 's/'"$find"'/'"$replace"'/g' configure

# find=''
# replace=''
# sed -i -e 's/'"$find"'/'"$replace"'/g' configure
