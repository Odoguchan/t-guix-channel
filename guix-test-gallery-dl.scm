(use-modules (gnu packages)
             (gnu packages python-web)
             (guix build-system python)
             (guix download)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix packages))

(let ((commit "cb86bb9cc93b53963b4d2bb5dea4fbda6c8928de")
      (revision "0"))
  (package
   (name "gallery-dl")
   (version (git-version "1.17.2" revision commit))
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/mikf/gallery-dl")
           (commit commit)))
     (file-name (git-file-name name version))
     (sha256
      (base32 "1q5q62zsaf1jzlcb0jasivabrlyy2d0fjlvisycsrs6l7gr1kzmj"))))
   (build-system python-build-system)

   (arguments
    `(#:tests? #f))
   ;; (native-inputs
   ;;  `(("python-pytest" ,python-pytest)))
   (propagated-inputs
    `(("python-requests" ,python-requests)))


   (home-page "https://github.com/mikf/gallery-dl")
   (synopsis "Command-line program to download image galleries and collections from several image hosting sites.")
   (description "gallery-dl is a command-line program to download image galleries and collections from several image hosting sites (see Supported Sites). It is a cross-platform tool with many configuration options and powerful filenaming capabilities.")
   (license license:gpl2)))
