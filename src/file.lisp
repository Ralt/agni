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
    :reader mtime)))

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
