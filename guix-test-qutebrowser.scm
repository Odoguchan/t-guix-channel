(use-modules (gnu packages)
             (gnu packages python-web)
             (gnu packages python)
             (gnu packages python-xyz)
             (gnu packages qt)
             (gnu packages sqlite)
             (gnu packages webkit)

             (gnu packages tls)
             (guix build-system python)
             (guix download)
             (guix git-download)

             ;; (gnu packages font-mplus-testflight)
             (gnu packages fonts)

             ((guix licenses) #:prefix license:)
             (guix packages)

             (guix download)
             (guix git-download)
             (guix build-system python)
             (guix utils)
             (gnu packages)
             (gnu packages base)
             (gnu packages check)
             (gnu packages compression)
             (gnu packages curl)
             (gnu packages databases)
             (gnu packages django)
             (gnu packages groff)
             (gnu packages libffi)
             (gnu packages pkg-config)
             (gnu packages python)
             (gnu packages python-check)
             (gnu packages python-crypto)
             (gnu packages python-xyz)
             (gnu packages serialization)
             (gnu packages sphinx)
             (gnu packages texinfo)
             (gnu packages tls)
             (gnu packages time)
             (gnu packages web)
             (gnu packages xml)
             ((guix licenses) #:prefix license:)

             (srfi srfi-1))

(package
 (name "qutebrowser")
 (version "2.3.1")
 (source
  (origin
   (method url-fetch)
   (uri (string-append "https://github.com/qutebrowser/"
                       "qutebrowser/releases/download/v" version "/"
                       "qutebrowser-" version ".tar.gz"))
   (sha256
    ;; (base32 "0fxkazz4ykmkiww27l92yr96hq00qn5vvjmknxcy4cl97d2pxa28"))))
    ;; (base32 "1kj2hcr1avn9iwwvzrg3mp30lifhdlx1bgavisbi32a9gnnh06xp"))))
    (base32 "05n64mw9lzzxpxr7lhakbkm9ir3x8p0rwk6vbbg01aqg5iaanyj0"))))

 (build-system python-build-system)
 (inputs
  `(("python-colorama" ,python-colorama)
    ("python-jinja2" ,python-jinja2)
    ("python-markupsafe" ,python-markupsafe)
    ("python-pygments" ,python-pygments)
    ("python-pyyaml" ,python-pyyaml)
    ;; FIXME: python-pyqtwebengine needs to come before python-pyqt so
    ;; that it's __init__.py is used first.
    ("python-pyqtwebengine" ,python-pyqtwebengine)
    ("python-pyqt" ,python-pyqt)
    ;; new dependency  for python 3.6, 3.7 or 3.8
    ("python-importlib-resources" ,python-importlib-resources)
    ;; While qtwebengine is provided by python-pyqtwebengine, it's
    ;; included here so we can wrap QTWEBENGINEPROCESS_PATH.
    ("qtwebengine" ,qtwebengine)
    ;; ("font-google-noto" ,font-google-noto)
    ("font-mplus-testflight" ,font-mplus-testflight)
    ))
 (arguments
  `(;; FIXME: With the existance of qtwebengine, tests can now run.  But
    ;; they are still disabled because test phase hangs.  It's not readily
    ;; apparent as to why.
    #:tests? #f
             #:phases
             (modify-phases %standard-phases
                            (add-before 'check 'set-env-offscreen
                                        (lambda _
                                          (setenv "QT_QPA_PLATFORM" "offscreen")
                                          #t))
                            (add-after 'install 'install-more
                                       (lambda* (#:key outputs #:allow-other-keys)
                                         (let* ((out (assoc-ref outputs "out"))
                                                (app (string-append out "/share/applications"))
                                                (hicolor (string-append out "/share/icons/hicolor")))
                                           (install-file "doc/qutebrowser.1"
                                                         (string-append out "/share/man/man1"))
                                           (for-each
                                            (lambda (i)
                                              (let ((src  (format #f "icons/qutebrowser-~dx~d.png" i i))
                                                    (dest (format #f "~a/~dx~d/apps/qutebrowser.png"
                                                                  hicolor i i)))
                                                (mkdir-p (dirname dest))
                                                (copy-file src dest)))
                                            '(16 24 32 48 64 128 256 512))
                                           (install-file "icons/qutebrowser.svg"
                                                         (string-append hicolor "/scalable/apps"))
                                           (substitute* "misc/org.qutebrowser.qutebrowser.desktop"
                                                        (("Exec=qutebrowser")
                                                         (string-append "Exec=" out "/bin/qutebrowser")))
                                           (install-file "misc/org.qutebrowser.qutebrowser.desktop" app)
                                           #t)))
                            (add-after 'wrap 'wrap-qt-process-path
                                       (lambda* (#:key inputs outputs #:allow-other-keys)
                                         (let* ((out (assoc-ref outputs "out"))
                                                (bin (string-append out "/bin/qutebrowser"))
                                                (qt-process-path (string-append
                                                                  (assoc-ref inputs "qtwebengine")
                                                                  "/lib/qt5/libexec/QtWebEngineProcess")))
                                           (wrap-program bin
                                                         `("QTWEBENGINEPROCESS_PATH" ":" prefix (,qt-process-path)))
                                           #t))))))
 (home-page "https://qutebrowser.org/")
 (synopsis "Minimal, keyboard-focused, vim-like web browser")
 (description "qutebrowser is a keyboard-focused browser with a minimal
GUI.  It is based on PyQt5 and QtWebEngine.")
 (license license:gpl3+))
