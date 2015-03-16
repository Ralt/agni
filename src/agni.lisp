(in-package #:agni)


(defun archive (path-to-archive archive-path &optional (since 0))
  "Archives all the files and folders"
  (let ((files (get-files path-to-archive since)))
    (write-archive archive-path files)))

(defun vector-add (elements vector start)
  "Adds all the elements in vector, starting at specified index"
  (let ((index start))
    (loop
       :for element in elements
       :do (setf (elt vector index) element)
       :do (incf index))))

(defun string-to-bytes (string)
  (loop
     :for char across string
     :collect (char-code char)))
