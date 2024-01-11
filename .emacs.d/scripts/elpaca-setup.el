;;; elpaca-setup.el --- Elpaca Package Manager complete initialization dedicated into one function.
;;; Commentary:
;;;
;;; #    #     ###################################################################
;;;     # #    Ivan Avdonin's (ia, ia93main@gmail.com) personal configuration file
;;; #  #   #   ###################################################################
;;; #  #####   init.el                 : main configuration script
;;; #  #   #   early-init.el           : supplemental script executed early before init.el
;;; #  #   #   scripts/elpaca-setup.el : elpaca dedicated initialization script
;;; #  #   #   scripts/buffer-move.el  : 3rd party helper functions for moving buffers
;;;

;;;
;;; Code:
;;;

;; Elpaca Package Manager initialization routine
;; NOTE(ia): this replaces original package manager being disabled in early-init.el!
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
(when (eq system-type 'windows-nt) ; generally Windows can't handle symlinks unless specific confiuration was done manually
  (elpaca-no-symlink-mode))

;; Support for use-package
(elpaca elpaca-use-package
  (elpaca-use-package-mode)               ; enable :elpaca use-package keyword
  (setq elpaca-use-package-by-default t)) ; assume :elpaca t unless otherwise specified
(elpaca-wait) ; block until current queue processed

;; Don't install anything. Defer execution to BODY
(elpaca nil (message "deferred"))

(provide 'elpaca-setup)
;;; elpaca-setup.el ends here
