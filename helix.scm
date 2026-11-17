;;; helix.scm – everything provided here becomes a typable :command.
;;; Exposes the smith.hx management commands (:smith-list, :smith-update, ...).

(require (only-in "smith.hx/smith.scm"
                  smith-install
                  smith-init
                  smith-self-update
                  smith-ensure
                  smith-plugin
                  smith-configure!
                  smith-lock
                  smith-restore
                  smith-prune
                  smith-update
                  smith-remove
                  smith-enable
                  smith-disable
                  smith-load
                  smith-load-all
                  smith-list))

(provide smith-install
         smith-init
         smith-self-update
         smith-ensure
         smith-plugin
         smith-configure!
         smith-lock
         smith-restore
         smith-prune
         smith-update
         smith-remove
         smith-enable
         smith-disable
         smith-load
         smith-load-all
         smith-list)
