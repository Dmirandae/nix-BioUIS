;; Start with a clean Emacs configuration.
;; This file is a good starting point for editing and running
;; R, Quarto, LaTeX, and other related files.


;; DRME 2025 08 18

;; --- Package Management Setup ---
;; Ensure package.el is initialized for managing Emacs packages.
(setq package-enable-at-startup nil) ; Prevent `package.el` from loading packages at startup
(require 'package)
;; Define package archives to fetch packages from.
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu"   . "https://elpa.gnu.org/packages/")))
(package-initialize) ; Initialize the package system


;;; fire in paradise:: problem here 2025 08 23
;; Install 'straight.el' for robust and reproducible package management.
;~ (unless (package-installed-p 'straight)
  ;~ (url-retrieve "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
                ;~ (lambda (s) (eval-buffer)) nil t))
;; Enable 'straight.el' by default for all packages.
;~ (setq straight-use-package-by-default t)


;; Use 'use-package' for declarative package configuration.
;; This ensures packages are installed and configured cleanly.
(require 'use-package)
;; Configure 'use-package' to automatically install missing packages.
(setq use-package-always-ensure t)


;; --- Emacs UI and Performance Tweaks ---
;; Increase garbage collection threshold for smoother performance.
(setq gc-cons-threshold 16777216)
;; Increase process output buffer size.
(setq read-process-output-max (* 1024 1024))
;; Set default tab width and disable tabs for indentation.
(setq tab-width 2)
(setq-default indent-tabs-mode nil)
;; Enable Transient Mark mode (region highlighting).
(setq transient-mark-mode t)
;; Hide UI elements for a cleaner look.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Load the Zenburn theme for visual aesthetics.
(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))


;; --- Core Modes & Language Support ---

;; ESS (Emacs Speaks Statistics) for R and statistical programming.
(use-package ess
  :config
  ;; Set default ESS style for R.
  (setq ess-default-style 'R-style)
  ;; Set the inferior R program path.
  (setq inferior-ess-program "R")
  ;; Enable company-mode and tabnine integration for ESS (if available).
  (ess-use-company-and-tabnine)
  ;; Ensure 'ess-eval-visibly' and 'ess-eval-linewise-and-invisibly' are set for interactive evaluation.
  (setq ess-eval-visibly 'now)
  (setq ess-eval-linewise-and-invisibly 'now))

;; Polymode for multi-mode files like Quarto (.qmd) and R Markdown (.Rmd).
(use-package polymode
  :config
  ;; Associate .qmd files with poly-quarto-mode (within polymode framework).
  (add-to-list 'auto-mode-alist '("\\.qmd\\'" . poly-quarto-mode))
  ;; Associate .Rmd files with poly-r-mode (within polymode framework).
  (add-to-list 'auto-mode-alist '("\\.Rmd\\'" . poly-r-mode)))

;; Markdown Mode for editing Markdown files.
(use-package markdown-mode)

;; AUCTeX for comprehensive LaTeX support.
(use-package auctex
  :config
  ;; Associate .tex files with LaTeX mode.
  (add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode)))

;; PDF Tools for viewing PDF files within Emacs.
(use-package pdf-tools
  :config
  (pdf-tools-install) ; Install PDF tools backend (requires external compilation)
  (setq pdf-view-use-multithreaded-renderer t))

;; CSV Mode for editing Comma Separated Values files.
(use-package csv-mode
  :config
  (setq csv-separator ?\,) ; Set comma as the default separator
  (add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode)))


;; --- Autocompletion and Bibliography Management ---

;; Company Mode provides the general autocompletion framework.
(use-package company
  :init
  (global-company-mode t)         ; Enable Company mode globally for all buffers
  :config
  ;; Customize common completion settings for Company mode.
  (setq company-idle-delay 0.1    ; Shorter delay for suggestions to appear
        company-minimum-prefix-length 2 ; Start suggestions after 1 character
        company-tooltip-limit 10)) ; Limit the number of suggestions in the tooltip

;; Helm-Bibtex for advanced BibTeX bibliography management and completion.
(use-package helm-bibtex
  :after (company)                ; Ensure Company mode is loaded before helm-bibtex
  :init
  ;; IMPORTANT: Set the path(s) to your .bib file(s).
  ;; Replace "~/bib/bib.bib" with your actual primary BibTeX file path.
  ;; You can add multiple files as a list: '("~/file1.bib" "~/file2.bib")'
  (setq bibtex-completion-bibliography '("~/bib/bib.bib"))
  ;; Optional: Set a directory for notes associated with your BibTeX entries.
  ;; (setq bibtex-completion-notes-path '("~/Documents/latex/bibtex-notes/"))
  ;; Specify how to open associated PDF files (e.g., using 'find-file').
  (setq bibtex-completion-pdf-open-function 'find-file)

  :config
  ;; Add bibtex-completion to company-backends for LaTeX-mode and Org-mode.
  ;; This tells Company to use bibtex-completion for citation suggestions.
  (add-to-list 'company-backends 'company-bibtex :before 'company-files)
  (add-to-list 'company-backends 'company-bibtex-labels :before 'company-files)

  ;; Add company-bibtex to company-backends specifically for LaTeX and Org modes.
  (add-hook 'LaTeX-mode-hook (lambda ()
                               (setq-local company-backends (append '((company-bibtex company-yasnippet)) company-backends))))
  (add-hook 'org-mode-hook (lambda ()
                             (setq-local company-backends (append '((company-bibtex company-yasnippet)) company-backends))))

  ;; Define keybindings for helm-bibtex interactive search in LaTeX and Org modes.
  (define-key LaTeX-mode-map (kbd "C-c b") 'helm-bibtex)
  (define-key org-mode-map (kbd "C-c b") 'helm-bibtex))

;; Ensure .bib files are associated with bibtex-mode for basic editing.
(add-to-list 'auto-mode-alist '("\\.bib\\'" . bibtex-mode))


;; --- Dictionaries and Spell Checking ---
;; Define a function to set Ispell program to Aspell and dictionary to Spanish.
(defun my-set-ispell-spanish ()
  "Set Ispell program to Aspell and dictionary to Spanish."
  (interactive) ; Allows the function to be called interactively (e.g., with M-x)
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "es")
  (message "Ispell set to Aspell with Spanish dictionary."))

;; Define a function to set Ispell program to Aspell and dictionary to English.
(defun my-set-ispell-english ()
  "Set Ispell program to Aspell and dictionary to English."
  (interactive)
  (setq ispell-program-name "aspell")
  (setq ispell-dictionary "en") ; Set dictionary to English
  (message "Ispell set to Aspell with English dictionary."))

;; Bind the F11 key to set Ispell to Spanish.
(global-set-key (kbd "<f11>") 'my-set-ispell-spanish)
;; Bind the F12 key to set Ispell to English.
(global-set-key (kbd "<f12>") 'my-set-ispell-english)
;; Bind the F10 key to spell check the current buffer.
(global-set-key (kbd "<f9>") 'ispell-buffer)


;; --- Custom Local Modes and Other Tools ---
;; Load a custom TNT mode file from a specific path.
;; Make sure this file exists at the specified path.
;(load-file "/home/rafael/Documents/emacs/tnt-unified-mode.el")

;; Set up a custom keybinding for easy compilation.
(global-set-key (kbd "C-c C-c") 'compile)
(setq compilation-read-command nil)
(setq compilation-scroll-output 'scroll-up)

;; Enable global auto-revert mode to automatically refresh buffers when files change on disk.
(global-auto-revert-mode t)
;; Enable top-save mode to save and restore Emacs sessions.
(desktop-save-mode 1)


;; --- Mode Switching Keybindings ---
;; These keybindings allow for quick switching between Org and R modes.
(global-set-key (kbd "<f5>") 'org-mode)
(global-set-key (kbd "<f6>") 'R-mode)
(global-set-key (kbd "<f8>") 'other-window)
