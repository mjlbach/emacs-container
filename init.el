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


(straight-use-package 'use-package)

(use-package evil
 :straight t
 :ensure t
 :init
 (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
 (setq evil-want-keybinding nil)
 :config
 (evil-mode 1))

(use-package evil-collection
 :after evil
 :ensure t
 :straight (:host github :repo "mjlbach/evil-collection" :no-byte-compile t
            :branch "feature/additional_libvterm_evil_bindings")
 :config
 (evil-collection-init))

(setq vterm-always-compile-module t)
(use-package vterm
 :straight t)
