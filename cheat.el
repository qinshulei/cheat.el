;; cheat.el (for python cheat)
;; Time-stamp: <2014-12-05 14:22:02>
;;
;; Modified by : qinshulei <527072230@qq.com>
;; Based on : https://github.com/defunkt/cheat.el (for ruby cheat)
;; Copyright (c) 2007 Sami Samhuri <sami.samhuri@gmail.com>
;;
;; License
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 2
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
;;
;;
;; Provide a handy interface to cheat (python).
;; See https://github.com/chrisallenlane/cheat for details on cheat itself.
;;
;;
;;
(defvar *cheat-directory* "~/.cheat/")

(defvar *cheat-last-sheet* nil
  "Name of the most recently viewed cheat sheet.")

(defvar *cheat-sheet-history* nil
  "List of the most recently viewed cheat sheets.")

;;; helpers
;; this is from rails-lib.el in the emacs-rails package
(defun cheat-string-join (separator strings)
  "Join all STRINGS using SEPARATOR."
  (mapconcat 'identity strings separator))

(defun cheat-blank (thing)
  "Return T if THING is nil or an empty string, otherwise nil."
  (or (null thing)
      (and (stringp thing)
           (= 0 (length thing)))))

(defun cheat-command (&rest rest)
  "Run the cheat command with the given arguments, display the output."
  (interactive "sArguments for cheat: \n")
  (let* ((cmd (cheat-string-join " " rest))
         (buffer (get-buffer-create
                  (concat "*Cheat: " cmd "*"))))
    (switch-to-buffer buffer)
    (shell-command (concat "cheat " cmd) buffer)))

(defun cheat-command-to-string (&rest rest)
  "Run the cheat command with the given arguments and return the output as a
  string.  Display nothing."
  (shell-command-to-string (concat "cheat " (cheat-string-join " " rest))))

(defalias 'cheat-command-silent 'cheat-command-to-string)

(defun cheat-read-list-name (&optional prompt)
  "Get the name of an existing cheat sheet, prompting with completion and
  history.

The name of the sheet read is stored in *cheat-last-sheet* unless it was cheat-blank."
  (let* ((default (when (cheat-blank prompt) *cheat-last-sheet*))
         (prompt (or prompt
                     (if (not (cheat-blank default))
                         (concat "Cheat name (default: " default "): ")
                       "Cheat name: ")))
         (name (completing-read prompt
                                (cheat-fetch-list)
                                nil
                                t
                                nil
                                '*cheat-sheet-history*
                                default)))
    (when (not (cheat-blank name))
      (setq *cheat-last-sheet* name))
    name))

(defun cheat-fetch-list ()
  "Fetch a fresh list of all cheat sheets."
  (mapcar (lambda (x) (car (split-string x)))
          (split-string  (cheat-command-to-string "--list") "\n")))


(defun cheat-buffer->cheat (name)
  (substring name 7 (- (length name) 1)))

(defun cheat-cheat->buffer (name)
  (concat "*cheat-" name "*"))

;;; interactive functions

;;;###autoload
(defun cheat (name &optional silent)
  "Show the specified cheat sheet.

If SILENT is non-nil then do not print any output, but return it
as a string instead."
  (interactive (list (cheat-read-list-name)))
  (if silent
      (cheat-command-silent name)
    (cheat-command name)))

(defun cheat-directories ()
  "List directories on CHEATPATH."
  (interactive)
  (cheat-command "--directories"))

(defun cheat-edit (name)
  "Fetch the named cheat and open a buffer containing its body.
The cheat can be saved with `cheat-save-current-buffer'."
  (interactive (list (cheat-read-list-name)))
  (switch-to-buffer (get-buffer-create (cheat-cheat->buffer name)))
  (insert-file-contents (concat *cheat-directory* name))
  (if (interactive-p)
      (print "Run `cheat-save-current-buffer' when you're done editing.")))

(defun cheat-list ()
  "List all cheat sheets."
  (interactive)
  (cheat-command "--list"))

(defun cheat-search (keyword)
  "Search cheatsheets for <keyword>"
  (interactive (list (cheat-read-list-name)))
  (cheat-command "--search" keyword))

(defun cheat-version ()
  "Print the version number"
  (interactive)
  (cheat-command "--version"))

(defun cheat-add-current-buffer (name)
  "Add a new cheat with the specified name and the current buffer as the body."
  (interactive "sCheat name: \n")
  (write-region (point-min)
                (point-max)
                (concat *cheat-directory* name))
  (if (interactive-p)
      (print (concat "Cheat added (" name ")"))))

(defun cheat-save-current-buffer ()
  "Save the current buffer using the buffer name for the title and the contents
  as the body."
  (interactive)
  (let ((name (cheat-buffer->cheat (buffer-name (current-buffer)))))
    (write-region (point-min)
                  (point-max)
                  (concat *cheat-directory* name))
    ;; TODO check for errors and kill the buffer on success
    (if (interactive-p)
        (print (concat "Cheat saved (" name ")")))
    (cheat name)))

(provide 'cheat)
;;;cheat.el ends here
