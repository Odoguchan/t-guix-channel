(use-modules (gnu packages)
             (guix build-system gnu)
             (gnu packages autotools)
             (gnu packages gcc)
             (gnu packages glib)
             (gnu packages c)
             (gnu packages pkg-config)
             (gnu packages xorg)
             (gnu packages fontutils)
             (gnu packages ncurses)
             (guix utils)
             (guix git-download)
             (guix download)
             ((guix licenses) #:prefix license:)
             (guix packages))


(let ((commit "76fb0b1fa5fbfd2bbe7e416d55eeb8668b9500c0")
      (revision "0"))

  (package
   (name "st")
   (version "0.8.4")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/Odoguchan/st")
           (commit commit)))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1rp7q4nqyp9ddir1kr0iz9zgyi7yxr9hzvxm66ggxhnh95hsr3ws"))))

   (build-system gnu-build-system)

   (arguments
    `(#:tests? #f ; no tests
      #:make-flags
      (list (string-append "CC=" ,(cc-for-target))
            (string-append "PREFIX=" %output))
      #:phases
      (modify-phases %standard-phases
                     (delete 'configure)

                     (add-after 'unpack 'inhibit-terminfo-install
                                (lambda _ (substitute* "Makefile" (("\ttic .*") ""))
                                   #t))

                     (add-after 'install 'install-more
                                (lambda* (#:key outputs #:allow-other-keys)
                                  (let* ((out (assoc-ref outputs "out"))
                                         (app (string-append out "/share/applications"))
                                         (hicolor (string-append out "/share/icons/hicolor")))

                                    (install-file "st.svg" hicolor)

                                    (substitute* "st.desktop"
                                                 (("Exec=st")
                                                  (string-append "Exec=" out "/bin/st"))
                                                 )
                                    ;; (install-file "st.desktop" app))
                                  )#t
                                    )))
                     ))


   (inputs
    `(("libx11" ,libx11)
      ("libxft" ,libxft)
      ("fontconfig" ,fontconfig)
      ("freetype" ,freetype)))

   (native-inputs
    `(("pkg-config" ,pkg-config)))

   (home-page "https://st.suckless.org/")
   (synopsis "Simple terminal emulator")
   (description
    "St implements a simple and lightweight terminal emulator.")
   (license license:x11)))
