(defvar my:ycmd-server-command '("python" "USER_HOME/.emacs.d/ycmd/ycmd"))
(defvar my:ycmd-extra-conf-whitelist '("USER_HOME/.emacs.d/ycmd/.ycm_extra_conf.py"))
(defvar my:ycmd-global-config "USER_HOME/.emacs.d/ycmd/.ycm_extra_conf.py")
(defvar my:wakatime-api-key "73e20bd3-43b3-4b66-a844-6eadc178f039")
(defvar my:wakatime-cli-path "WAKATIME_CLI")
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

(eval-when-compile
  ;; Following line is not needed if use-package.el is in ~/.emacs.d
  (add-to-list 'load-path (expand-file-name "~/.emacs.d/use-package"))
  (require 'use-package))


(require 'use-package-ensure)
(setq use-package-always-ensure t)

(defconst user-init-dir
  (cond ((boundp 'user-emacs-directory)
         user-emacs-directory)
        ((boundp 'user-init-directory)
         user-init-directory)
        (t "~/.emacs.d/")))


(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file user-init-dir)))


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

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package yaml-mode
	     :ensure t
	     :mode (("\\.yaml\\'" . yaml-mode)
		    ("\\.yml\\'" . yaml-mode))
	     )

(use-package matlab-mode
	     :ensure t
	     :mode (("\\.m\\'" . matlab-mode))
	     )
	     

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (leuven)))
 '(package-selected-packages (quote (flycheck use-package magit)))
)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

