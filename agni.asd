(asdf:defsystem #:agni
  :description "Restore solution. Alternatively, backup solution too."
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:cffi :cl-fad)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "stat")
                         (:file "passwd")
                         (:file "group")
                         (:file "file")
                         (:file "tar-bytes")
                         (:file "archive")
                         (:file "agni")))))
