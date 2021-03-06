
(add-to-list 'load-path "~/.emacs.d/ibus-el-0.3.2/")

(require 'package)

; Add package-archives
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/")) ; ついでにmarmaladeも追加

; Initialize
(package-initialize)

(require 'server)
(unless (server-running-p)
  (server-start))

(when (locate-library "edit-server")
  (require 'edit-server)
  (defvar edit-server-new-frame nil)
  (edit-server-start))

; melpa.el
; (require 'melpa)

(when (require 'helm-config nil t)
  (helm-mode 1)

  (define-key global-map (kbd "M-x")     'helm-M-x)
  (define-key global-map (kbd "C-x C-f") 'helm-find-files)
  (define-key global-map (kbd "C-x C-r") 'helm-recentf)
  (define-key global-map (kbd "M-y")     'helm-show-kill-ring)
  (define-key global-map (kbd "C-c i")   'helm-imenu)
  (define-key global-map (kbd "C-x b")   'helm-buffers-list)

  (define-key helm-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)
  (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
  (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

  ;; Disable helm in some functions
  (add-to-list 'helm-completing-read-handlers-alist '(find-alternate-file . nil))

  ;; Emulate `kill-line' in helm minibuffer
  (setq helm-delete-minibuffer-contents-from-point t)
  (defadvice helm-delete-minibuffer-contents (before helm-emulate-kill-line activate)
    "Emulate `kill-line' in helm minibuffer"
    (kill-new (buffer-substring (point) (field-end))))

  (defadvice helm-ff-kill-or-find-buffer-fname (around execute-only-if-exist activate)
    "Execute command only if CANDIDATE exists"
    (when (file-exists-p candidate)
      ad-do-it))

  (defadvice helm-ff-transform-fname-for-completion (around my-transform activate)
    "Transform the pattern to reflect my intention"
    (let* ((pattern (ad-get-arg 0))
           (input-pattern (file-name-nondirectory pattern))
           (dirname (file-name-directory pattern)))
      (setq input-pattern (replace-regexp-in-string "\\." "\\\\." input-pattern))
      (setq ad-return-value
            (concat dirname
                    (if (string-match "^\\^" input-pattern)
                        ;; '^' is a pattern for basename
                        ;; and not required because the directory name is prepended
                        (substring input-pattern 1)
                      (concat ".*" input-pattern)))))))


;;appearance
(setq initial-major-mode 'text-mode)
(setq initial-scratch-message "\n\n         Cheer up!\n\n")		 
(setq ring-bell-function 'ignore)


(load-theme 'zenburn t)

(set-face-attribute 'default nil
                    :family "ricty"
                    :height 110)

(set-face-background 'region "#52455b")

(setq default-frame-alist initial-frame-alist)

(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode 0)

(show-paren-mode 1)
;; (display-time)
(transient-mark-mode 1)

(require 'linum)
(global-linum-mode t)
(column-number-mode t)
(line-number-mode t)

;; (require 'powerline)
;; (powerline-default-theme)

(require 'volatile-highlights)
(volatile-highlights-mode t)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vhl/default-face ((t (:inherit secondary-selection :background "blue")))))

(require 'elscreen)
(elscreen-set-prefix-key "\C-z")
(elscreen-start)
(define-key global-map (kbd "<C-tab>") 'elscreen-next)
(define-key global-map (kbd "<C-iso-lefttab>") 'elscreen-previous)

 
;; misc 

(setq indent-line-function 'indent-relative-maybe)
(setq indent-tabs-mode nil)
(delete-selection-mode t)


(setq x-select-enable-clipboard t)


(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; (prefer-coding-system 'euc-jp-unix)
;; (setq coding-system-for-read 'euc-jp-unix)
;; (setq coding-system-for-write 'euc-jp-unix)


(require 'smooth-scrolling)
(setq smooth-scroll-margin 6)

(require 'zlc)
(setq zlc-select-completion-immediately nil)


(setq gc-cons-threshold (* 1000 gc-cons-threshold))
(setq echo-keystrokes 0.000000001)

(setq history-length 20000)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)

(defun clone-line-forward ()
  (interactive "*")
  (save-excursion
    (let ((contents (buffer-substring
		     (line-beginning-position)
		     (line-end-position))))
      (end-of-line)
      (insert ?\n contents)))
  (forward-line 1))


(setq x-select-enable-clipboard t)

(require 'autoinsert)
(auto-insert-mode t)
(setq auto-insert-dircetory "~/.emacs.d/templates/")

(setq auto-insert-alits
      (nconc '(("\\.org$" . "templates.org")) auto-insert-alist))             
               


(require 'auto-complete)
(global-auto-complete-mode t)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)
(add-to-list 'ac-modes 'fundamental-mode)
(add-to-list 'ac-modes 'lisp-mode)
(add-to-list 'ac-modes 'haskell-mode)
(add-to-list 'ac-modes 'lua-mode)
(add-to-list 'ac-modes 'python-mode)
(add-to-list 'ac-modes 'org-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)
;;(setq ac-use-fuzzy t)



(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-t" 'other-window)
(global-set-key [(C \,)] 'goto-line)
(global-set-key "\C-j" 'clone-line-forward)
(global-set-key "\C-h" 'ace-jump-mode)
(global-set-key "\M-o" 'toggle-input-method)




;; (global-set-key [(tab)] 'indent-according-to-mode)
(global-set-key "\C-cc" 'comment-region)
(global-set-key "\C-cu" 'uncomment-region)
(global-set-key "\C-cs" 'set-variable)
(global-set-key "\C-\\" 'delete-other-windows)
(global-set-key [(C \')] 'cua-rectangle-mark-mode)

(define-key ctl-x-map "rp" 'replace-string)
(define-key ctl-x-map "re" 'replace-regexp)
(define-key ctl-x-map "gl" 'goto-last-change)
(define-key ctl-x-map "gr" 'goto-last-change-reverse)
(define-key ctl-x-map "al" 'align-regexp)
;; (define-key ctl-x-map "rh" 'toggle-crosshair-mode)
(define-key ctl-x-map "m" 'make-directory)

(global-set-key [(M n)] 'next-flymake-error)
(global-set-key [(M p)] 'previous-flymake-error)


(setq inferior-lisp-program "sbcl")

(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(setq slime-startup-animation nil)
(setq slime-use-autodoc-mode t)
(slime-setup '(slime-repl))
;HyperSpecを読み込む.
;HyperSpecがインストールされている場所「/usr/share/doc/hyperspec/」
(setq common-lisp-hyperspec-root
      (concat "file://" (expand-file-name "/usr/share/doc/hyperspec/"))
      common-lisp-hyperspec-symbol-table
      (expand-file-name "/usr/share/doc/hyperspec/Data/Map_Sym.txt"))

(add-hook 'lisp-mode-hook (lambda ()
			    (rainbow-delimiters-mode)
			    (paredit-mode)))

(require 'ac-slime)
(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook
	  (lambda ()
	    (delete-selection-mode t)
	    (define-key slime-repl-mode-map "\C-l" 'slime-repl-clear-buffer)))


;; (require 'mozc)
;; (global-set-key [(C \')] 'mozc-mode)

(set-language-environment "Japanese")
(require 'mozc)  ; or (load-file "/path/to/mozc.el")
(setq default-input-method "japanese-mozc")


(require 'ibus)
(setq ibus-agent-file-name "~/.emacs.d/ibus-el-0.3.2/ibus-el-agent")
(add-hook 'after-init-hook 'ibus-mode-on)



(require 'haskell)

(add-to-list 'exec-path "~/.cabal/bin")
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook (lambda ()
			       (ghc-init)
			       (flymake-mode)
			       (define-key haskell-mode-map (kbd "C-\;")
				 'inferior-haskell-load-and-run)))


(defadvice inferior-haskell-load-file (after change-focus-after-load)
  (other-window 1))

(ad-activate 'inferior-haskell-load-file)

(require 'flymake-lua)
(add-hook 'lua-mode-hook (lambda ()
			   (flymake-lua-setup)))

(require 'flymake)


;; python
(defun flymake-python-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list "pyflakes" (list local-file))))

(defconst flymake-allowed-python-file-name-masks '(("\\.py$" flymake-python-init)))
(defvar flymake-python-err-line-patterns '(("\\(.*\\):\\([0-9]+\\):\\(.*\\)" 1 2 nil 3)))

(defun flymake-python-load ()
  (interactive)
  (defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
    (setq flymake-check-was-interrupted t))
  (ad-activate 'flymake-post-syntax-check)
  (setq flymake-allowed-file-name-masks (append flymake-allowed-file-name-masks flymake-allowed-python-file-name-masks))
  (setq flymake-err-line-patterns flymake-python-err-line-patterns)
  (flymake-mode t))



(require 'jedi)
(setq jedi:complete-on-dot t)
(add-hook 'python-mode-hook' (lambda ()
			       (flymake-python-load)
			       (jedi:ac-setup)
                               (elpy-mode t)))


(require 'python)
(define-key python-mode-map (kbd "<C-tab>") 'jedi:complete)

(require 'ob-ipython)
;; コードを評価するとき尋ねない
(setq org-confirm-babel-evaluate nil)
;; ソースコードを書き出すコマンド
(defun org-babel-tangle-and-execute ()
  (interactive)
  (org-babel-tangle)
  (org-babel-execute-buffer)
  (org-display-inline-images))



(require 'yasnippet)
(yas-global-mode 1)
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "C-;") 'yas/expand)

(require 'org)
(define-key org-mode-map (kbd "C-c C-v") 'org-babel-tangle-and-execute)
(add-hook 'org-mode-hook (lambda ()
			   (setq org-src-fontify-natively t)
			   (setq org-src-tab-acts-natively t)))





(defun flymake-simple-generic-init (cmd &optional opts)
  (let* ((temp-file  (flymake-init-create-temp-buffer-copy
		      'flymake-create-temp-inplace))
	 (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list cmd (append opts (list local-file)))))


(defun next-flymake-error ()
  (interactive)
  (flymake-goto-next-error)
  (let* ((err (get-char-property (point) 'help-echo))
	 (line-no (flymake-current-line-no)))
    (when err
      (message err)
      ;;        (notify-error-on-dbus line-no err)
      )))

(defun previous-flymake-error ()
  (interactive)
  (flymake-goto-prev-error)
  (let ((err (get-char-property (point) 'help-echo)))
    (when err
      (message err))))



(require 'migemo)
(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs"))

;; Set your installed path
(setq migemo-dictionary "/usr/share/migemo/utf-8/migemo-dict")

(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(setq migemo-coding-system 'utf-8-unix)
(load-library "migemo")
(migemo-init)

(require 'swoop)
(global-set-key (kbd "C-o")   'swoop)
(global-set-key (kbd "C-M-o") 'swoop-multi)
;; (global-set-key (kbd "M-o")   'swoop-pcre-regexp)
(global-set-key (kbd "C-S-o") 'swoop-back-to-last-position)
 
(define-key isearch-mode-map (kbd "C-o") 'swoop-from-isearch)
(define-key swoop-map (kbd "C-o") 'swoop-multi-from-swoop)
     
;; サイズ変更禁止
(setq swoop-font-size-change: nil)
(setq helm-migemo-mode t)



