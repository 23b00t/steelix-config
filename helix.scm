;;; helix.scm – everything provided here becomes a typable :command.
;;; Exposes the smith.hx management commands (:smith-list, :smith-update, ...)
;;; and :update-named (used by the esc bindings in config.toml).

(require "helix/editor.scm")
(require (prefix-in helix. "helix/commands.scm"))

(require (only-in "smith.hx/smith.scm"
                  smith-install
                  smith-init
                  smith-self-update
                  smith-ensure
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

;;@doc
;;Like :update, but skips buffers without a path (scratch, *smith-list*),
;;where :update fails with "Can't save with no path set".
(define (update-named)
  (when (editor-document->path (editor->doc-id (editor-focus)))
    (helix.update)))

(provide update-named)
