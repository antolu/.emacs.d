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
