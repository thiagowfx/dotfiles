;; -*- emacs-lisp -*-

(let* ((my-lisp-dir "~/.emacs.d/")
       (default-directory my-lisp-dir))
  (setq load-path (cons my-lisp-dir load-path))
  (normal-top-level-add-subdirs-to-load-path))

(setq user-full-name "Thiago Perrotta")

(when (>= emacs-major-version 24)
  (load-theme 'wombat t)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/")))

(progn
  ;; Shortcut keys - keystrokes/keybindings - RET, "\M-g", [C-tab], (kbd "M-g"), [f1], (kbd "<f1>"), [?\C-\t], (kbd "<C-S-iso-lefttab>")
  (global-set-key (kbd "RET")     'newline-and-indent)
  (global-set-key (kbd "<menu>")  'compile)
  (global-set-key (kbd "C-x C-m") 'compile)
  (global-set-key (kbd "C-;")     'comment-or-uncomment-region)
  (global-set-key (kbd "C-x C-/") 'comment-or-uncomment-region)
  (global-set-key (kbd "M-/")     'hippie-expand)
  (global-set-key "\C-xg"         'goto-line)
  (global-unset-key "\C-z")
  (global-unset-key "\C-\M-h"))

(progn
  ;; Usability / design
  (setq case-fold-search t)
  (setq x-select-enable-primary t
        save-interprogram-paste-before-kill t
        mouse-yank-at-point t
        interprogram-paste-function 'x-cut-buffer-or-selection-value)
  (setq visible-bell t)
  (prefer-coding-system 'utf-8)
  (mouse-avoidance-mode 'exile)
  (setq indicate-empty-lines t)
  (setq echo-keystrokes 0.1)
  (fset 'yes-or-no-p 'y-or-n-p)
  (setq enable-recursive-minibuffers t)
  (setq require-final-newline t)
  (setq read-buffer-completion-ignore-case t)
  (setq vc-follow-symlinks t)
  (setq make-backup-files nil)
  (setq backup-inhibited t)
  (setq auto-save-default nil))

(progn
  ;; Emacs frame appearance
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (column-number-mode t)
  (line-number-mode t)
  (blink-cursor-mode -1)
  (setq default-frame-alist '((cursor-color . "white")))
  (setq inhibit-startup-message t
        inhibit-startup-echo-area-message t
        initial-scratch-message "")
  (set-face-attribute 'default nil :height 100)
  (set-default-font "Terminus-9")
  (setq frame-title-format (concat "%b - " (message "%s@emacs" (replace-regexp-in-string "\n$" "" (shell-command-to-string "whoami"))))))

(progn
  ;; Custom functions
  (defun cleanup-buffer ()
    "Buffer cleaning, performing a bunch of operations on the whitespace content of it."
    (interactive)
    (save-excursion
      (indent-region (point-min) (point-max))
      (untabify (point-min) (point-max))
      (delete-trailing-whitespace)))
  (global-set-key [C-tab] 'cleanup-buffer)

  (defun replace-last-sexp ()
    "Eval in place."
    (interactive)
    (let ((value (eval (preceding-sexp))))
      (kill-sexp -1)
      (insert (format "%s" value))))
  (global-set-key "\C-c\C-x\C-e" 'replace-last-sexp))

;; --------------------------------------------------
;; external libraries
;; -------------------------------------------------
;; (when (locate-library "git-auto-commit-mode")
;;   (setq gac-automatically-push-p t))

(when (locate-library "smart-mode-line")
;;  (setq sml/no-confirm-load-theme t)
  (sml/setup))

(when (locate-library "mode-icons")
  (mode-icons-mode))

(when (locate-library "goto-chg")
  (global-set-key [(control .)] 'goto-last-change))

(when (locate-library "smex")
  (global-set-key "\M-x" 'smex)
  (global-set-key "\M-X" 'smex-major-mode-commands)
  (global-set-key "\C-c\M-x" 'execute-extended-command))

(when (locate-library "undo-tree")
  (global-undo-tree-mode t)
  (global-set-key (kbd "C-_") 'undo-tree-undo)
  (global-set-key (kbd "C-+") 'undo-tree-redo))

(when (locate-library "web-mode")
  (add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.php?\\'"  . web-mode)))

(when (locate-library "pkgbuild-mode")
  (add-to-list 'auto-mode-alist '("/PKGBUILD$" . pkgbuild-mode)))

(when (locate-library "guide-key")
  (require 'guide-key)
  (setq guide-key/guide-key-sequence '("C-x r" "C-c"))
  (setq guide-key/idle-delay 2.0)
  (setq guide-key/recursive-key-sequence-flag t)
  (guide-key-mode 1))

;; orgmode
(when (locate-library "org")
  (global-set-key "\C-ca" 'org-agenda)
  (setq org-src-fontify-natively t)
  (setq org-hierarchical-todo-statistics t)
  (setq org-todo-keywords '((sequence "TODO" "PROGRESS" "|" "DONE" "PERFECT")))
  (setq org-directory (getenv "ORGHOME"))
  (setq org-todo-keyword-faces
        '(("TODO" . "red")
          ("PROGRESS" . "orange")
          ("DONE" . "green")
          ("PERFECT" . "salmon")))
  (defun org-summary-todo (n-done n-not-done)
    "Switch entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging
      (org-todo (if (= n-not-done 0) "DONE" "TODO"))))
  (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
  (when (locate-library "org2blog")
    (require 'org2blog-autoloads)
    (require 'wordpress-credentials))
  (when (locate-library "org-crypt")
    (require 'org-crypt)
    (org-crypt-use-before-save-magic)
    (setq org-tags-exclude-from-inheritance (quote ("crypt")))
    (setq org-crypt-key "A905373C")))

(when (locate-library "markdown-mode")
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode)))

(when (locate-library "magit")
  (global-set-key "\C-cg" 'magit-status))

(when (locate-library "yasnippet")
  (require 'yasnippet)
  (yas-global-mode t)
  (setq yas-prompt-functions '(yas-ido-prompt yas-completing-prompt yas-x-prompt yas-dropdown-prompt))
  (add-to-list 'hippie-expand-try-functions-list 'yas-hippie-try-expand)
  (add-hook 'yas-minor-mode-hook #'(lambda () (yas-activate-extra-mode 'perrotta-mode))))

(when (locate-library "auto-yasnippet")
  (require 'auto-yasnippet)
  (global-set-key (kbd "C-\(") 'aya-create)
  (global-set-key (kbd "C-\)") 'aya-expand))

(when (locate-library "golden-ratio")
  (require 'golden-ratio)
  (golden-ratio-mode t))

(when (locate-library "multiple-cursors")
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(when (locate-library "buffer-move")
  (require 'buffer-move)
  (global-set-key (kbd "<C-S-up>")    'buf-move-up)
  (global-set-key (kbd "<C-S-down>")  'buf-move-down)
  (global-set-key (kbd "<C-S-left>")  'buf-move-left)
  (global-set-key (kbd "<C-S-right>") 'buf-move-right))

(when (locate-library "auto-complete")
  (require 'auto-complete-config)
  (ac-config-default)
  (global-auto-complete-mode t)
  (setq ac-auto-show-menu t)
  (global-set-key (kbd "C-x C-<tab>") 'auto-complete)
  (setq ac-sources '(ac-source-abbrev
                     ac-source-dictionary
                     ac-source-features
                     ac-source-filename
                     ac-source-files-in-current-dir
                     ac-source-functions
                     ac-source-imenu
                     ac-source-symbols
                     ac-source-variables
                     ac-source-yasnippet
                     ac-source-words-in-buffer
                     ac-source-words-in-same-mode-buffers)))

;; -------------------------------------------------------------
;; built-in/native libraries
;; -------------------------------------------------------------

(when (locate-library "epa")
  (require 'epa)
  (epa-file-enable)
  (setq epa-file-name-regexp "\\.\\(gpg\\|asc\\)$")
  (epa-file-name-regexp-update))

(when (locate-library "server")
  (remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function))

(when (locate-library "autorevert")
  (global-auto-revert-mode t))

(when (locate-library "paren")
  (show-paren-mode t))

(when (locate-library "indent")
  (setq indent-tabs-mode nil)
  (setq standard-indent 2)
  (setq tab-width 2))

(when (locate-library "ibuffer")
  (global-set-key (kbd "C-x C-b") 'ibuffer))

(when (locate-library "windmove")
  (windmove-default-keybindings))

(when (locate-library "winner")
  (winner-mode t))

(when (locate-library "fill")
  (setq fill-column 72))

(when (locate-library "subword")
  (global-subword-mode t))

(when (locate-library "linum")
  (global-linum-mode t))

(when (locate-library "bookmark")
  (setq bookmark-default-file (concat user-emacs-directory "bookmarks")))

(when (locate-library "eldoc")
  (add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
  (add-hook 'lisp-mode-hook 'turn-on-eldoc-mode))

(when (locate-library "ido")
  (ido-mode t)
  (setq ido-enable-flex-matching t)
  (setq ido-enable-last-directory-history t)
  (setq confirm-nonexistent-file-or-buffer nil))

(when (locate-library "icomplete")
  (icomplete-mode t))

(when (locate-library "recentf")
  (recentf-mode t)
  (setq recentf-max-saved-items 50)
  (setq recentf-save-file (concat user-emacs-directory "recentf")))

(when (locate-library "savehist")
  (require 'savehist)
  (savehist-mode t)
  (setq savehist-file (concat user-emacs-directory "history")))

(when (locate-library "saveplace")
  (require 'saveplace)
  (setq-default save-place t)
  (setq save-place-file (concat user-emacs-directory "saved-places")))

(when (locate-library "uniquify")
  (require 'uniquify)
  (setq uniquify-buffer-name-style 'forward)
  (setq uniquify-separator "/"))

(when (locate-library "sh-mode")
  (add-to-list 'auto-mode-alist '("\\.zsh\\'" . sh-mode)))

(when (locate-library "compile")
  (setq compilation-read-command nil)
  (add-hook 'c++-mode-hook
            (lambda () (setq compile-command
                             (format "g++ %s %s -o %s"
                                     "-g -O2 -Wall"
                                     (buffer-file-name)
                                     (file-name-sans-extension buffer-file-name))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Custom
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("6fe6ab4abe97a4f13533e47ae59fbba7f2919583f9162b440dd06707b01f7794" default)))
 '(org-agenda-files (quote ("~/Dropbox/org/icpc.org" "~/Dropbox/org/todo.org")))
 '(paradox-github-token t)
 '(safe-local-variable-values (quote ((eval setq-default gac-automatically-push-p t) (require-final-newline))))
 '(use-file-dialog nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
