class Msolve < Formula
  desc "Library for solving multivariate polynomial systems"
  homepage "https://msolve.lip6.fr"
  url "https://gitlab.lip6.fr/safey/msolve.git", tag: "v0.2.4", revision: "09f64db29d1f79dad41e5615f466686c8c5154d0"
  license "GPL-2.0-or-later"
  revision 1

  head "https://gitlab.lip6.fr/safey/msolve.git"

  bottle do
    root_url "https://github.com/Macaulay2/homebrew-tap/releases/download/msolve-0.2.4_1"
    sha256 cellar: :any,                 big_sur:      "d6f89d90bc35401bd9d3218e9b744755699c0931ec73e0aa0c277dd8706d8487"
    sha256 cellar: :any,                 catalina:     "4bb4486e03e729fa0c7c997178dbad8f80b49d5d43d14f97dcf4fe5b84dcf366"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "f9457aa1f3c148c781966eb75c398dd4c2794af5e5a044acef9f9be14a0a636b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  depends_on "flint"
  depends_on "gmp"
  depends_on "libomp" if OS.mac?
  depends_on "mpfr"

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV["OPENMP_CFLAGS"] = "-Xpreprocessor -fopenmp -I#{libomp.opt_include} #{libomp.opt_lib}/libomp.dylib"
    end

    system "autoreconf", "-vif"
    system "./configure",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--enable-openmp=yes",
           "--prefix=#{prefix}",
           "--libdir=#{lib}",
           "CC=#{ENV.cc} #{ENV["OPENMP_CFLAGS"]}"
    system "make", "install"
  end

  test do
    (testpath/"eco10-31.ms").write <<-EOS
      x0,x1,x2,x3,x4,x5,x6,x7,x8,x9
      1073741827
      x0*x1*x9+x1*x2*x9+x2*x3*x9+x3*x4*x9+x4*x5*x9+x5*x6*x9+x6*x7*x9+x7*x8*x9+x0*x9-1,
      x0*x2*x9+x1*x3*x9+x2*x4*x9+x3*x5*x9+x4*x6*x9+x5*x7*x9+x6*x8*x9+x1*x9-2,
      x0*x3*x9+x1*x4*x9+x2*x5*x9+x3*x6*x9+x4*x7*x9+x5*x8*x9+x2*x9-3,
      x0*x4*x9+x1*x5*x9+x2*x6*x9+x3*x7*x9+x4*x8*x9+x3*x9-4,
      x0*x5*x9+x1*x6*x9+x2*x7*x9+x3*x8*x9+x4*x9-5,
      x0*x6*x9+x1*x7*x9+x2*x8*x9+x5*x9-6,
      x0*x7*x9+x1*x8*x9+x6*x9-7,
      x0*x8*x9+x7*x9-8,
      x8*x9-9,
      x0+x1+x2+x3+x4+x5+x6+x7+x8+1
    EOS
    system "msolve", "-f", "eco10-31.ms"
  end
end
