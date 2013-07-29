;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Copyright (C) 2013-2013 Thiago Barroso Perrotta.                      ;
;                                                                       ;
; This program is free software: you can redistribute it and/or modify  ;
; it under the terms of the GNU General Public License as published by  ;
; the Free Software Foundation, either version 3 of the License, or     ;
; (at your option) any later version.                                   ;
;                                                                       ;
; This program is distributed in the hope that it will be useful,       ;
; but WITHOUT ANY WARRANTY; without even the implied warranty of        ;
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         ;
; GNU General Public License for more details.                          ;
;                                                                       ;
; You should have received a copy of the GNU General Public License     ;
; along with this program.  If not, see <http://www.gnu.org/licenses/>. ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auctex - rich featured tex mode
;; auto-complete - support for autocompletion
;; magit - git support
;; redo+ - utilities for redo
;; eldoc
;; emacs-pkgbuild-mode (for arch linux)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; defuns
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun reload-dot-emacs ()
  "Reload .emacs file while inside emacs."
  (interactive)
  (load-file "~/.emacs"))

(defun toggle-fullscreen (&optional f)
  "Fullscreen on F11 -- GNU/Linux Only"
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
    (set-frame-parameter nil 'fullscreen
                         (if (equal 'fullboth current-value)
                             (if (boundp 'old-fullscreen) old-fullscreen nil)
                           (progn (setq old-fullscreen current-value)
                                  'fullboth)))))

(defun exec-program ()
  "Execute the current buffer name."
  (interactive)
  (shell-command (concat "\""
			 (file-name-sans-extension buffer-file-name)
			 "\"")))

(defun exec-program-with-input ()
  "Execute the current buffer name with the .in input"
  (interactive)
  (shell-command (concat "\""
			 (file-name-sans-extension buffer-file-name)
			 "\" < \""
			 (file-name-sans-extension buffer-file-name)
			 ".in\"")))

(defun exec-program-with-input-and-output ()
  "Execute the current buffer name with the .in input and flushing it to the .out output"
  (interactive)
  (shell-command (concat "\""
			 (file-name-sans-extension buffer-file-name)
			 "\" < \""
			 (file-name-sans-extension buffer-file-name)
			 ".in\" "
			 "> \""
			 (file-name-sans-extension buffer-file-name)
			 ".out\"")))

(defun fc-eval-and-replace ()
  "Replace the preceding sexp with its value."
  (interactive)
  (backward-kill-sexp)
  (condition-case nil
      (prin1 (eval (read (current-kill 0)))
             (current-buffer))
    (error (message "Invalid expression")
           (insert (current-kill 0)))))

(defun notify-compilation-result (buffer msg)
  "Notify that the compilation is finished,
close the *compilation* buffer if the compilation is successful,
and set the focus back to Emacs frame"
  (if (string-match "^finished" msg)
      (progn
	(delete-windows-on buffer)
	(tooltip-show "\n Compilation Successful ;-) \n "))
    (tooltip-show "\n Compilation Failed =/ \n "))
  (setq current-frame (car (car (cdr (current-frame-configuration)))))
  (select-frame-set-input-focus current-frame))
(add-to-list 'compilation-finish-functions 'notify-compilation-result)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; file associations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.mdownx\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.nfo\\'" . text-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; packages and emacs lisp files
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; set the load path, add everything under ~/.emacs.d to it
(let* ((my-lisp-dir "~/.emacs.d/")
       (default-directory my-lisp-dir))
  (setq load-path (cons my-lisp-dir load-path))
  (normal-top-level-add-subdirs-to-load-path))

(when (file-exists-p "~/.emacs.d/elpa/package.el")
  (when (load (expand-file-name "~/.emacs.d/elpa/package.el"))
    (package-initialize)))

;; add more repos. More packages and .el scripts.
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))
(setq url-http-attempt-keepalives nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom shortcuts / hotkeys
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define-key global-map (kbd "RET")         'newline-and-indent)          ;; C-j like; alt: reindent-then-newline-and-indent
(global-set-key        "\M-g"              'goto-line)                   ;; alt: (kbd "M-g")
(global-set-key        (kbd "<f3>")        'reload-dot-emacs)
(global-set-key        (kbd "<f4>")        'magit-status)
(global-set-key        (kbd "C-<f4>")      'kill-buffer-and-window)
(global-set-key        (kbd "<f5>")        'compile)
(global-set-key        (kbd "<f6>")        'exec-program)
(global-set-key        (kbd "<f7>")        'exec-program-with-input)
(global-set-key        [f8]                'exec-program-with-input-and-output)
(global-set-key        [C-tab]             'other-window)                ;; easy switching buffers
(global-set-key        (kbd "<f9>")        'comment-or-uncomment-region) ;; (un)comment
(global-set-key        [f11]               'toggle-fullscreen)
(global-set-key        "\C-z"              'undo)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; my custom minor modes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(menu-bar-mode nil)		             ;; hide the menu bar
(icomplete-mode t)                           ;; autoactivate icomplete-mode
(setq icomplete-prospects-height 1           ;; don't spam my minibuffer
      icomplete-compute-delay 0)             ;; don't wait
(iswitchb-mode t)                            ;; switches between buffers using substrings
(line-number-mode t)
(column-number-mode t)                       ;; display the column number in the mode bar
(size-indication-mode t)                     ;; display size of the current file
(file-name-shadow-mode t)                    ;; be smart about filenames in minibuffer
(winner-mode t)                              ;; C-c <left> restore the previous window configs
(setq make-backup-files nil
      auto-save-default nil)                 ;; don't annoy me with backup files everywhere
(setq require-final-newline t
      default-indicate-empty-lines t         
      next-line-add-newlines nil             ;; C-n at the end of a file acts like newline
      inhibit-startup-message t              ;; don't show startup screen, it's annoying
      inhibit-startup-echo-area-message t
      initial-scratch-message                ";; scratch buffer created -- let's rock\n")
(transient-mark-mode t)			     ;; highlight marked region
(global-font-lock-mode t)		     ;; syntax highlight everywhere
(fset 'yes-or-no-p 'y-or-n-p)                ;; make all "yes or no" prompts show "y or n" instead
(setq compilation-read-command nil)          ;; compilation: autocompile without prompting the user, unless you give it a prefix argument
(setq TeX-PDF-mode t)                        ;; get AUCTeX to work in PDF insted of dvi mode
(setq vc-follow-symlinks t)                  ;; annoying prompt in git

;; eldoc mode (function signatures in modeline)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom mode hooks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; C++
(add-hook 'c++-mode-hook 
	  (lambda ()
	    (setq compile-command
		 (concat "g++ \""
			 (buffer-file-name)
			 "\" -o \""
			 (file-name-sans-extension buffer-file-name)
			 "\" -Wall"))))

;; C
(add-hook 'c-mode-hook
	  (lambda ()
	    (setq compile-command
		 (concat "gcc \""
			 (buffer-file-name)
			 "\" -o \""
			 (file-name-sans-extension buffer-file-name)
			 "\" -Wall"))))

;; Java
(add-hook 'java-mode-hook
	  (lambda ()
	    (setq compile-command
		 (concat "javac \""
			 (buffer-file-name)
			 "\""))))

;; LaTeX
(add-hook 'latex-mode-hook
	  (lambda ()
	    (setq compile-command
		  (concat "pdflatex \""
			  (buffer-file-name)
			  "\""))))

;; Python
(add-hook 'python-mode-hook
	  (lambda ()
	    (setq compile-command
		  (concat "python \""
			  (buffer-file-name)
			  "\""))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; general emacs tweaking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; enable ibuffer
(when (fboundp 'ibuffer)
  (global-set-key (kbd "C-x C-b") 'ibuffer))

(setq scroll-margin 0                        ;; do smooth scrolling, ...
      scroll-conservatively 100000           ;; ... the defaults ...
      scroll-up-aggressively 0               ;; ... are very ...
      scroll-down-aggressively 0             ;; ... annoying
      scroll-preserve-screen-position t)     ;; preserve screen pos with C-v/M-v 

(setq x-select-enable-clipboard t            ;; copy-paste should work ...
      interprogram-paste-function            ;; ...with...
      'x-cut-buffer-or-selection-value)      ;; ...other X clients

;; change title from a frame
(setq-default  frame-title-format
	       '(:eval
		 (format "%s@%s: %s"
			 (or (file-remote-p default-directory 'user) user-login-name)
			 (or (file-remote-p default-directory 'host) system-name)
			 (file-name-nondirectory (or (buffer-file-name) default-directory)))))

;; minibuffer goodies
(setq enable-recursive-minibuffers nil ;;  allow mb cmds in the mb
      max-mini-window-height .25	   ;;  max 2 lines
      minibuffer-scroll-window nil
      resize-mini-windows nil)

;; recent files, to save recently used files
(require 'recentf)   
(setq recentf-save-file               "~/.emacs.d/recentf"
      recentf-max-saved-items 100     ;; max save 100
      recentf-max-menu-items 15)      ;; max 15 in menu
(recentf-mode t)

;; ido-mode - both)) - powerful mode for find-file and switch-to-buffer - http://www.emacswiki.org/cgi-bin/wiki/InteractivelyDoThings
(require 'ido)
(ido-mode 'both)
(setq ido-save-directory-list-file "~/.ido.last"
      ido-ignore-buffers               ;; ignore these guys
      '("\\` " "^\*Mess" "^\*Back" ".*Completion" "^\*Ido" "^\*trace"
	"^\*compilation" "^\*GTAGS" "^session\.*" "^\*")
      ido-work-directory-list '("~/" "~/Desktop" "~/Documents")
      ido-case-fold  t                    ;; be case-insensitive
      ido-enable-last-directory-history t ;; remember last used dirs
      ido-max-work-directory-list 30	  ;; should be enough
      ido-max-work-file-list      50	  ;; remember many
      ido-use-filename-at-point nil       ;; don't use filename at point (annoying)
      ido-use-url-at-point nil            ;; don't use url at point (annoying)
      ido-enable-flex-matching nil        ;; don't try to be too smart
      ido-max-prospects 8                 ;; don't spam my minibuffer
      ido-confirm-unique-completion t)    ;; wait for RET, even with unique completion
(setq confirm-nonexistent-file-or-buffer nil) ;; disable annoying confirmation

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; .emacs references used here
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Load your .emacs file while in emacs M-x load-file RET ~/.emacs
;; - https://news.ycombinator.com/item?id=1654164
;; - https://github.com/vvv/dotfiles/blob/master/.emacs
;; - http://www.emacsrocks.com/
;; - http://www.damtp.cam.ac.uk/user/sje30/emacs/ell.html ;lots of elisp packages!
;; - http://www.emacswiki.org/emacs/CompileCommand
;; - http://www.djcbsoftware.nl/dot-emacs.html

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;custom theme for emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(custom-set-variables 
 '(ansi-color-names-vector ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(custom-enabled-themes (quote (misterioso)))
 '(ecb-source-path (quote (("/" "/")))))
(custom-set-faces
 ;; custom-set-faces and custom-set-variables were added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; these require installation of extra packages, use package-install or list-packages
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'redo+)
(when (fboundp 'redo+)
  (global-set-key        [C-S-z]              'undo))

;; auto-complete mode, also see M-/ shortcut
(require 'auto-complete)
(require 'popup)
(setq ac-modes '(c-mode c++-mode emacs-lisp-mode tex-mode latex-mode))
(global-auto-complete-mode t)

;; emacs-pkgbuild-mode in Arch Linux
(autoload 'pkgbuild-mode "pkgbuild-mode.el" "PKGBUILD mode." t)
(setq auto-mode-alist (append '(("/PKGBUILD$" . pkgbuild-mode)) auto-mode-alist))
