;;; flymake configuration for lua

;;; assumes luac is in $PATH
;;; Install:
;;          copy flymake-lua.el somewhere in your load-path
;;
;;          in ~/.emacs:
;;             (eval-after-load 'lua-mode '(add-hook 'lua-mode-hook 'flymake-lua-setup))
;;             (autoload #'flymake-lua-setup "flymake-lua" nil t)

;; use ~/tmp for temp files
(defvar flymake-temp-dir "~/tmp")

;; (setq flymake-log-level 3)

;;; disable moronic modal dialog

(setq flymake-gui-warnings-enabled nil)

(define-key lua-mode-map (kbd "C-x `") 'flymake-goto-next-error)

(custom-set-faces
 '(flymake-errline ((t (:underline "red"))))
 '(flymake-warnline ((t (:underline "yellow")))))

(eval-after-load 'flymake 
  '(progn 
     (defun flymake-get-temp-dir ()
       (if (and (boundp 'flymake-temp-dir)
                (file-readable-p flymake-temp-dir))
           flymake-temp-dir
         temporary-file-directory))))

(defun flymake-lua-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-in-temp-dir))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "luac" (list "-p" local-file))))

(defun flymake-lua-setup ()
  (make-local-variable 'flymake-allowed-file-name-masks)
  (make-local-variable 'flymake-err-line-patterns)
  (make-local-variable 'flymake-no-changes-timeout)

  (setq flymake-allowed-file-name-masks
        '(("\\.lua\\'" flymake-lua-init)))
  (setq flymake-err-line-patterns
        '(("^.*luac[0-9.]*\\(.exe\\)?: *\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 2 3 nil 4)))

  (setq flymake-no-changes-timeout 1)
  (flymake-mode 1))

(defun flymake-create-in-temp-dir (file-name &optional dir)
  (let ((temporary-file-directory (flymake-get-temp-dir)))
    (make-temp-file (file-name-nondirectory file-name))))

(provide 'flymake-lua)
