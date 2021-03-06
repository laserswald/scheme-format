(include "loops")
(include "matchable")

(module main ()
 (import chicken)
 (import loops)
 (import matchable)
 (import scheme)

 (use data-structures)
 (use extras)
 (use files)
 (use ports)
 (use posix)
 (use srfi-1)
 (use srfi-13)
 (use srfi-69)

 ; Include macros first
 (include "etc.scm")

 ; Include everything else
 (include "format.scm")

 ; Options
 (define end-options #f)
 (define inplace #f)
 (define files
         (filt s (cdr (argv))
          (or (not (string-prefix? "-" s))
              end-options
              (begin
               (cond
                ((or (string-prefix? "--h" s)
                     (string-prefix? "-h" s))
                 (print "Usage: scheme-format [options] files")
                 (print)
                 (print "-h  Show help")
                 (print "-i  Inplace edit")
                 (print "-v  Show version")
                 (exit 0))
                ((or (string-prefix? "--i" s)
                     (string-prefix? "-i" s))
                 (set! inplace #t))
                ((or (string-prefix? "--v" s)
                     (string-prefix? "-V" s)
                     (string-prefix? "-v" s))
                 (print "scheme-format version 1")
                 (exit 0))
                ((string= "--" s)
                 (set! end-options #t))
                (else
                 (print s ": unknown option")
                 (exit 1)))
               #f))))

 ; Format
 (for file files
  (define xs (with-input-from-file file read/comments))
  (set! xs (tidy xs))
  (define s (with-output-to-string (curry write/comments xs)))
  (if inplace
   (with-output-to-file file
                        (lambda ()
                         (display s))
                        binary:)
   (display s))))
