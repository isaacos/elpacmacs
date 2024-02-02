;; (defun ctrl-prefix (char)
;;   (interactive "c" )
;;   (execute-kbd-macro (kbd (concat "C-" (string char)))))

(defun my/toggle-relative-line-numbers ()
  (interactive)
  (progn
    (display-line-numbers-mode)
    (if (eq display-line-numbers-type 'relative)
        (setq display-line-numbers-type 'normal)
      (setq display-line-numbers-type 'relative))
    (display-line-numbers-mode)))

(use-package inc-and-dec
  :elpaca nil
  :ensure nil)

(defun copy-buffer-file-name ()
  (interactive)
  (kill-new (buffer-file-name)))

(defun copy-buffer-name ()
  (interactive)
  (kill-new (buffer-name)))


(use-package ibuffer
  :ensure nil
  :elpaca nil
  :bind (("C-c b i" .  ibuffer)))

(defun meow-setup ()
  ;;(setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak)
  (meow-motion-overwrite-define-key
   ;; Use e to move up, n to move down.
   ;; Since special modes usually use n to move down, we only overwrite e here.
   '("n" . meow-next)
   '("e" . meow-prev)
   '("<escape>" . meow-simple-motion-mode))
  (meow-leader-define-key
   '("?" . meow-cheatsheet)
   ;; To execute the originally e in MOTION state, use SPC e.
   '("N" . "H-n")
   '("E" . "H-e")

   '("b b" .  switch-to-buffer)
   '("b k" .  kill-buffer)
   '("b r" .  rename-buffer)
   '("b n" .  narrow-to-region)
   '("b p" .  project-switch-to-buffer)

   '("b w" .  widen)
   '("b ," .  clone-indirect-buffer)

   '("b t" .  kill-this-buffer)
   '("b m" .  switch-to-minibuffer)
   '("b o" . org+-buffer-name-to-title)
   '("b ." . scratch-buffer)

   '("e k" .  kill-emacs)
   '("e r" .  restart-emacs)
   '("e l" . my/toggle-relative-line-numbers)

   '("f f" .  hydra-flycheck/flycheck-next-error)


   '("k b" .  copy-buffer-name)
   '("k f" .  copy-buffer-file-name)
   '("k a" .  meow-save-append)
   '("k e" .  meow-append-at-end)

   '("l" . "C-c l") ;; used in LSP mode

   '("o a" . org-agenda)
   '("o c" . org-cycle-agenda-files)

   '("p" . "C-x p") ;;project prefix map

   '("r" . "C-x r") ;; mostly functions involving the register

   '("w v" . split-window-right)
   '("w s" . split-window-below)
   '("w r" . delete-other-windows)
   '("w f m" . make-frame-command)
   '("w f o" . other-frame)

   '("w f r" . delete-other-frames)
   '("w f t" . delete-frame)


   '("SPC" .  execute-extended-command)
   '("X" .  "M-X")

   '(";" . "M-;")

   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("1" . meow-expand-1)
   '("2" . meow-expand-2)
   '("3" . meow-expand-3)
   '("4" . meow-expand-4)
   '("5" . meow-expand-5)
   '("6" . meow-expand-6)
   '("7" . meow-expand-7)
   '("8" . meow-expand-8)
   '("9" . meow-expand-9)
   '("-" . negative-argument)
   '(";" . my/meow-reverse)
   '(":" . "M-X")

   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("<" . puni-barf-forward)
   '(">" . puni-slurp-forward)

   '("/" . avy-goto-xah-open)

   '("a" . meow-append)
   '("A" . meow-open-above)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   ;; '("C" . meow-end-or-call-kmacro)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)

   '("e" . meow-prev)
   '("E" . meow-prev-expand)
   '("f" . meow-next-word)
   '("F" . meow-next-symbol)
   '("g" . my/meow-cancel-or-nav)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-right)
   '("I" . meow-right-expand)
   '("j" . meow-join)
   '("k" . meow-kill)
   '("K" . kmacro-toggle-start-end)
   '("l" . meow-line)
   '("L". meow-goto-line)
   '("m" . meow-mark-word)
   '("M" . meow-mark-symbol)
   '("n" . meow-next)
   '("N" . meow-next-expand)
   '("o" . meow-to-block)
   '("O" . meow-block)
   '("p" . meow-find)
   '("P" . meow-negative-find)

   '("q" . meow-quit)
   '("r" . my/meow-replace)
   '("s" . meow-insert)
   '("S" . meow-open-below)
   '("t" . meow-till)
   '("T" . meow-negative-till)

   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-search)
   '("w" . my/meow-save-or-buffer)
   '("x t" . meow-transpose-sexp)
   '("x e" . meow-beginning-of-thing)
   '("x n" . meow-end-of-thing)
   '("x r" . anzu-query-replace-at-cursor)
   '("x s" . isearch-forward)
   '("x m" . meow-mark-symbol)
   '("x k" . "<f3>")
   '("x i" . meow-open-below)
   '("x o" . crux-smart-open-line)
   '("x c" . "<f4>")
   '("x (" . puni-wrap-round)
   '("x {" . puni-wrap-curly)
   '("x [" . puni-wrap-square)
   '("x '" . my/puni-wrap-single-quote)
   '("x \"" . my/puni-wrap-double-quote)
   '("x <" . puni-wrap-angle)
   '("x `" . my/puni-wrap-grave)
   ;; '("x SPC" . pop-to-mark-command)

   '("y" . meow-yank)
   '("z" . my/meow-pop-selection)
   '("'" . repeat)
   '("[" . backward-paragraph)
   '("]" . forward-paragraph)
   '("+" . increment-integer-at-point)
   '("_" . decrement-integer-at-point)

   '("<escape>" . ignore)))

(use-package meow
  :elpaca t
  :init
  (meow-global-mode 1)
  :config
  (global-set-key (kbd "C-x r C-.") #'point-to-register)

  (defvar pop-to-mark-repeat-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "SPC") #'pop-to-mark-command)
      map))
  (dolist (cmd '(pop-to-mark-command))
    (put cmd 'repeat-map 'pop-to-mark-repeat-map))

  (setq meow-keypad-start-keys '((?i . ?c) ;;breaks naming convention but frees c in leader
                                 ;; (?h . ?h) ;;removed inorder to rebind h to C-M-
                                 (?t . ?x))) ;; easier to access than x

  (setq meow-simple-motion-keymap (make-keymap))
  (meow-define-state simple-motion
    "meow state for motion without meow commands"
    :lighter " [S]"
    :keymap meow-simple-motion-keymap)
  (meow-define-keys 'simple-motion

    '("<escape>" . meow-motion-mode)
    '("e" . "p")
    '("SPC" . meow-keypad))


  (add-to-list 'meow-mode-state-list '(xref--xref-buffer-mode . simple-motion))
  ;; (add-to-list 'meow-mode-state-list '(magit-status-mode . meow-simple-motion-mode))

  (setq meow-keypad-ctrl-meta-prefix ?h)
  ;; meow-define-state creates the variable
  (setq meow-cursor-type-beacon '(box))

  (defun meow-negative-find ()
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-find)))

  (defun meow-negative-till ()
    (interactive)
    (let ((current-prefix-arg -1))
      (call-interactively 'meow-till)))

  (defun my/replace-char (arg char)
    (interactive (list (prefix-numeric-value current-prefix-arg)
                       (read-char-from-minibuffer "char: "
                                                  nil 'read-char-history)))
    (progn
      (call-interactively 'delete-char)
      (insert-char char)))

  (defun my/meow-replace ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'meow-replace)
      (call-interactively 'my/replace-char)))

  (defun my/meow-reverse ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'meow-reverse)
      (call-interactively 'avy-goto-char)))

  (defhydra hydra-vimish-g (:exit t)
    ("q" nil)
    ("g" beginning-of-buffer "buffer-start")
    ("." xref-find-definitions "def")
    ("i" consult-imenu "imenu")
    ("m" consult-imenu-multi "multi-imenu")
    ("," xref-go-back "back"))

  (defun my/meow-cancel-or-nav ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'meow-cancel-selection)
      (hydra-vimish-g/body)))

  (defun my/meow-save-or-buffer ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'meow-save)
      (call-interactively 'crux-other-window-or-switch-buffer)))
  
  (defun my/meow-pop-selection ()
    (interactive)
    (if (region-active-p)
        (call-interactively 'meow-pop-selection)
      (call-interactively 'pop-to-mark-command)))

  (meow-thing-register 'arrow '(pair ("<") (">")) '(pair ("<") (">")))
  (add-to-list 'meow-char-thing-table '(?a . arrow))
(add-to-list 'meow-char-thing-table '(?i . string))
  
  
  
  (defun my/treesit-node-parent-at-point ()
    "returns treesitter node at point or runs my/treesit-node-parent"
    (let ((node (treesit-node-at (point)) ))
      (if (= (treesit-node-start node) (point))
          (my/treesit-node-parent node (point))
        node)))

  (defun my/treesit-node-parent (node node-beg)
    "recursively looks up parent node
the lookup skips over nodes with the same starting point as the child"
    (let ((node-parent (treesit-node-parent node)))
      (cond ((string= (treesit-node-type node-parent) "program") node-parent)
            ((= (treesit-node-start node-parent) node-beg) (my/treesit-node-parent node-parent node-beg))
            (t node-parent))))

  (defun meow-ts--get-node-at-point ()
    (let ((node (my/treesit-node-parent-at-point)))
      ;; TODO abort when node is not the right node
      `(,(treesit-node-start node) . ,(treesit-node-end node))
      ))


  (meow-thing-register 'ts-node #'meow-ts--get-node-at-point #'meow-ts--get-node-at-point)
  (add-to-list 'meow-char-thing-table '(?n . ts-node))

  (defun my/treesit-node-up (&optional arg)
    (interactive )
    (let ((node (my/treesit-node-parent-at-point)))
      (goto-char (treesit-node-start node))))

  (defun my/treesit-node-down (&optional arg)
    (interactive)
    (let ((node (treesit-node-at (point)) ))
      (goto-char (treesit-node-start (treesit-node-child (treesit-node-parent node) 1)))))

  (defun my/treesit-forward-sibling (&optional arg)
    (interactive)
    (let ((node (my/treesit-node-parent-at-point) ))
      (goto-char (treesit-node-start (treesit-node-next-sibling node)))))


  (defun my/treesit-backward-sibling (&optional arg)
    (interactive)
    (let ((node (treesit-node-at (point)) ))
      (goto-char (treesit-node-start (treesit-node-prev-sibling node)))))

  (setq meow-expand-hint-counts
        '((word . 10)
          (line . 10)
          (block . 10)
          (find . 10)
          (till . 10)))

  (setq meow-use-clipboard t)

  (setq meow-replace-state-name-list
        '((normal . "󰰓")
          (motion . "󰰐")
          (keypad . "󰰊")
          (insert . "󰰄")
          (beacon . "󰯯")
          (simple-motion . "󰰢")))

  (defface my/meow-normal-indicator '((t :foreground "#87af87" :font "Hack Nerd Font-13"))
    "normal state indicator"
    :group 'meow)

  (defface my/meow-keypad-indicator '((t :foreground "#e68183" :font "Hack Nerd Font-13"))
    "key state indicator"
    :group 'meow)


  (defface my/meow-insert-indicator '((t :foreground "#d3a0bc" :font "Hack Nerd Font-13"))
    "key state indicator"
    :group 'meow)

  (defface my/meow-beacon-indicator '((t :foreground "#89beba" :font "Hack Nerd Font-13"))
    "key state indicator"
    :group 'meow)

  (defface my/meow-motion-indicator '((t :foreground "#e68183"
                                         :font "Hack Nerd Font-13"))
    "key state indicator"
    :group 'meow)

  (defface my/meow-simple-motion-indicator '((t :foreground "#e68183":font "Hack Nerd Font-13"))
    "key state indicator"
    :group 'meow)

  (setq meow-indicator-face-alist
        '((normal . my/meow-normal-indicator)
          (motion . my/meow-motion-indicator)
          (simple-motion . my/meow-simple-motion-indicator)

          (keypad . my/meow-keypad-indicator)
          (insert . my/meow-insert-indicator)
          (beacon . my/meow-beacon-indicator)))

  (meow-setup)

  ;;fixed meow-end-kmacro to allow it to be called via keypad
  (defun meow-end-kmacro ()
    "End kmacro recording or call macro.

      This command is a replacement for built-in `kmacro-end-macro'."
    (interactive)
    (cond
     ((or (meow-normal-mode-p)
          (meow-motion-mode-p))
      (call-interactively #'kmacro-end-or-call-macro))
     )))
;; (defun my/meow-ts-node-start (node)
;;   (let ((node-start (treesit-node-start node))
;;                 (region-start (region-beginning)))
;;             (if (<= node-start region-start)
;;                 (treesit-node-start (treesit-node-parent node))
;;               node-start))
;;    )
;; (defun my/treesit-node-parent (node node-beg)
;;   (let ((node-parent (treesit-node-parent node)))
;;     (cond ((string= (treesit-node-type node-parent)) node-parent)
;;           ((= (treesit-node-start node-parent) node-beg) (my/treesit-node-parent node-parent node-beg))
;;           (t node-parent)
;; )
;;     )
;;   )

;; (defun ii-to-normal-mode ( arg char)
;;   (interactive (list (prefix-numeric-value current-prefix-arg)
;;         (read-char-from-minibuffer "char: "
;;                                    nil 'read-char-history)))
;;   (if (equal char ?i)n
;;       (meow-normal-mode)
;;     (insert (concat "i" (char-to-string char))))

;; (defun ii-to-normal-mode ()
;;   (interactive)
;;   (message "key was %s" last-input-event)
;;     (if (equal "i" last-input-event)
;;       (meow-normal-mode)
;;     (insert "i")))


;; (define-key meow-insert-state-keymap (kbd "i") #'ii-to-normal-mode)


;; (read-key-sequence-vector)
