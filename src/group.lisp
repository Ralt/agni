(in-package #:agni)


(cffi:defctype gid_t :unsigned-int)

(cffi:defcstruct (group :size 32)
  (gr_name :string :offset 0))

(cffi:defcfun "getgrgid" (:pointer (:struct group))
  (gid gid_t))

(defun groupname-from-gid (gid)
  (cffi:with-foreign-slots ((gr_name) (getgrgid gid) (:struct group))
    gr_name))
