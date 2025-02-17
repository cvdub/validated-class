(uiop:define-package validated-class
  (:use #:cl)
  (:export :validated-class :validation-error))
(in-package #:validated-class)

(define-condition validation-error (error)
  ((validator :initarg :validator
              :initform (error "validator is required")
              :accessor validator)
   (slot-name :initarg :slot-name
              :initform (error "slot-name is required")
              :accessor slot-name)
   (value :initarg :value
          :initform (error "value is required")))
  (:report (lambda (condition stream)
             (with-slots (validator slot-name value) condition
               (format stream "~a failed when setting ~a to ~a"
                       validator slot-name value)))))

(defclass validated-slot-definition ()
  ((validators :initarg :validators :accessor validators :initform nil)))

(defclass validated-class-standard-direct-slot-definition
    (validated-slot-definition c2mop:standard-direct-slot-definition)
  ())

(defclass validated-class-standard-effective-slot-definition
    (validated-slot-definition c2mop:standard-effective-slot-definition)
  ())

(defclass validated-class (standard-class)
  ())

(defmethod c2mop:validate-superclass
    ((class validated-class) (superclass standard-class))
  t)

(defmethod c2mop:direct-slot-definition-class ((class validated-class) &rest initargs)
  (declare (ignore initargs))
  (find-class 'validated-class-standard-direct-slot-definition))

(defmethod c2mop:effective-slot-definition-class ((class validated-class) &rest initargs)
  (declare (ignore initargs))
  (find-class 'validated-class-standard-effective-slot-definition))

(defmethod c2mop:compute-effective-slot-definition
    ((class validated-class) slot-name direct-slot-definitions)
  (let ((effective-slot-definition (call-next-method)))
    (setf (validators effective-slot-definition)
          (some #'validators direct-slot-definitions))
    effective-slot-definition))

(defmethod (setf c2mop:slot-value-using-class) :before
    (new-value (class validated-class) instance slot)
  (dolist (validator (validators slot))
    (unless (ignore-errors (funcall validator new-value))
      (error 'validation-error :validator validator
                               :slot-name (c2mop:slot-definition-name slot)
                               :value new-value))))
