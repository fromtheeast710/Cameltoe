# build and run program
r:
 nixGLMesa dune exec cameltoe

# run and watch for changes
w:
 nixGLMesa dune exec cameltoe -w

d:
  direnv reload

# clean build dir
c:
  dune clean
