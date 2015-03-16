(in-package #:agni)


(cffi:defctype uid_t :unsigned-int)

(cffi:defcstruct (passwd :size 48)
  (pw_name :string :offset 0))

(cffi:defcfun "getpwuid" (:pointer (:struct passwd))
  (uid uid_t))

(defun username-from-uid (uid)
  (cffi:with-foreign-slots ((pw_name) (getpwuid uid) (:struct passwd))
    pw_name))
