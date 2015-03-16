(in-package #:agni)


(defconstant +name-offset+ 0)
(defconstant +mode-offset+ 100)
(defconstant +uid-offset+ 108)
(defconstant +gid-offset+ 116)
(defconstant +size-offset+ 124)
(defconstant +mtime-offset+ 136)
(defconstant +chksum-offset+ 148)
(defconstant +typeflag-offset+ 156)
(defconstant +linkname-offset+ 157)
(defconstant +magic-offset+ 257)
(defconstant +version-offset+ 263)
(defconstant +uname-offset+ 265)
(defconstant +gname-offset+ 297)
(defconstant +devmajor-offset+ 329)
(defconstant +devminor-offset+ 337)
(defconstant +prefix-offset+ 345)
(defconstant +content-offset+ 512)

(defmethod tar-bytes-name ((f file) &key)
  "100 bytes"
  (vector-add (concatenate '(vector (unsigned-byte 8))
                           (string-to-bytes (tar-path f))
                           #(#\0))
              (tar-bytes-headers f) +name-offset+))

(defmethod tar-bytes-mode ((f file) &key)
  "8 bytes"
  (vector-add-integer f (mode f) +mode-offset+))

(defmethod tar-bytes-uid ((f file) &key)
  "8 bytes"
  (vector-add-integer f (uid f) +uid-offset+))

(defmethod tar-bytes-gid ((f file) &key)
  "8 bytes"
  (vector-add-integer f (gid f) +gid-offset+))

(defmethod tar-bytes-size ((f file) stream &key)
  "12 bytes"
  (vector-add-integer f (file-length stream) +size-offset+))

(defmethod tar-bytes-mtime ((f file) &key)
  "12 bytes"
  (vector-add-integer f (mtime f) +mtime-offset+))

(defmethod tar-bytes-chksum ((f file) &key)
  "8 bytes"
  (vector-add (string-to-bytes "        ")
              (tar-bytes-headers f)
              +chksum-offset+))

(defmethod tar-bytes-typeflag ((f file) &key)
  "1 byte
Only support regular files for now"
  (vector-add #(0) (tar-bytes-headers f) +typeflag-offset+))

(defmethod tar-bytes-linkname ((f file) &key)
  "100 bytes
Regular files only for now, so nothing")

(defmethod tar-bytes-magic ((f file) &key)
  "6 bytes"
  (vector-add (string-to-bytes "ustar")
              (tar-bytes-headers f)
              +magic-offset+))

(defmethod tar-bytes-version ((f file) &key)
  "2 bytes"
  (vector-add (string-to-bytes "00")
              (tar-bytes-headers f)
              +version-offset+))

(defmethod tar-bytes-uname ((f file) &key)
  "32 bytes"
  (vector-add (concatenate '(vector (unsigned-byte 8))
                           (string-to-bytes (username-from-uid (uid f)))
                           #(\0))
              (tar-bytes-headers f)
              +uname-offset+))

(defmethod tar-bytes-gname ((f file) &key)
  "32 bytes"
  (vector-add (concatenate '(vector (unsigned-byte 8))
                           (string-to-bytes (groupname-from-gid (gid f)))
                           #(\0))
              (tar-bytes-headers f)
              +gname-offset+))

(defmethod tar-bytes-devmajor ((f file) &key)
  "8 bytes
Empty for now")

(defmethod tar-bytes-devminor ((f file) &key)
  "8 bytes
Empty for now")

(defmethod tar-bytes-prefix ((f file) &key)
  "155 bytes
Empty for now")

(defmethod tar-bytes-pad ((f file) &key)
  "12 bytes
Voluntarily keep it empty")

(defmethod tar-bytes-content ((f file) stream &key)
  (let ((bytes (make-array (file-length stream) :element-type '(unsigned-byte 8))))
    (read-sequence bytes stream)
    bytes))

(defmethod tar-bytes-calculate-checksum ((f file) &key)
  (vector-add (string-to-bytes (format nil "~6,'0o ~c"
                                       (calculate-checksum (tar-bytes-headers f))
                                       #\0))
              (tar-bytes-headers f)
              +chksum-offset+))

(defun calculate-checksum (headers)
  (reduce #'+ headers))
