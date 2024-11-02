(defpackage validated-class/tests/main
  (:use :cl
        :validated-class
        :rove))
(in-package :validated-class/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :validated-class)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
