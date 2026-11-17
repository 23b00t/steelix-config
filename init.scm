;;; init.scm – Steel plugin config for steelix (Helix + Steel)
;;;
;;; Plugins are managed declaratively by smith.hx (https://github.com/kn66/smith.hx).
;;; smith itself comes from Nix (NoX: STEEL_SEARCH_PATHS, no forge install).
;;; Smith installs each declaration via `forge pkg install --git ...`,
;;; loads it, and then runs `config` and `bind`.
;;; Plugins that get removed here are uninstalled again by `(smith-init)`.

(require (only-in "smith.hx/smith.scm"
                  smith-plugin
                  smith-init))

;; ---------------------------------------------------------------------------
;; Libraries (also pulled in as dependencies of forest/scopeline,
;; declared explicitly here so they are managed by smith)
;; ---------------------------------------------------------------------------

;; notify.hx – notification popups (also `:notify "..."`)
(smith-plugin "chuwy/notify.hx"
  (config
   ;; 'default or 'minimal (smaller popups)
   (notify-config 'render 'default)))

;; glyph.hx – Nerd Font icons/colors for other plugins (needs a Nerd Font in the terminal)
(smith-plugin "Ra77a3l3-jar/glyph.hx")

;; ---------------------------------------------------------------------------
;; forest.hx – file tree (Space e)
;; ---------------------------------------------------------------------------
(smith-plugin "Ra77a3l3-jar/forest.hx"
  (config
   (forest-configure! 'left #:ignore (list ".git" "target" "node_modules" "__pycache__" ".direnv" "result"))
   ;; 'snacks = persistent sidebar, 'mini = floating Miller columns
   (forest-set-style! 'snacks)
   ;; j/k wrap within the folder, h/l leave/enter
   (forest-snack-circular-keybinds #t))
  (bind
   ("normal" ("space" "e") ":forest-open")))

;; ---------------------------------------------------------------------------
;; scopeline.hx – breadcrumb bar (:scopeline-toggle)
;; ---------------------------------------------------------------------------
(smith-plugin "Ra77a3l3-jar/scopeline.hx"
  (config
   (scopeline-configure! #:separator " › "
                         #:max-depth 0
                         #:show-file? #t
                         #:position 'top-left
                         #:always-reserved? #t)))

;; ---------------------------------------------------------------------------
;; zj-navigator.hx – A-h/j/k/l across Helix splits and Zellij panes
;; The plugin binds A-hjkl itself (insert, normal, select). The Zellij side
;; (hx-navigator WASM plugin + MessagePlugin bindings) comes from Nix, see README.md.
;; ---------------------------------------------------------------------------
(smith-plugin "dmyyy/zj-navigator.hx")

;; ---------------------------------------------------------------------------
;; Sync after all declarations (install, load, prune)
;; ---------------------------------------------------------------------------
(smith-init)
