# patch for the EOF, SEEK_CUR, and SEEK_END integer constants
# because autoconf can't set them
var1='as_fn_error "computing EOF failed" "$LINENO" 5'
var2='$as_echo "computing EOF failed" "$LINENO" >&5'
sed -i '/'"$var1"'/s/.*''/'"$var2"'/g' configure
# var1=as_fn_error "computing SEEK_CUR failed" "$LINENO" 5
# var2=$as_echo "computing SEEK_CUR failed" "$LINENO" >&5
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure
# var1=as_fn_error "computing SEEK_END failed" "$LINENO" 5
# var2=$as_echo "computing SEEK_END failed" "$LINENO" >&5
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure

# var1=
# var2=
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure
# var1=
# var2=
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure
# var1=
# var2=
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure
# var1=
# var2=
# sed -i -e 's/'"$var1"'/'"$var2"'/g' /configure