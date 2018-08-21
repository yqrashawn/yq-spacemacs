;;; packages.el --- Javascript Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2018 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq javascript-packages
      '(
        add-node-modules-path
        company
        counsel-gtags
        evil-matchit
        flycheck
        js-doc
        js2-mode
        js2-refactor
        prettier-js
        tern
        lsp-mode
        (vue-mode :location (recipe
                             :fetcher github
                             :repo "codefalling/vue-mode"))

        imenu
        (lsp-javascript-typescript
         :requires lsp-mode
         :location (recipe :fetcher github
                           :repo "emacs-lsp/lsp-javascript"))
        org
        tern))

(defun javascript/init-lsp-mode ()
  (use-package lsp-mode
    :defer t
    :init (add-hook 'vue-mode-hook 'lsp-mode)
    :config (spacemacs|hide-lighter lsp-mode)))

(defun javascript/init-vue-mode ()
  (use-package vue-mode
    :defer t
    :mode (("\\.vue\\'" . vue-mode))
    :init (progn
            (spacemacs|add-company-backends
              :backends company-lsp
              :modes vue-mode)
            (add-hook 'vue-mode-hook #'lsp-vue-mmm-enable)
            (add-hook 'vue-mode-hook 'hs-minor-mode)
            (add-hook 'vue-mode-hook 'smartparens-mode))

    :config (progn
              (push 'company-lsp company-backends)
              (with-eval-after-load 'lsp-mode
                (require 'lsp-flycheck))
              (require 'lsp-mode)
              (require 'lsp-vue))))

(defun javascript/post-init-add-node-modules-path ()
  (add-hook 'css-mode-hook #'add-node-modules-path)
  ;; (add-hook 'coffee-mode-hook #'add-node-modules-path)
  (add-hook 'js2-mode-hook #'add-node-modules-path)
  (add-hook 'json-mode-hook #'add-node-modules-path))

(defun javascript/post-init-counsel-gtags ()
  (spacemacs/counsel-gtags-define-keys-for-mode 'js2-mode))

(defun javascript/post-init-evil-matchit ()
  (add-hook `js2-mode `turn-on-evil-matchit-mode))

(defun javascript/post-init-company ()
  (add-hook 'js2-mode-local-vars-hook #'spacemacs//javascript-setup-company))

(defun javascript/post-init-flycheck ()
  (spacemacs/enable-flycheck 'js2-mode))

(defun javascript/post-init-ggtags ()
  (add-hook 'js2-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun javascript/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'js2-mode))

(defun javascript/post-init-imenu ()
  ;; Required to make imenu functions work correctly
  (add-hook 'js2-mode-hook 'js2-imenu-extras-mode))

(defun javascript/post-init-impatient-mode ()
  (spacemacs/set-leader-keys-for-major-mode 'js2-mode
    "i" 'spacemacs/impatient-mode))

(defun javascript/pre-init-org ()
  (spacemacs|use-package-add-hook org
                                  :post-config (add-to-list 'org-babel-load-languages '(js . t))))

(defun javascript/init-js-doc ()
  (use-package js-doc
    :defer t
    :init (spacemacs/js-doc-set-key-bindings 'js2-mode)))

(defun javascript/init-js2-mode ()
  (use-package js2-mode
    :defer t
    :mode "\\.m?js\\'"
    :init
    (progn
      (add-hook 'js2-mode-local-vars-hook
                #'spacemacs//javascript-setup-backend)
      ;; safe values for backend to be used in directory file variables
      (dolist (value '(lsp tern))
        (add-to-list 'safe-local-variable-values
                     (cons 'javascript-backend value))))
    :config
    (progn
      ;; prefixes
      (spacemacs/declare-prefix-for-mode 'js2-mode "mh" "documentation")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mg" "goto")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mr" "refactor")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mz" "folding")
      ;; key bindings
      (spacemacs/set-leader-keys-for-major-mode 'js2-mode
        "m" 'rjsx-mode
        "w" 'js2-mode-toggle-warnings-and-errors
        "zc" 'js2-mode-hide-element
        "zo" 'js2-mode-show-element
        "zr" 'js2-mode-show-all
        "ze" 'js2-mode-toggle-element
        "zF" 'js2-mode-toggle-hide-functions
        "zC" 'js2-mode-toggle-hide-comments))))

(defun javascript/init-js2-refactor ()
  (use-package js2-refactor
    :defer t
    :init
    (progn
      (add-hook 'js2-mode-hook 'spacemacs/js2-refactor-require)
      ;; prefixes
      (spacemacs/declare-prefix-for-mode 'js2-mode "mr3" "ternary")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mra" "add/args")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrb" "barf")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrc" "contract")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mre" "expand/extract")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mri" "inline/inject/introduct")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrl" "localize/log")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrr" "rename")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrs" "split/slurp")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrt" "toggle")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mru" "unwrap")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrv" "var")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mrw" "wrap")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mx" "text")
      (spacemacs/declare-prefix-for-mode 'js2-mode "mxm" "move")
      ;; key bindings
      (spacemacs/set-leader-keys-for-major-mode 'js2-mode
        "r3i" 'js2r-ternary-to-if
        "rag" 'js2r-add-to-globals-annotation
        "rao" 'js2r-arguments-to-object
        "rba" 'js2r-forward-barf
        "rca" 'js2r-contract-array
        "rco" 'js2r-contract-object
        "rcu" 'js2r-contract-function
        "rea" 'js2r-expand-array
        "ref" 'js2r-extract-function
        "rem" 'js2r-extract-method
        "reo" 'js2r-expand-object
        "reu" 'js2r-expand-function
        "rev" 'js2r-extract-var
        "rig" 'js2r-inject-global-in-iife
        "rip" 'js2r-introduce-parameter
        "riv" 'js2r-inline-var
        "rlp" 'js2r-localize-parameter
        "rlt" 'js2r-log-this
        "rrv" 'js2r-rename-var
        "rsl" 'js2r-forward-slurp
        "rss" 'js2r-split-string
        "rsv" 'js2r-split-var-declaration
        "rtf" 'js2r-toggle-function-expression-and-declaration
        "ruw" 'js2r-unwrap
        "rvt" 'js2r-var-to-this
        "rwi" 'js2r-wrap-buffer-in-iife
        "rwl" 'js2r-wrap-in-for-loop
        "k" 'js2r-kill
        "xmj" 'js2r-move-line-down
        "xmk" 'js2r-move-line-up))))

(defun javascript/init-lsp-javascript-typescript ()
  (use-package lsp-javascript-typescript
    :commands lsp-javascript-typescript-enable
    :defer t
    :init (add-hook 'js2-mode-hook 'lsp-mode)
    :config (require 'lsp-javascript-flow)))
(defun javascript/init-prettier-js ()
  (use-package prettier-js
    :mode (("\\.js\\'" . js2-mode) ("\\.html\\'" . web-mode))
    :commands (prettier-js-mode prettier-js)
    :defer t
    :init
    (progn (spacemacs/set-leader-keys-for-major-mode 'css-mode "=" 'prettier-js)
           (spacemacs/set-leader-keys-for-major-mode 'js2-mode "=" 'prettier-js))))
(defun javascript/post-init-tern ()
  (add-to-list 'tern--key-bindings-modes 'js2-mode))
