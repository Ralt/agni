(in-package #:agni)


(defun archive (path-to-archive archive-path &optional (since 0))
  "Archives all the files and folders"
  (let ((files (get-files path-to-archive since)))
    (write-archive archive-path files)))

(defun write-archive (path files)
  "Writes an archive with all the files"
  )
