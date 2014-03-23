cool-mode
=========

Emacs mode for COOL programming language

This is a preliminary attempt at a major mode for COOL.  Indentation is not working perfectly yet.


# HOW TO USE

1. Save the cool-mode.el in your emacs site-lisp directory.
2. Add something like the following to your ~/.emacs to enable it:

```
; cool mode

(autoload 'cool-mode "cool-mode" "Major mode for editing COOL programs" t)
(setq auto-mode-alist
      (append '(("\\.cl\\'" . cool-mode)) auto-mode-alist))
```

