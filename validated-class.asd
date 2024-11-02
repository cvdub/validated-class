(defsystem "validated-class"
  :version "0.0.1"
  :author "cvdub"
  :license ""
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "CLOS metaclass supporting class and slot validation"
  :in-order-to ((test-op (test-op "validated-class/tests"))))

(defsystem "validated-class/tests"
  :author "cvdub"
  :license ""
  :depends-on ("validated-class"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for validated-class"
  :perform (test-op (op c) (symbol-call :rove :run c)))
