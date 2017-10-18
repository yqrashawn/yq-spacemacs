;;; packages.el --- Spacemacs Layouts Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(setq spacemacs-layouts-packages
      '(eyebrowse
        ;; persp-fr
        ;; helm
        ivy
        persp-mode
        ;; spaceline
        swiper))



(defun spacemacs-layouts/init-eyebrowse ()
  (use-package eyebrowse
    :init
    (progn
      (setq eyebrowse-wrap-around t)
      (setq eyebrowse-mode-line-style nil)
      (eyebrowse-mode)
      ;; transient state
      (spacemacs|transient-state-format-hint workspaces
        spacemacs--workspaces-ts-full-hint
        "\n\n
 Go to^^^^^^                         Actions^^
 ─────^^^^^^───────────────────────  ───────^^──────────────────────
 [_0_.._9_]^^     nth/new workspace  [_d_] close current workspace
 [_C-0_.._C-9_]^^ nth/new workspace  [_R_] rename current workspace
 [_<tab>_]^^^^    last workspace     [_?_] toggle help\n
 [_l_]^^^^        layouts
 [_n_/_C-l_]^^    next workspace
 [_N_/_p_/_C-h_]  prev workspace\n")

      (spacemacs|define-transient-state workspaces
        :title "Workspaces Transient State"
        :hint-is-doc t
        :dynamic-hint (spacemacs//workspaces-ts-hint)
        :bindings
        ("?" spacemacs//workspaces-ts-toggle-hint)
        ("0" eyebrowse-switch-to-window-config-0 :exit t)
        ("1" eyebrowse-switch-to-window-config-1 :exit t)
        ("2" eyebrowse-switch-to-window-config-2 :exit t)
        ("3" eyebrowse-switch-to-window-config-3 :exit t)
        ("4" eyebrowse-switch-to-window-config-4 :exit t)
        ("5" eyebrowse-switch-to-window-config-5 :exit t)
        ("6" eyebrowse-switch-to-window-config-6 :exit t)
        ("7" eyebrowse-switch-to-window-config-7 :exit t)
        ("8" eyebrowse-switch-to-window-config-8 :exit t)
        ("9" eyebrowse-switch-to-window-config-9 :exit t)
        ("C-0" eyebrowse-switch-to-window-config-0)
        ("C-1" eyebrowse-switch-to-window-config-1)
        ("C-2" eyebrowse-switch-to-window-config-2)
        ("C-3" eyebrowse-switch-to-window-config-3)
        ("C-4" eyebrowse-switch-to-window-config-4)
        ("C-5" eyebrowse-switch-to-window-config-5)
        ("C-6" eyebrowse-switch-to-window-config-6)
        ("C-7" eyebrowse-switch-to-window-config-7)
        ("C-8" eyebrowse-switch-to-window-config-8)
        ("C-9" eyebrowse-switch-to-window-config-9)
        ("<tab>" eyebrowse-last-window-config)
        ("C-h" eyebrowse-prev-window-config)
        ("C-i" eyebrowse-last-window-config)
        ("C-l" eyebrowse-next-window-config)
        ("d" eyebrowse-close-window-config)
        ("l" spacemacs/layouts-transient-state/body :exit t)
        ("n" eyebrowse-next-window-config)
        ("N" eyebrowse-prev-window-config)
        ("p" eyebrowse-prev-window-config)
        ("R" spacemacs/workspaces-ts-rename :exit t)
        ("w" eyebrowse-switch-to-window-config :exit t))
      ;; note: we don't need to declare the `SPC l w' binding, it is
      ;; declare in the layout transient state
      (spacemacs/set-leader-keys "bW" 'spacemacs/goto-buffer-workspace)
      ;; hooks
      (add-hook 'persp-before-switch-functions
                #'spacemacs/update-eyebrowse-for-perspective)
      (add-hook 'eyebrowse-post-window-switch-hook
                #'spacemacs/save-eyebrowse-for-perspective)
      (add-hook 'persp-activated-functions
                #'spacemacs/load-eyebrowse-for-perspective)
      (add-hook 'persp-before-save-state-to-file-functions #'spacemacs/update-eyebrowse-for-perspective)
      (add-hook 'persp-after-load-state-functions #'spacemacs/load-eyebrowse-after-loading-layout)
      ;; vim-style tab switching
      (define-key evil-motion-state-map "gt" 'eyebrowse-next-window-config)
      (define-key evil-motion-state-map "gT" 'eyebrowse-prev-window-config))))



;; (defun spacemacs-layouts/post-init-helm ()
;;   (spacemacs/set-leader-keys
;;     "Bb" 'spacemacs-layouts/non-restricted-buffer-list-helm
;;     "pl" 'spacemacs/helm-persp-switch-project))



(defun spacemacs-layouts/post-init-ivy ()
  (spacemacs/set-leader-keys
    "Bb" 'spacemacs-layouts/non-restricted-buffer-list-ivy))


(defun spacemacs-layouts/init-persp-mode ()
  (use-package persp-mode
    :init
    (progn
      (setq persp-auto-resume-time (if (or dotspacemacs-auto-resume-layouts
                                           spacemacs-force-resume-layouts)
                                       0.3 -1)
            persp-nil-name dotspacemacs-default-layout-name
            persp-reset-windows-on-nil-window-conf nil
            persp-set-last-persp-for-new-frames nil
            persp-save-dir spacemacs-layouts-directory
            persp-auto-save-persps-to-their-file-before-kill t
            persp-auto-save-num-of-backups 100
            persp-hook-up-emacs-buffer-completion t ;; try to restrict buffer list
            persp-set-read-buffer-function t ;; read buffer func to persp-read-buffre
            persp-interactive-completion-system 'ivy-completing-read
            persp-remove-buffers-from-nil-persp-behaviour nil
            persp-autokill-buffer-on-remove 'kill
            persp-kill-foreign-buffer-behaviour 'kill
            ;; persp-common-buffer-filter-functions ;; need to add projectile here
            ;; persp-filter-save-buffers-functions ;; "Additional filters to not save unneeded buffers."
            persp-set-ido-hooks t)

      (global-set-key (kbd "C-x b") #'(lambda (arg)
                                        (interactive "P")
                                        (with-persp-buffer-list () (ibuffer arg))))

      ;; mru
      ;; (with-eval-after-load "persp-mode"
      ;;   (add-hook 'persp-before-switch-functions
      ;;             #'(lambda (new-persp-name w-or-f)
      ;;                 (let ((cur-persp-name (safe-persp-name (get-current-persp))))
      ;;                   (when (member cur-persp-name persp-names-cache)
      ;;                     (setq persp-names-cache
      ;;                           (cons cur-persp-name
      ;;                                 (delete cur-persp-name persp-names-cache)))))))

      ;;   (add-hook 'persp-renamed-functions
      ;;             #'(lambda (persp old-name new-name)
      ;;                 (setq persp-names-cache
      ;;                       (cons new-name (delete old-name persp-names-cache)))))

      ;;   (add-hook 'persp-before-kill-functions
      ;;             #'(lambda (persp)
      ;;                 (setq persp-names-cache
      ;;                       (delete (safe-persp-name persp) persp-names-cache))))

      ;;   (add-hook 'persp-created-functions
      ;;             #'(lambda (persp phash)
      ;;                 (when (and (eq phash *persp-hash*)
      ;;                            (not (member (safe-persp-name persp)
      ;;                                         persp-names-cache)))
      ;;                   (setq persp-names-cache
      ;;                         (cons (safe-persp-name persp) persp-names-cache))))))

      ;; ivy
      (with-eval-after-load "persp-mode"
        (with-eval-after-load "ivy"
          (add-hook 'ivy-ignore-buffers
                    #'(lambda (b)
                        (when persp-mode
                          (let ((persp (get-current-persp)))
                            (if persp
                                (not (persp-contain-buffer-p b persp))
                              nil)))))

          (setq ivy-sort-functions-alist
                (append ivy-sort-functions-alist
                        '((persp-kill-buffer   . nil)
                          (persp-remove-buffer . nil)
                          (persp-add-buffer    . nil)
                          (persp-switch        . nil)
                          (persp-window-switch . nil)
                          (persp-frame-switch  . nil))))))

      ;; ibuffer
      ;; Simplified variant. Add only current perspective group.
      (with-eval-after-load "ibuffer"

        (require 'ibuf-ext)

        (define-ibuffer-filter persp
            "Toggle current view to buffers of current perspective."
          (:description "persp-mode"
                        :reader (persp-prompt nil nil (safe-persp-name (get-frame-persp)) t))
          (find buf (safe-persp-buffers (persp-get-by-name qualifier))))

        (defun persp-add-ibuffer-group ()
          (let ((perspslist (list (safe-persp-name (get-frame-persp))
                                  (cons 'persp (safe-persp-name (get-frame-persp))))))
            (setq ibuffer-saved-filter-groups
                  (delete* "persp-mode" ibuffer-saved-filter-groups
                           :test 'string= :key 'car))
            (push
             (cons "persp-mode" perspslist)
             ibuffer-saved-filter-groups)))

        (add-hook 'ibuffer-mode-hook
                  #'(lambda ()
                      (persp-add-ibuffer-group)
                      (ibuffer-switch-to-saved-filter-groups "persp-mode"))))


      ;; Shows groups for all perspectives. But can't show same buffer in multiple groups.
      (with-eval-after-load "ibuffer"
        (require 'ibuf-ext)

        (define-ibuffer-filter persp
            "Toggle current view to buffers of current perspective."
          (:description "persp-mode"
                        :reader (persp-prompt nil nil (safe-persp-name (get-frame-persp)) t))
          (find buf (safe-persp-buffers (persp-get-by-name qualifier))))

        (defun persp-add-ibuffer-group ()
          (let ((perspslist (mapcar #'(lambda (pn)
                                        (list pn (cons 'persp pn)))
                                    (nconc
                                     (delete* persp-nil-name
                                              (persp-names-current-frame-fast-ordered)
                                              :test 'string=)
                                     (list persp-nil-name)))))
            (setq ibuffer-saved-filter-groups
                  (delete* "persp-mode" ibuffer-saved-filter-groups
                           :test 'string= :key 'car))
            (push
             (cons "persp-mode" perspslist)
             ibuffer-saved-filter-groups)))

        (defun persp-ibuffer-visit-buffer ()
          (let ((buf (ibuffer-current-buffer t))
                (persp-name (get-text-property
                             (line-beginning-position) 'ibuffer-filter-group)))
            (persp-switch persp-name)
            (switch-to-buffer buf)))

        (define-key ibuffer-mode-map (kbd "RET") 'persp-ibuffer-visit-buffer)

        (add-hook 'ibuffer-mode-hook
                  #'(lambda ()
                      (persp-add-ibuffer-group)
                      (ibuffer-switch-to-saved-filter-groups "persp-mode"))))


      (defun spacemacs//activate-persp-mode ()
        "Always activate persp-mode, unless it is already active.
 (e.g. don't re-activate during `dotspacemacs/sync-configuration-layers' -
 see issues #5925 and #3875)"
        (unless (bound-and-true-p persp-mode)
          (persp-mode)))
      (spacemacs/defer-until-after-user-config #'spacemacs//activate-persp-mode)

      ;; layouts transient state
      (spacemacs|transient-state-format-hint layouts
        spacemacs--layouts-ts-full-hint
        "\n\n
 Go to^^^^^^                                  Actions^^
 ─────^^^^^^────────────────────────────────  ───────^^──────────────────────────────────────────────────
 [_0_.._9_]^^     nth/new layout              [_a_]^^   add buffer
 [_C-0_.._C-9_]^^ nth/new layout              [_A_]^^   add all from layout
 [_<tab>_]^^^^    last layout                 [_d_]^^   close current layout
 [_b_]^^^^        buffer in layout            [_D_]^^   close other layout
 [_h_]^^^^        default layout              [_r_]^^   remove current buffer
 [_l_]^^^^        layout w/helm/ivy           [_R_]^^   rename current layout
 [_L_]^^^^        layouts in file             [_s_/_S_] save all layouts/save by names
 [_n_/_C-l_]^^    next layout                 [_t_]^^   show a buffer without adding it to current layout
 [_N_/_p_/_C-h_]  prev layout                 [_x_]^^   kill current w/buffers
 [_o_]^^^^        custom layout               [_X_]^^   kill other w/buffers
 [_w_]^^^^        workspaces transient state  [_?_]^^   toggle help\n")

      (spacemacs|define-transient-state layouts
        :title "Layouts Transient State"
        :hint-is-doc t
        :dynamic-hint (spacemacs//layouts-ts-hint)
        :bindings
        ;; need to exit in case number doesn't exist
        ("?" spacemacs//layouts-ts-toggle-hint)
        ("1" spacemacs/persp-switch-to-1 :exit t)
        ("2" spacemacs/persp-switch-to-2 :exit t)
        ("3" spacemacs/persp-switch-to-3 :exit t)
        ("4" spacemacs/persp-switch-to-4 :exit t)
        ("5" spacemacs/persp-switch-to-5 :exit t)
        ("6" spacemacs/persp-switch-to-6 :exit t)
        ("7" spacemacs/persp-switch-to-7 :exit t)
        ("8" spacemacs/persp-switch-to-8 :exit t)
        ("9" spacemacs/persp-switch-to-9 :exit t)
        ("0" spacemacs/persp-switch-to-0 :exit t)
        ("C-1" spacemacs/persp-switch-to-1)
        ("C-2" spacemacs/persp-switch-to-2)
        ("C-3" spacemacs/persp-switch-to-3)
        ("C-4" spacemacs/persp-switch-to-4)
        ("C-5" spacemacs/persp-switch-to-5)
        ("C-6" spacemacs/persp-switch-to-6)
        ("C-7" spacemacs/persp-switch-to-7)
        ("C-8" spacemacs/persp-switch-to-8)
        ("C-9" spacemacs/persp-switch-to-9)
        ("C-0" spacemacs/persp-switch-to-0)
        ("<tab>" spacemacs/jump-to-last-layout)
        ("<return>" nil :exit t)
        ("C-h" persp-prev)
        ("C-l" persp-next)
        ("a" persp-add-buffer :exit t)
        ("A" persp-import-buffers :exit t)
        ("b" spacemacs/ivy-spacemacs-layout-buffer :exit t)
        ("d" spacemacs/layouts-ts-close)
        ("D" spacemacs/layouts-ts-close-other :exit t)
        ("h" spacemacs/layout-goto-default :exit t)
        ("l" spacemacs/ivy-spacemacs-layouts :exit t)
        ("L" persp-load-state-from-file :exit t)
        ("n" persp-next)
        ("N" persp-prev)
        ("o" spacemacs/select-custom-layout :exit t)
        ("p" persp-prev)
        ("r" persp-remove-buffer :exit t)
        ("R" spacemacs/layouts-ts-rename :exit t)
        ("s" persp-save-state-to-file :exit t)
        ("S" persp-save-to-file-by-names :exit t)
        ("t" persp-temporarily-display-buffer :exit t)
        ("w" spacemacs/workspaces-transient-state/body :exit t)
        ("x" spacemacs/layouts-ts-kill)
        ("X" spacemacs/layouts-ts-kill-other :exit t))
      (spacemacs/set-leader-keys "l" 'spacemacs/layouts-transient-state/body)
      ;; custom layouts
      (spacemacs|define-custom-layout "@Spacemacs"
        :binding "e"
        :body
        (spacemacs/find-dotfile)))
    :config
    (progn
      (spacemacs|hide-lighter persp-mode)
      (defadvice persp-activate (before spacemacs//save-toggle-layout activate)
        (setq spacemacs--last-selected-layout persp-last-persp-name))
      (add-hook 'persp-mode-hook 'spacemacs//layout-autosave)
      (spacemacs/declare-prefix "b" "persp-buffers")
      (spacemacs/declare-prefix "B" "global-buffers")
      ;; Override SPC TAB to only change buffers in perspective
      (spacemacs/set-leader-keys
        "TAB"  'spacemacs/alternate-buffer-in-persp
        "ba"   'persp-add-buffer
        "br"   'persp-remove-buffer))))



;; (defun spacemacs-layouts/post-init-spaceline ()
;;   (setq spaceline-display-default-perspective
;;         dotspacemacs-display-default-layout))



(defun spacemacs-layouts/post-init-swiper ()
  (spacemacs/set-leader-keys "pl" 'spacemacs/ivy-persp-switch-project))


;; (defun spacemacs-layouts/init-persp-fr ()
  ;; (persp-fr-start))
