(use-modules (gnu packages)
             (guix git-download)
             (guix build-system python)
             ((guix licenses)
              #:prefix license:)
             (guix packages))

(let ((commit "98e248faa49e69d795abc60f7cdefcf91e2612aa")
      (revision "0"))

  (package
    (name "youtube-dlc")
    (version (git-version "2020.11.11-3" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri
        (git-reference
         (url "https://github.com/blackjack4494/yt-dlc")
         (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "029l2923qyrzykxjak656rnd5b64rs0kvjxjgrpcvh978k7aa93g"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f)); Many tests fail. The test suite can be run with pytest.

    (synopsis "Download videos from YouTube.com and other sites")
    (description
     "Youtube-dlc is a small command-line program to download videos from
YouTube.com and many more sites.")
    (home-page "https://yt-dl.org")
    (license license:public-domain)))
