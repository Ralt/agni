(asdf:defsystem #:agni
  :description "Restore solution. Alternatively, backup solution too."
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:cffi :cl-fad)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "agni")))))
