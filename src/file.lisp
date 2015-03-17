(in-package #:agni)


(defconstant +block-size+ 512)

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
   (size
    :initarg :size
    :reader size)
   (mtime
    :initarg :mtime
    :reader mtime)
   (tar-bytes-headers
    :initform (make-array +block-size+ :element-type '(unsigned-byte 8))
    :accessor tar-bytes-headers)))

(defmethod file-tar-bytes ((f file) &key)
  (with-open-file (stream (path f) :element-type '(unsigned-byte 8))
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
    (tar-bytes-pad f)
    (tar-bytes-calculate-checksum f)
    (let* ((content (tar-bytes-content f stream)))
      (concatenate '(vector (unsigned-byte 8))
                   (tar-bytes-headers f)
                   content
                   ;; Pad with NUL bytes to end at +block-size+
                   (make-array (if (> +block-size+ (size f))
                                   (- +block-size+ (size f))
                                   (- +block-size+ (mod (size f) +block-size+)))
                               :element-type '(unsigned-byte 8))))))

(defmethod vector-add-integer ((f file) value constant &key)
  (vector-add (string-to-bytes (format nil "~7,'0o" value))
              (tar-bytes-headers f)
              constant))

(defun get-files (path since)
  "Gets the files"
  (let ((pathnames nil)
        (path-length (length (namestring (truename path)))))
    (fad:walk-directory
     path
     #'(lambda (pathname)
         (let ((path-string (namestring pathname)))
           (multiple-value-bind (mode uid gid size mtime ctime)
               (file-stat path-string)
             (when (> ctime since)
               (push (make-instance 'file
                                    :path path-string
                                    :tar-path (subseq path-string path-length)
                                    :mode mode
                                    :uid uid
                                    :gid gid
                                    :size size
                                    :mtime mtime)
                     pathnames))))))
    pathnames))
