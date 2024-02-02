(add-to-list 'default-frame-alist '(font . "RobotoMono Nerd Font Mono-12"))

(add-to-list 'default-frame-alist '(alpha-background . 90))

;; start elpaca
(defvar elpaca-installer-version 0.6)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (call-process "git" nil buffer t "clone"
                                       (plist-get order :repo) repo)))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  ;; Enable :elpaca use-package keyword.
  (elpaca-use-package-mode)
  ;; Assume :elpaca t unless otherwise specified.
  (setq elpaca-use-package-by-default t))

;; Block until current queue processed.
(elpaca-wait)

;; end

(require 'package)
(when (version<= "28.0.50" emacs-version )
  (global-display-line-numbers-mode))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/")t)
(add-to-list 'package-archives '("org". "https://orgmode.org/elpa/"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/my/"))

(require 'use-package)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")


(defun my/load-config ()
  (progn
    (message "started loading config")
    (recentf-mode 1)
    (repeat-mode)

    (setq-default isearch-yank-on-move t)
    (setq-default set-mark-command-repeat-pop t)
    (setq doc-view-continuous t)
    (global-set-key (kbd "<mouse-2>") 'clipboard-yank)
    (setq x-select-enable-clipboard t)
    (setq create-lockfiles nil)
    (setq visible-bell t)
    (setq-default indent-tabs-mode nil)
    (setq-default tab-width 2)
    (setq electric-pair-pairs
          '(
            (?\" . ?\")
            (?\{ . ?\})))
    (electric-pair-mode 1)
    (setq next-line-add-newlines t)
    (setq display-line-numbers-type 'relative)
    (global-display-line-numbers-mode 1)
    (setq pixel-dead-time 0) ; Never go back to the old scrolling behaviour.
    (setq pixel-resolution-fine-flag t) ; Scroll by number of pixels instead of lines (t = frame-char-height pixels).
    (setq mouse-wheel-scroll-amount '(1)) ; Distance in pixel-resolution to scroll each mouse wheel event.
    (setq mouse-wheel-progressive-speed nil)
    (setq inferior-lisp-program "sbcl")
    (set-default 'truncate-lines t)

    (custom-set-faces
     '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
     '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
     '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
     '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
     '(org-level-5 ((t (:inherit outline-5 :height 1.05)))))
;;(global-set-key (kbd "C-t") ctl-x-map)
    ;;(global-set-key (kbd "M-m") #'mark-sexp)
    ;;(org-babel-load-file (expand-file-name "~/.emacs.d/my-meow.org"))
   ;; (org-babel-load-file (expand-file-name "~/.emacs.d/my-evil-config.org"))
   (org-babel-load-file (expand-file-name "~/.emacs.d/my-init.org"))
    ;;(org-babel-load-file (expand-file-name "~/.emacs.d/ryo-modal.el"))

    (message "config was loaded")))

(add-hook 'after-init-hook
  (lambda () (progn
    
    (use-package nerd-icons
      :elpaca t
      :defer t
      :ensure t)

    (use-package all-the-icons
      :elpaca t
      :defer t
      :ensure t)

    (use-package doom-themes
      :elpaca t
      :ensure t
      :config
      ;; Global settings (defaults)
      (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
            doom-themes-enable-italic t)  ; if nil, italics is universally disabled
      (load-theme 'doom-spacegrey t)
      (setq doom-spacegrey-brighter-comments t)
;; (set-face-background 'font-lock-comment-face (doom-lighten "#e68183" 0.4))
      ;; Enable flashing mode-line on errors
      (doom-themes-visual-bell-config)
      ;; Enable custom neotree theme (all-the-icons must be installed!)
      (doom-themes-neotree-config)
      ;; or for treemacs users
      ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
      (doom-themes-treemacs-config)
      ;; Corrects (and improves) org-mode's native fontification.
      (doom-themes-org-config))

    (use-package doom-modeline
      :elpaca t
      :ensure t
      ;; :hook (after-init . doom-modeline-mode)
      :config
      (setq doom-modeline-position-line-format nil)
      (setq doom-modeline-buffer-encoding nil)
      (doom-modeline-mode))
    ;; (setq doom-modeline-i)
;; (custom-set-faces
;;   '(mode-line-inactive ((t (:font "DejavuSansM Nerd Font Mono-10" :box (:line-width 1 :height 0.8))))))
;; (doom-modeline-mode))
    )))

   (org-babel-load-file (expand-file-name "~/.emacs.d/my-meow.el"))
   ;; (org-babel-load-file (expand-file-name "~/.emacs.d/my-evil-config.org"))

;; (run-with-idle-timer 1 nil 'my/load-config)
(my/load-config)
;; (org-babel-load-file (expand-file-name "~/.emacs.d/my-devil.el"))
(setq org-agenda-files '("~/schedule/tasks.org"
                         "~/schedule/birthdays.org"))

(setq org-capture-templates
      '(("t" "Tasks / Projects")
        ("tt" "tasks" entry (file+olp "~/schedule/tasks.org" "TASKS")
         "* TODO %?\n %U\n %a\n %i" :empty-lines 1)
        ("tr" "reading" entry (file+olp "~/schedule/tasks.org" "READING")
         "* TODO %?\n %U\n %a\n %i" :empty-lines 1))
      org-agenda-start-with-log-mode t
      org-log-done 'time
      org-log-into-drawer t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:foreground "#1f2430" :background "#f28779" :height 3.0))))
 '(easy-kill-origin ((t (:inherit error :background "white smoke" :foreground "red" :inverse-video t))))
 '(mode-line-inactive ((t (:font "DejavuSansM Nerd Font Mono-10" :box (:line-width 1 :height 0.8)))))
 '(org-level-1 ((t (:inherit outline-1 :height 1.5))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.3))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.1))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.05)))))

(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)

(use-package viper
  :elpaca nil
  :disabled)

(use-package tetris
    :elpaca nil
  :disabled)

(use-package isearchb
    :elpaca nil
  :disabled)


(use-package rect
    :elpaca nil
  :bind
  (:map rectangle-mark-mode-map
        ("t" . string-rectangle)
        ("o" . open-rectangle)
        ("c" . clear-rectangle)
        ("n" . next-line)
        ("p" . previous-line)
        ("f" . forward-char)
        ("b" . backward-char)
        ("x" . rectangle-exchange-point-and-mark)
        (" " . delete-whitespace-rectangle)))

(use-package ps-mode
    :elpaca nil
  :mode (("\\.ps\\'" . ps-mode)))

(use-package ruby-mode
    :elpaca nil
  :mode (("\\.rb\\'" . ruby-mode)))

(use-package verilog-mode
    :elpaca nil
  :mode (("\\.vh\\'" . verilog-mode)
         ("\\.vlg\\'" . verilog-mode)))

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                   (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)
(setq gc-cons-threshold (* 2 1000 1000))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(custom-safe-themes
   '("34cf3305b35e3a8132a0b1bdf2c67623bc2cb05b125f8d7d26bd51fd16d547ec" "77fff78cc13a2ff41ad0a8ba2f09e8efd3c7e16be20725606c095f9a19c24d3d" "6631f884f5f43e9d8eee42f5bcf8522a7f791688d2d2667ec135c129066be243" "93011fe35859772a6766df8a4be817add8bfe105246173206478a0706f88b33d" "6f1f6a1a3cff62cc860ad6e787151b9b8599f4471d40ed746ea2819fcd184e1a" "f64189544da6f16bab285747d04a92bd57c7e7813d8c24c30f382f087d460a33" "0c08a5c3c2a72e3ca806a29302ef942335292a80c2934c1123e8c732bb2ddd77" "8d8207a39e18e2cc95ebddf62f841442d36fcba01a2a9451773d4ed30b632443" "56044c5a9cc45b6ec45c0eb28df100d3f0a576f18eef33ff8ff5d32bac2d9700" "636b135e4b7c86ac41375da39ade929e2bd6439de8901f53f88fde7dd5ac3561" "b9761a2e568bee658e0ff723dd620d844172943eb5ec4053e2b199c59e0bcc22" "00cec71d41047ebabeb310a325c365d5bc4b7fab0a681a2a108d32fb161b4006" "5f128efd37c6a87cd4ad8e8b7f2afaba425425524a68133ac0efd87291d05874" "467dc6fdebcf92f4d3e2a2016145ba15841987c71fbe675dcfe34ac47ffb9195" "02f57ef0a20b7f61adce51445b68b2a7e832648ce2e7efb19d217b6454c1b644" "545ab1a535c913c9214fe5b883046f02982c508815612234140240c129682a68" default))
 '(package-selected-packages
   '(zoxide tempel-collection tempel keychain-environment hyperbole lsp-docker mini-echo vertico-posframe lsp-ui lsp-mode zzz-to-char miniedit vimish-fold system-packages ednc rainbow-mode browse-kill-ring consult-eglot eglot git-timemachine nginx-mode openwith docker xterm-color exec-path-from-shell eshell-z elpy python-mode typescript-mode yasnippet-snippets undo-fu-session meow treesit-auto visual-fill-column nov use-package-chords which-key web-mode vterm vertico use-package undo-tree tree-sitter-langs tide super-save sly rjsx-mode rg rainbow-delimiters puni prettier-js prettier pdf-tools org-bullets orderless nerd-icons marginalia magit lua-mode key-chord hydra fennel-mode embark-consult doom-themes doom-modeline dirvish diff-hl denote crux corfu consult-notes cider cape anzu ansible annalist all-the-icons ace-window))
 '(safe-local-variable-values '((eval message "hello"))))
(put 'upcase-region 'disabled nil)

;; (setq initial-buffer-choice "~/.emacs.d/start.org")
