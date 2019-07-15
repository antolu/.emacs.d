(defvar my:ycmd-server-command '("python" "~/.ycmd/ycmd"))
(defvar my:ycmd-extra-conf-whitelist '(expand-file-name "~/.ycmd/.ycm_extra_conf.py"))
(defvar my:ycmd-global-config (expand-file-name "~/.ycmd/.ycm_extra_conf.py"))
(defvar my:wakatime-api-key "73e20bd3-43b3-4b66-a844-6eadc178f039")
(defvar my:wakatime-cli-path (expand-file-name "~/.anaconda3/lib/python3.7/site-packages/wakatime/cli.py"))

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(require 'use-package-ensure)
(setq use-package-always-ensure t)


(use-package wakatime-mode
  :config
  (global-wakatime-mode)
  (set-variable 'wakatime-api-key my:wakatime-api-key)
  (set-variable 'wakatime-cli-path my:wakatime-cli-path)
)

(use-package magit
  :config
  (global-set-key (kbd "C-x g") 'magit-status)
  )


(use-package flycheck
  :config
  (global-flycheck-mode)
  )

(use-package modern-cpp-font-lock
  :config (add-hook 'c++-mode-hook #'modern-c++-font-lock-mode)
  )

(use-package ycmd
  :config
  (set-variable 'ycmd-server-command my:ycmd-server-command)
  (set-variable 'ycmd-global-config my:ycmd-global-config)
  (global-ycmd-mode)
  (setq ycmd-force-semantic-completion t)
  (setq request-backend (quote url-retrieve))
  (use-package company
    :config
    (global-company-mode)
    (global-set-key (kbd "M-/") 'company-complete-common-or-cycle)
    (setq company-idle-delay 0)
  )
  (use-package company-ycmd
    :config
    (company-ycmd-setup)
    )
  (use-package flycheck-ycmd
    :init
    (add-hook 'c-mode-common-hook 'flycheck-ycmd-setup)
    )
  (require 'ycmd-eldoc)
  (add-hook 'ycmd-mode-hook 'ycmd-eldoc-setup)
  )

(use-package elpy
  :init
  (elpy-enable)
)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (leuven)))
 '(package-selected-packages (quote (flycheck use-package magit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-include-path
                           (list (expand-file-name "/opt/cxxtest/")))))

