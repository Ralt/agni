(in-package #:agni)


(defun write-archive (path files)
  "Writes an archive with all the files"
  (when (probe-file path)
    (format t "File ~A already exists.~%" (namestring path))
    (uiop:quit -1))
  (with-open-file (s path
                     :direction :output
                     :element-type '(unsigned-byte 8)
                     :if-does-not-exist :create)
    (dolist (file files)
      (write-sequence (archive-bytes file) s))))

(defun archive-bytes (file)
  "Returns the bytes to write in an archive for a file"
  (concatenate '(vector (unsigned-byte 8))
               (tar-bytes-name file)
               (tar-bytes-mode file)
               (tar-bytes-uid file)
               (tar-bytes-gid file)
               (tar-bytes-size file)
               (tar-bytes-mtime file)
               (tar-bytes-chksum file)
               (tar-bytes-typeflag file)
               (tar-bytes-linkname file)
               (tar-bytes-magic file)
               (tar-bytes-version file)
               (tar-bytes-uname file)
               (tar-bytes-gname file)
               (tar-bytes-devmajor file)
               (tar-bytes-devminor file)
               (tar-bytes-prefix file)
               (tar-bytes-content file)))
