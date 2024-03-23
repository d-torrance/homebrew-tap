class Macaulay2Common < Formula
  desc "Software system for algebraic geometry research"
  homepage "http://macaulay2.com"
  url "https://github.com/Macaulay2/M2-emacs.git", using: :git, revision: "e29832126afb0b153505f69eb942b0f509ac8f41"
  version "1.23"
  license any_of: ["GPL-2.0-only", "GPL-3.0-only"]

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/macaulay2-common-1.22"
    sha256 cellar: :any_skip_relocation, big_sur:      "07cf937af6de9653a7337a4c58c94aff8f390f5cd60231ef39b7e91b3ba05549"
    sha256 cellar: :any_skip_relocation, monterey:     "2bc6d3176a0d741ad5a0cb521b62491842f36f2050fb9e41879ad90235ec3908"
    sha256 cellar: :any_skip_relocation, ventura:      "8b8e5372d7b2d71ebb7e928f568e5110b8e8abbf8717d6e5de4013b5011e1f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3f297ee3114e0a08ef37bc247f1a19bab1d2a42c4392700fc7bf99701afcd4fd"
  end

  keg_only "it only installs documentation for macaulay2/tap/M2"

  resource "v1.23" do
    url "https://pkg-containers.githubusercontent.com/ghcr1/blobs/sha256:2de324956110d5c1dea1a6693fa9dfe22e45d5900093b5086983afb0468470ef?se=2024-03-23T06%3A30%3A00Z&sig=suoFPeqHEoPgFcxnfOs66fjA0o2afXGf4BNC%2Fjg%2Buls%3D&sp=r&spr=https&sr=b&sv=2019-12-12"
    sha256 "2de324956110d5c1dea1a6693fa9dfe22e45d5900093b5086983afb0468470ef"
  end

  def install
    resource("v1.23").stage buildpath
    # nothing from the M2-emacs repository is actually used,
    # but brew requires at least one url, so I gave it one.
    mv buildpath/"1.23/share", prefix
    mv buildpath/"1.23/lib",   prefix
    rm_rf share/"emacs"
  end

  def post_install
    if Formula["macaulay2"].any_version_installed?
      cp_r share, Formula["macaulay2"].prefix, remove_destination: true
      cp_r lib,   Formula["macaulay2"].prefix, remove_destination: true
    else
      missing_warn = <<~EOS
        No version of Macaulay2 was found; run:
          brew install macaulay2 --HEAD
        to build Macaulay2 from source, then add the common documentation files with:
          brew postinstall macaulay2-common
      EOS
      opoo missing_warn
    end
  end

  test do
    system "true"
  end
end
