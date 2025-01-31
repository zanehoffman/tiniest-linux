as --64 sys.S && ld -O1 -n -nmagic -z max-page-size=1 a.out -o init && llvm-strip-13 --strip-all --strip-sections init && wc -c init 
