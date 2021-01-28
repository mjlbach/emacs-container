(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq evil-want-keybinding nil)
(menu-bar-mode -1)

(straight-use-package 'use-package)

(setq vterm-always-compile-module t)

(use-package evil
 :straight t
 :ensure t)

(require 'evil)
(evil-define-operator evil-delete (beg end type register yank-handler)
  "Delete text from BEG to END with TYPE.
Save in REGISTER or in the kill-ring with YANK-HANDLER."
  (interactive "<R><x><y>")
  (unless register
    (let ((text (filter-buffer-substring beg end)))
      (unless (string-match-p "\n" text)
        ;; set the small delete register
        (evil-set-register ?- text))))
  (let ((evil-was-yanked-without-register nil))
    (evil-yank beg end type register yank-handler))
  (cond
   ((eq type 'block)
    (evil-apply-on-block #'delete-region beg end nil))
   ((and (eq type 'line)
         (= end (point-max))
         (or (= beg end)
             (/= (char-before end) ?\n))
         (/= beg (point-min))
         (=  (char-before beg) ?\n))
    (delete-region (1- beg) end))
   (t
    (delete-region beg end)))
  ;; place cursor on beginning of line
  (when (and (called-interactively-p 'any)
             (eq type 'line))
    (evil-first-non-blank)
    (message (concat (number-to-string beg) "\n" (number-to-string end)))))

(evil-mode)

(use-package evil-collection
 :straight (:host github :repo "mjlbach/evil-collection"
            :no-byte-compile t
            :branch "feature/additional_libvterm_evil_bindings")
 :config
 (evil-collection-init)
 )

(use-package vterm
 :straight t
 :config
 )

(use-package selectrum
 :straight t
 :config 
 (selectrum-mode +1))

(use-package nord-theme
  :straight t
  :config
  (load-theme 'nord t)
  )
  
(use-package general
  :straight t
  :ensure t
  )

(use-package which-key
  :straight t
  :ensure t
  :config
  (which-key-mode)
  )

;; Example configuration for Consult
(use-package consult
  :straight t
  :init
  (setq register-preview-delay 0
        register-preview-function #'consult-register-preview)
  (advice-add #'register-preview :around
              (lambda (fun buffer &optional show-empty)
                (let ((register-alist (seq-sort #'car-less-than-car register-alist)))
                  (funcall fun buffer show-empty))
                (when-let (win (get-buffer-window buffer))
                  (with-selected-window win
                    (setq-local mode-line-format nil)
                    (setq-local window-min-height 1)
                    (fit-window-to-buffer)))))
  :config

  (setq consult-narrow-key "<") ;; (kbd "C-+")
  ;;(autoload 'projectile-project-root "projectile")
  ;;(setq consult-project-root-function #'projectile-project-root))
  )

(define-key selectrum-minibuffer-map (kbd "<escape>") #'abort-recursive-edit)

(general-create-definer my-leader-def
  ;; :prefix my-leader
  :prefix "SPC")

(defun my-fdfind (&optional dir)
  (interactive "P")
  (let ((consult-find-command '("fd" "--color=never" "--full-path")))
    (consult-find dir)))

(my-leader-def
  :keymaps 'normal
  ;; bind "SPC a"
  "a" 'org-agenda
  "b" 'counsel-bookmark
  "c" 'org-capture
  "f" 'my-fdfind
  "s" 'consult-ripgrep)
