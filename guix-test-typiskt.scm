(use-modules (guix build-system gnu)
             (gnu packages m4)
             (gnu packages curl)
             (gnu packages ncurses)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix packages))


(let ((commit "8995b4aff08e7decb228696febc4ae8aa51b027f")
      (revision "0"))

  (package
   (name "typiskt")
   (version "2020.07.10.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/budlabs/typiskt")
           (commit commit)))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0cyvyc8l5yj8jlvkv8ya3b7qq93wsrhk86wbh4k0k3wv2krpgfnv"))))

   (build-system gnu-build-system)

   (arguments
    `(#:tests? #f
      #:make-flags
      (list (string-append "PREFIX=" %output)
            (string-append "ASSETDIR=" %output "/etc/typiskt"))
      #:phases
      (modify-phases %standard-phases
                     (delete 'configure)
                     (delete 'build))))

   (inputs
    `(("m4" ,m4)))

   (native-inputs
    `(("curl" ,curl)))

   (home-page "https://github.com/budlabs/typiskt")
   (synopsis "Touchtype training for dirty hackers")
   (description
    "Terminal based touchtype training program written in bash.")
   (license license:bsd-2)))
