(in-package #:agni)


(defclass file ()
  ((path
    :initarg :path
    :reader path)
   (tar-path
    :initarg :tar-path
    :reader tar-path)
   (mode
    :initarg :mode
    :reader mode)
   (uid
    :initarg :uid
    :reader uid)
   (gid
    :initarg :gid
    :reader gid)
   (mtime
    :initarg :mtime
    :reader mtime)
   (tar-byte-headers
    ;; headers must be 500 bytes
    :initform (make-array 500 :element-type '(unsigned-byte 8))
    :accessor tar-byte-headers)))

(defmethod file-tar-bytes ((f file) &key)
  (tar-bytes-name f)
  (tar-bytes-mode f)
  (tar-bytes-uid f)
  (tar-bytes-gid f)
  (tar-bytes-size f)
  (tar-bytes-mtime f)
  (tar-bytes-chksum f)
  (tar-bytes-typeflag f)
  (tar-bytes-linkname f)
  (tar-bytes-magic f)
  (tar-bytes-version f)
  (tar-bytes-uname f)
  (tar-bytes-gname f)
  (tar-bytes-devmajor f)
  (tar-bytes-devminor f)
  (tar-bytes-prefix f)
  (tar-bytes-content f)
  (tar-bytes-calculate-checksum f)
  (concatenate '(vector (unsigned-byte 8))
               (tar-byte-headers f)
               (tar-bytes-content f)))

(defun get-files (path since)
  "Gets the files"
  (let ((pathnames nil)
        (path-length (length (namestring (truename path)))))
    (fad:walk-directory
     path
     #'(lambda (pathname)
         (let ((path-string (namestring pathname)))
           (multiple-value-bind (mode uid gid mtime ctime)
               (file-stat path-string)
             (when (> ctime since)
               (push (make-instance 'file
                                    :path path-string
                                    :tar-path (subseq path-string path-length)
                                    :mode mode
                                    :uid uid
                                    :gid gid
                                    :mtime mtime)
                     pathnames))))))
    pathnames))
