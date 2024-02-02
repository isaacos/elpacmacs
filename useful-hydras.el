(provide 'useful-hydras)

(defvar xah-brackets '("“”" "()" "[]" "{}" "<>" "＜＞" "（）" "［］" "｛｝" "❛❜" "❝❞" "❨❩" "❪❫" "❴❵" "❬❭" "❮❯" "❰❱" "\"\""))

              (defconst xah-left-brackets
                (mapcar (lambda (x) (substring x 0 1)) xah-brackets)
                "List of left bracket chars. Each element is a string.")

              (defconst xah-right-brackets
                (mapcar (lambda (x) (substring x 1 2)) xah-brackets)
                "List of right bracket chars. Each element is a string.")

              (defun xah-backward-left-bracket ()
                "Move cursor to the previous occurrence of left bracket.
              The list of brackets to jump to is defined by `xah-left-brackets'.
              URL `http://xahlee.info/emacs/emacs/emacs_navigating_keys_for_brackets.html'
              Version 2015-10-01"
                (interactive)
                (re-search-backward (regexp-opt xah-left-brackets) nil t))

              (defun forward-left-bracket ()
                "Move cursor to the next occurrence of left bracket.
              The list of brackets to jump to is defined by `xah-right-brackets'.
              URL `http://xahlee.info/emacs/emacs/emacs_navigating_keys_for_brackets.html'
              Version 2015-10-01"
                (interactive)
                (re-search-forward (regexp-opt xah-left-brackets) nil t))

              (defun my/smart-forward-list (arg)
                "Move to the start of the next list"
                (interactive "p")
                (if (looking-at "\\s(")
                    (progn
                      (forward-list 2)
                      (backward-list 1))
                  (progn
                    (re-search-forward (regexp-opt xah-left-brackets) (looking-at (regexp-opt xah-right-brackets)) t)
                    (backward-char 1))))

(defun xah-forward-right-bracket ()
  "Move cursor to the next occurrence of right bracket.
              The list of brackets to jump to is defined by `xah-right-brackets'.
              URL `http://xahlee.info/emacs/emacs/emacs_navigating_keys_for_brackets.html'
              Version 2015-10-01"
  (interactive)
  (re-search-forward (regexp-opt xah-right-brackets) nil t))

(defun avy-goto-xah-open ( &optional arg)
  "Jump to the currently visible CHAR.
The window scope is determined by `avy-all-windows' (ARG negates it)."
  (interactive (list current-prefix-arg))
  (avy-with avy-goto-char
    (avy-jump
     
     (regexp-opt xah-left-brackets)
     :window-flip arg)))

(defhydra hydra-bracket-mov (:color red :hint nil :pre (hs-minor-mode))
  "
              ^By List^             ^By Level^           ^Actions^
              ^^^^^^^^----------------------------------------------
              _i_: next          _e_: higher        _t_: toggle-hs
              _h_: prev          _n_: inner         _m_: mark-sexp
              _f_: end-of        _w_: avy-word
              "
  ("q" nil)
  (";" nil)
  ("i" my/smart-forward-list)
  ("h" backward-list)
  ("e" backward-up-list)
  ("n" down-list)
  ("t" (progn
         (hs-toggle-hiding)
         (backward-up-list)))
  ("s" consult-line)
  ("f" forward-list)
  ("w" avy-goto-word-1 :exit t)
  ("a" avy-goto-open-brackets)
  ("m" mark-sexp))

(defhydra hydra-diff-hl (:color red)
  "diff hunk"
  ("q" nil)
  ("n" diff-hl-next-hunk)
  ("e" diff-hl-previous-hunk)
  ("/" diff-hl-revert-hunk))

(defhydra hydra-move-by (:color red :exit t)
  "move by"
  ("n" hydra-vi/body "Char")
  ("o" hydra-bracket-mov/body "Bracket")
  ("h" hydra-diff-hl/body "HL diff")

  ("p f" project-find-file "Project FF" :exit nil)
  ("b" hydra-buff-commands/body )

  )

(defhydra hydra-buff-commands (:color red :post (hydra-move-by/body))
  ("b t" beginning-of-buffer "Buffer Top" :exit t)
  ("b e" end-of-buffer "Buffer End" )
  ("b s" switch-to-buffer "Buffer Switch" )
  ;;("p f" project-find-file "Project FF" :exit nil)
  )

(defhydra hydra-vi ()
  "vi"
  ("h" backward-char)
  ("n" next-line)
  ("e" previous-line)
  ("i" forward-char)
  ("m" set-mark-command)
  ;;("SPC" hydra-buffer/file/body :exit t)
  ("q" nil)
  )

(defhydra hydra-flycheck ()
  "flycheck errors"
  ("f" flycheck-next-error)
  ("p" flycheck-previous-error)
("q" nil)
  )

;; (defhydra hydra-nav ()
;;   "movement"
;;   ("i" (progn
;;          (consult-imenu)
;;          (hydra-vi/body)) "imenu" :exit t)
;;   ("s" (progn
;;          (consult-line)
;;          (hydra-vi/body)) "search" :exit t)
;;   ("n" hydra-avy/body "avy" :exit t)
;;   ("h" (progn
;;          (hs-minor-mode 1)
;;          (hs-hide-all)))
;;   ("m" execute-extended-command "M-x"))

;; (defhydra hydra-buffer-file (:exit t global-map "C-'")

;;   ("n" (progn
;;          (call-interactively 'find-file)
;;          (if (or (derived-mode-p 'prog-mode) (derived-mode-p 'text-mode))
;;              (hydra-nav/body)
;;              )) "file" :exit t)
;;   ("i" (progn
;;          (call-interactively 'switch-to-buffer)
;;          (if (or (derived-mode-p 'prog-mode) (derived-mode-p 'text-mode))
;;              (hydra-nav/body))) "buffer" :exit t)
;;   ("p" (progn
;;          (call-interactively 'project-find-file)
;;          (hydra-nav/body)) "project" :exit t)
;;   ("e" eshell :exit t))

;; (global-set-key (kbd "C-'") #'hydra-buffer-file/body)


(defhydra hydra-avy ()
  ("q" nil)
  ("i" avy-goto-char "char")
  ("n" avy-goto-line "line")
  ("e" my/avy-goto-end-of-line "line end")
  ("v" scroll-up-command "down")
  ("u" scroll-down-command "up")
  ("l" recenter-top-bottom "center")
  ("s" consult-line "search")
  ("RET" back-to-avy/body :exit t))


(defhydra back-to-avy (:color pink)
("/" hydra-avy/body :exit t)
("z" nil))

(defhydra hydra-window ()
  ("q" nil)
  ("s" window-split-below "split")
  ("v" window-split-right "vsplit")
  ("r" delete-other-windows "remove")
  ("w s" make-frame "frame")
  ("w r" delete-frame "r frame"))


(defhydra hydra-reading-helper (:color pink :base-map (make-sparse-keymap))
  ("<escape>" nil)
  ("SPC" (progn
           (insert " ")
           (keyboard-quit)) "insert space")
  (";" scroll-other-window "scroll")
  )
