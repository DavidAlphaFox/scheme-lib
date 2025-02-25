;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Copyright 2016-2080 evilbinary.
;author:evilbinary on 12/24/16.
;email:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(import (net socket-ffi) (cffi cffi) )

(define socket-fd 0)
(define n 0)
(define buff (cffi-alloc 4096))
(define i (cffi-alloc 100))

(cffi-set-int i 1000)

(define-syntax try 
  (syntax-rules (catch) 
    ((_ body (catch catcher)) 
     (call-with-current-continuation 
      (lambda (exit) 
	(with-exception-handler 
	 (lambda (condition) 
	   (catcher condition) 
	   (exit condition)) 
	 (lambda () body)))))))

(define eval-string
  (lambda (str)
    (with-output-to-string
      (lambda ()
	(try
	 (with-input-from-string str
	   (lambda ()
	     (let loop ()
	       (let ((c (read)))
		 (cond
		  ((eof-object? c) "" )
		  ((eq? c (void)) "") 
		  (else
		   (eval c)
		   (loop)))))))
	 (catch (lambda (x) 
		  (display-condition x) 
		  )))))))

(set! socket-fd (socket AF_INET SOCK_STREAM 0))
(setsockopt socket-fd SOL_SOCKET SO_RCVTIMEO i 100)

(display  (format "socket-fd=~a\n" socket-fd))

(define server-addr (make-sockaddr-in AF_INET INADDR_ANY 8200))

(define bind-ret (bind socket-fd  server-addr 16))
(display  (format "bind-ret=~a\n" bind-ret))

(define listen-ret (listen socket-fd 10))

(display  (format "listen-ret=~a\n" listen-ret))

(define connect-fd (accept socket-fd 0 0))
(display (format "connect-fd=~a\n" connect-fd))

(let loop()
  (set! n (recv connect-fd buff 4096 0))
  (display (cffi-string buff))
  (let ((ret (eval-string  (cffi-string buff))))
    (cffi-set buff 0 4096)
    (display (format "ret=~a\n" ret))
    (if (= 0 n)
	(set! connect-fd (accept socket-fd 0 0)))
    (send connect-fd ret (bytevector-length (string->utf8  ret)) 0)
    )
  (sleep (make-time 'time-duration 0 1))
  
  (loop ))

(close connect-fd)

(close socket-fd)
  





