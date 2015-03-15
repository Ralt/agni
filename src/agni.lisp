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

;;;; Taken from ironclad. Not loading the whole library
;;;; just for this function...
(defun integer-to-octets (bignum &key (n-bits (integer-length bignum))
                                (big-endian t))
  (let* ((n-bytes (ceiling n-bits 8))
         (octet-vec (make-array n-bytes :element-type '(unsigned-byte 8))))
    (declare (type (simple-array (unsigned-byte 8) (*)) octet-vec))
    (if big-endian
        (loop for i from (1- n-bytes) downto 0
              for index from 0
              do (setf (aref octet-vec index) (ldb (byte 8 (* i 8)) bignum))
              finally (return octet-vec))
        (loop for i from 0 below n-bytes
              for byte from 0 by 8
              do (setf (aref octet-vec i) (ldb (byte 8 byte) bignum))
              finally (return octet-vec)))))
