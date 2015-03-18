(in-package #:agni)


(defun write-archive (path files)
  "Writes an archive with all the files"
  (with-open-file (s path
                     :direction :output
                     :element-type '(unsigned-byte 8)
                     :if-does-not-exist :create)
    (dolist (file files)
      (write-sequence (file-tar-bytes file) s))))
