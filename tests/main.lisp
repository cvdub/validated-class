(defpackage validated-class/tests/main
  (:use :cl :validated-class :rove))

(in-package :validated-class/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :validated-class)' in your Lisp.

(defun less-than-5? (value)
  (< (length value) 5))

(defclass test-class ()
  ((foo :initarg :foo
        :accessor foo
        :type string
        :validators (stringp less-than-5?))
   (bar :initarg :bar
        :accessor bar))
  (:metaclass validated-class))

(deftest test-validated-class
  (testing "creating object"
    (ok (make-instance 'test-class :foo "foo" :bar 123))
    (ok (signals (make-instance 'test-class :foo 1/2 :bar 123)))
    (ok (signals (make-instance 'test-class :foo "12345" :bar 123))))
  (testing "setting object slots"
    (let ((obj (make-instance 'test-class :foo "foo" :bar 123)))
      (ok (setf (foo obj) "1234"))
      (ok (signals (setf (foo obj) 1234)))
      (ok (signals (setf (foo obj) "12345")))
      (ok (setf (bar obj) 1234)))))
