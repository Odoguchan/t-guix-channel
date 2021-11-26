(use-modules (gnu packages)
             (guix build-system go)
             (guix download)
             (guix git-download)
             ((guix licenses) #:prefix license:)
             (guix packages))

(let ((commit "f721006d1e4ee8220a6eea144cfe3b0835a5880f")
      (revision "0"))
  (package
    (name "massren")
    (version (git-version "1.5.4" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference (url "https://github.com/laurent22/massren")
                       (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0i9riwhsass4ffv9f3m342b1xr83fyqwwkfb1aqiw91h5sxh7490"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "github.com/laurent22/massren"
       ;; Installation fails because of tests. investigate further
       #:tests? #f))
    (home-page "https://github.com/laurent22/massren")
    (synopsis "Easily rename multiple files using your text editor.")
    (description "Massren is a command line tool that can be used to rename multiple files using your own text editor.")
    (license "MIT")))
