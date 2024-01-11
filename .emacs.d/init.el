;;; init.el --- Emacs configuration main script
;;; Commentary:
;;
;;  #    #     ###################################################################
;;      # #    Ivan Avdonin's (ia, ia93main@gmail.com) personal configuration file
;;  #  #   #   ###################################################################
;;  #  #####   init.el                 : this file, main config script for Emacs
;;  #  #   #   early-init.el           : supplemental script Emacs runs before init.el
;;  #  #   #   scripts/elpaca-setup.el : elpaca dedicated initialization script
;;  #  #   #   scripts/buffer-move.el  : 3rd party helper functions for moving buffers
;;
;;; Code:

(setq user-full-name "Ivan Avdonin"
      user-mail-address "ia93main@gmail.com")

;; Set various minor settings here and there
;; safe to touch before elpaca is initialized (elpaca-setup)
(setq inhibit-startup-screen t)                              ; skip that useless startup screen
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ; show initially maximized
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq pop-up-windows nil)
(global-display-line-numbers-mode 1)
(global-visual-line-mode t)
(fset 'yes-or-no-p 'y-or-n-p)

;; Set initial temporary theme from default stock until a cool custom one
;; can be obtained by elpaca when initialized
;(load-theme 'tango-dark)
(load-theme 'manoj-dark)

;; Setup dependency script files
(add-to-list 'load-path "~/.emacs.d/scripts/")
(require 'elpaca-setup) ; startup Elpaca Package Manager

;; Saving backups configuration
(setq backup-by-copying t                                   ; don't clobber symlinks
      backup-directory-alist '(("." . "~/.emacs.d/saves/")) ; don't litter my filesystem tree
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)                                    ; use versioned backups
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs.d/saves/" t)))

;; Codepage preferences
(prefer-coding-system 'utf-8-unix)
(set-locale-environment "en_US.UTF-8")
(set-default-coding-systems 'utf-8-unix)
(set-selection-coding-system 'utf-8-unix)
(set-buffer-file-coding-system 'utf-8-unix)
(set-clipboard-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;;
;; Fonts configuration
;;
(set-face-attribute 'default nil
		    :font "JetBrains Mono"
		    :height 90
		    :weight 'medium)
(set-face-attribute 'variable-pitch nil
		    :font "JetBrains Mono"
		    :height 90
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :font "JetBrains Mono"
		    :height 90
		    :weight 'medium)
;; Makes commented text and keywords italics.
;; This is working in emacsclient but not emacs.
;; Your font must have an italic face available.
(set-face-attribute 'font-lock-comment-face nil
		    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
		    :slant 'italic)
;; This sets the default font on all graphical frames created after restarting Emacs.
;; Does the same thing as 'set-face-attribute default' above, but emacsclient fonts
;; are not right unless I also add this method of setting the default font.
(add-to-list 'default-frame-alist '(font . "JetBrains Mono-9"))
(setq-default line-spacing 0.12)

;;
;; GENERAL keybindings.
;;
(require 'buffer-move) ; for easy buffers moving keybindins
(use-package general
  :config
  (general-create-definer ia/leader-keys
    :keymaps 'override
    :prefix "ESC")

  (ia/leader-keys
    ;; Emacs Configuration
    "c f" '((lambda () (interactive) (find-file "~/.emacs.d/init.el")) :wk "Edit Emacs configuration")
    "c r" '((lambda () (interactive) (load-file "~/.emacs.d/init.el")) :wk "Reload Emacs configuration")
    "c t" '(counsel-load-theme :wk "Load theme"))
  
  (ia/leader-keys
    ;; Files
    "f f" '(find-file :wk "Find file")
    "f r" '(counsel-recentf :wk "Find recent files")
    "f d" '(find-grep-dired :wk "Search for string in files in DIR")
    "f g" '(counsel-grep-or-swiper :wk "Search for string current file")
    "f j" '(counsel-file-jump :wk "Jump to a file below current directory")
    "f l" '(counsel-locate :wk "Locate a file")
    "f r" '(counsel-recentf :wk "Find recent files")
    "SPC" '(counsel-M-x :wk "Counsel M-x")
    "TAB TAB" '(comment-line :wk "Comment lines"))
  
  (ia/leader-keys
    ;; Buffers
   "b" '(:ignore t :wk "buffer")
   "b b" '(switch-to-buffer :wk "Switch buffer")
   "b i" '(ibuffer :wk "ibuffer")
   "b k" '(kill-current-buffer :wk "Kill current buffer")
   "b K" '(kill-some-buffers :wk "Kill multiple buffers")
   "b n" '(next-buffer :wk "Next buffer")
   "b p" '(previous-buffer :wk "Previous buffer")
   "b r" '(revert-buffer :wk "Reload buffer")
   "b R" '(rename-buffer :wk "Rename buffer")
   "b s" '(basic-save-buffer :wk "Save buffer")
   "b S" '(save-some-buffers :wk "Save multiple buffers"))

;; NOTE(ia): do I really need this dired crap?
;;  (ia/leader-keys
;;    "d" '(:ignore t :wk "Dired")
;;    "d d" '(dired :wk "Open dired")
;;    "d j" '(dired-jump :wk "Dired jump to current")
;;    "d n" '(neotree-dir :wk "Open directory in neotree")
;;    "d p" '(peep-dired :wk "Peep-dired"))

  (ia/leader-keys
    ;; Evaluating EL code
    "e" '(:ignore t :wk "Evaluate")    
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e d" '(eval-defun :wk "Evaluate defun containing or after point")
    "e e" '(eval-expression :wk "Evaluate and elisp expression")
    "e l" '(eval-last-sexp :wk "Evaluate elisp expression before point")
    "e r" '(eval-region :wk "Evaluate elisp in region"))
  
  (ia/leader-keys
    ;; Help System
    "h" '(:ignore t :wk "Help")
    "h a" '(counsel-apropos :wk "Apropos")
    "h b" '(describe-bindings :wk "Describe bindings")
    "h c" '(describe-char :wk "Describe character under cursor")
    "h d" '(:ignore t :wk "Emacs documentation")
    "h d a" '(about-emacs :wk "About Emacs")
    "h d d" '(view-emacs-debugging :wk "View Emacs debugging")
    "h d f" '(view-emacs-FAQ :wk "View Emacs FAQ")
    "h d m" '(info-emacs-manual :wk "The Emacs manual")
    "h d n" '(view-emacs-news :wk "View Emacs news")
    "h d o" '(describe-distribution :wk "How to obtain Emacs")
    "h d p" '(view-emacs-problems :wk "View Emacs problems")
    "h d t" '(view-emacs-todo :wk "View Emacs todo")
    "h d w" '(describe-no-warranty :wk "Describe no warranty")
    "h e" '(view-echo-area-messages :wk "View echo area messages")
    "h f" '(describe-function :wk "Describe function")
    "h v" '(describe-variable :wk "Describe variable")
    "h g" '(describe-gnu-project :wk "Describe GNU Project")
    "h i" '(info :wk "Info")
    "h I" '(describe-input-method :wk "Describe input method")
    "h k" '(describe-key :wk "Describe key")
    "h l" '(view-lossage :wk "Display recent keystrokes and the commands run")
    "h L" '(describe-language-environment :wk "Describe language environment")
    "h m" '(describe-mode :wk "Describe mode")
    "h w" '(where-is :wk "Prints keybinding for command if set")
    "h x" '(describe-command :wk "Display full documentation for command"))
  
  (ia/leader-keys
    ;; Anything that can be toggled
   "t" '(:ignore t :wk "Toggle")
   "t l" '(display-line-numbers-mode :wk "Toggle line numbers")
   "t n" '(neotree-toggle :wk "Toggle neotree file viewer")
   "t t" '(visual-line-mode :wk "Toggle truncated lines")
   "t f" '(flycheck-mode :wk "Toggle flycheck"))

  (ia/leader-keys
    ;; Windows/Words
    "w" '(:ignore t :wk "Windows/Words")
    ;; Move Windows
    "w H" '(buf-move-left :wk "Buffer move left")
    "w J" '(buf-move-down :wk "Buffer move down")
    "w K" '(buf-move-up :wk "Buffer move up")
    "w L" '(buf-move-right :wk "Buffer move right")
    ;; Words
    "w d" '(downcase-word :wk "Downcase word")
    "w u" '(upcase-word :wk "Upcase word")
    "w =" '(count-words :wk "Count words/lines for buffer")))

  ;; NOTE(ia): Integrate Git later...
  ;; (ia/leader-keys
  ;;   "g" '(:ignore t :wk "Git")    
  ;;   "g /" '(magit-displatch :wk "Magit dispatch")
  ;;   "g ." '(magit-file-displatch :wk "Magit file dispatch")
  ;;   "g b" '(magit-branch-checkout :wk "Switch branch")
  ;;   "g c" '(:ignore t :wk "Create") 
  ;;   "g c b" '(magit-branch-and-checkout :wk "Create branch and checkout")
  ;;   "g c c" '(magit-commit-create :wk "Create commit")
  ;;   "g c f" '(magit-commit-fixup :wk "Create fixup commit")
  ;;   "g C" '(magit-clone :wk "Clone repo")
  ;;   "g f" '(:ignore t :wk "Find") 
  ;;   "g f c" '(magit-show-commit :wk "Show commit")
  ;;   "g f f" '(magit-find-file :wk "Magit find file")
  ;;   "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
  ;;   "g F" '(magit-fetch :wk "Git fetch")
  ;;   "g g" '(magit-status :wk "Magit status")
  ;;   "g i" '(magit-init :wk "Initialize git repo")
  ;;   "g l" '(magit-log-buffer-file :wk "Magit buffer log")
  ;;   "g r" '(vc-revert :wk "Git revert file")
  ;;   "g s" '(magit-stage-file :wk "Git stage file")
  ;;   "g t" '(git-timemachine :wk "Git time machine")
  ;;   "g u" '(magit-stage-file :wk "Git unstage file"))

;; Zooming in & out
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

;;
;; UI enhancements and settings
;;
(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  ;; Global theme selection:
  (load-theme 'doom-dracula t)
  ;;(load-theme 'doom-one t)
  ;;(load-theme 'doom-1337 t)
  ;;(load-theme 'doom-ir-black t)
  ;;(load-theme 'doom-homage-black t)
  
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package dired-open
  :config (setq dired-open-extensions '(("gif" . "sxiv")
					("jpg" . "sxiv")
					("png" . "sxiv")
					("mkv" . "mpv")
					("mp4" . "mpv"))))
(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package nyan-mode
  :config (nyan-mode))

(use-package neotree
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 25
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action) 
  ;; truncate long file names in neotree
  (add-hook 'neo-after-create-hook
            #'(lambda (_)
		(with-current-buffer (get-buffer neo-buffer-name)
                  (setq truncate-lines t)
                  (setq word-wrap nil)
                  (make-local-variable 'auto-hscroll-mode)
                  (setq auto-hscroll-mode nil)))))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":"
        hl-todo-keyword-faces
        `(("TODO"       warning bold)
          ("FIXME"      error bold)
          ("HACK"       font-lock-constant-face bold)
          ("REVIEW"     font-lock-keyword-face bold)
          ("NOTE"       success bold)
          ("DEPRECATED" font-lock-doc-face bold))))

(use-package which-key
  :init
  (which-key-mode 1)
  :diminish
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-order #'which-key-key-order-alpha
	which-key-allow-imprecise-window-fit nil
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columns nil
	which-key-min-display-lines 6
	which-key-side-window-slot -10
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit nil
	which-key-separator " → " ))

(use-package flycheck
  :ensure t
  :defer t
  :diminish
  :init (global-flycheck-mode))

(use-package company
  :defer 2
  :diminish
  :custom
  (company-begin-commands '(self-insert-command))
  (company-idle-delay .1)
  (company-minimum-prefix-length 2)
  (company-show-numbers t)
  (company-tooltip-align-annotations 't)
  (global-company-mode t)
  :init
  (setq company-backends '(company-capf
			   company-elisp
			   company-cmake
			   company-yasnippet
			   company-files
			   company-keywords
			   company-etags
			   company-gtags
			   company-ispell)))
(use-package company-box
  :after company
  :diminish
  :hook (company-mode . company-box-mode))
(use-package company-prescient
  :after company
  :config (company-prescient-mode))

(use-package ivy
  :bind
  ;; ivy-resume resumes the last Ivy-based completion.
  (("C-c C-r" . ivy-resume)
   ("C-x B" . ivy-switch-buffer-other-window))
  :diminish
  :custom
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  (setq enable-recursive-minibuffers t)
  :config
  (ivy-mode))
(use-package ivy-rich
  :after ivy
  :ensure t
  :init (ivy-rich-mode 1) ;; this gets us descriptions in M-x.
  :custom
  (ivy-virtual-abbreviate 'full
   ivy-rich-switch-buffer-align-virtual-buffer t
   ivy-rich-path-style 'abbrev)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer
                               'ivy-rich-switch-buffer-transformer))
(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))
(use-package counsel
  :after ivy
  :diminish
  :config
  (counsel-mode)
  (setq ivy-initial-inputs-alist nil)) ; removes starting ^ regex in M-x

;;
;; Coding
;;
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)) ; treat .h files as C++ code rather than plain C code.

(use-package yasnippet
  :config (yas-global-mode))
(use-package yasnippet-snippets)
(use-package ivy-yasnippet)

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (c-mode-hook . lsp)
  :hook (c++-mode-hook . lsp)
  :init
  (setq lsp-keymap-prefix "M-p")
  :config
  (setq gc-cons-threshold (* 100 1024 1024)
	read-process-output-max (* 1024 1024)
	company-idle-delay 0.0
	company-minimum-prefix-length 1
	lsp-idle-delay 0.1) ; clangd is fast
  (lsp-enable-which-key-integration t))
(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :config (setq lsp-ui-doc-position 'bottom))
(use-package lsp-ivy)

;;; init.el ends here
