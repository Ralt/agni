(in-package #:agni)


(cffi:defcstruct (stat :size 144)
  (st_mode :unsigned-int :offset 24)
  (st_uid :unsigned-int :offset 28)
  (st_gid :unsigned-int :offset 32)
  (st_size :unsigned-long :offset 48)
  (st_mtime :unsigned-long :offset 88)
  (st_ctime :unsigned-long :offset 104))

(cffi:defcfun "stat" :int
  (path :string)
  (buf (:pointer (:struct stat))))

(defun file-stat (path)
  (cffi:with-foreign-object (buf '(:struct stat))
    (stat path buf)
    (cffi:with-foreign-slots ((st_mode st_uid st_gid st_size st_mtime st_ctime)
                              buf
                              (:struct stat))
      (values st_mode st_uid st_gid st_size st_mtime st_ctime))))
