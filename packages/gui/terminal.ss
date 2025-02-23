;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Copyright 2016-2080 evilbinary.
;;作者:evilbinary on 12/24/16.
;;邮箱:rootdebug@163.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(library (gui terminal)
  (export terminal-create terminal-render terminal-destroy
    terminal-key-event terminal-char-event terminal-resize
    terminal-set-mvp terminal)
  (import (scheme) (utils libutil) (cffi cffi) (gles gles2)
    (gui graphic) (gui widget) (gui layout) (gui draw))
  (load-librarys "libterminal")
  (def-function
    terminal-create
    "terminal_create"
    (void* float float float)
    void*)
  (def-function
    terminal-render
    "terminal_render"
    (void* float float)
    void)
  (def-function
    terminal-destroy
    "terminal_destroy"
    (void*)
    void)
  (def-function
    terminal-key-event
    "terminal_key_event"
    (void* int int int int)
    void)
  (def-function
    terminal-char-event
    "terminal_char_event"
    (void* int int)
    void)
  (def-function
    terminal-resize
    "terminal_resize"
    (void* float float)
    void)
  (def-function
    terminal-set-mvp
    "terminal_set_mvp"
    (void* void* float float)
    void)
  (define my-width 0)
  (define my-height 0)
  (define my-ratio 0)
  (define font-program 0)
  (define font-mvp 0)
  (define (terminal w h)
    (let ([widget (widget-new 0.0 0.0 w h "")] [term '()])
      (set! term
        (terminal-create
          (widget-get-attrs
            widget
            'font
            (graphic-get-font "RobotoMono-Regular.ttf"))
          (widget-get-attrs widget 'font-size 40.0)
          w
          h))
      (terminal-set-mvp term font-mvp my-width my-height)
      (widget-set-attrs widget 'terminal term)
      (widget-set-layout widget flow-layout)
      (widget-set-draw
        widget
        (lambda (widget parent)
          (let ([x (vector-ref widget %x)]
                [y (vector-ref widget %y)]
                [w (vector-ref widget %w)]
                [h (vector-ref widget %h)]
                [draw (vector-ref widget %draw)]
                [background (widget-get-attrs
                              widget
                              'background
                              1711276032)]
                [top (vector-ref widget %top)]
                [left (vector-ref widget %left)]
                [right (vector-ref widget %right)]
                [bottom (vector-ref widget %bottom)]
                [gx (widget-in-parent-gx widget parent)]
                [gy (widget-in-parent-gy widget parent)])
            (vector-set! widget %gx gx)
            (vector-set! widget %gy gy)
            (if (equal? '() background)
                (draw-panel gx gy w h '())
                (draw-panel gx gy w h '() background))
            (terminal-render term (+ left gx) (+ top gy))
            (widget-draw-child widget))))
      (widget-set-event
        widget
        (lambda (widget parent type data)
          (if (= type %event-layout)
              (terminal-resize
                term
                (widget-get-attr widget %w)
                (widget-get-attr widget %h)))
          (if (and (= type %event-mouse-button))
              (begin
                (widget-child-rect-event-mouse-button widget type data)))
          (if (= type %event-scroll)
              (begin (widget-child-rect-event-scroll widget type data)))
          (if (and (or (= type %event-char) (= type %event-key)))
              (begin
                (widget-child-key-event widget type data)
                (if (= type %event-key)
                    (terminal-key-event term (vector-ref data 0) (vector-ref data 1)
                      (vector-ref data 2) (vector-ref data 3)))
                (if (= type %event-char)
                    (begin
                      (terminal-char-event
                        term
                        (vector-ref data 0)
                        (vector-ref data 1))))))
          (if (= type %event-motion)
              (widget-child-rect-event-mouse-motion widget type data))))
      widget))
  (graphic-add-init-event
    (lambda (g w h)
      (set! my-width w)
      (set! my-height h)
      (set! font-program (hashtable-ref g 'font-program '()))
      (set! my-ratio (hashtable-ref g 'ratio 1.0))
      (set! font-mvp (hashtable-ref g 'font-mvp '())))))

