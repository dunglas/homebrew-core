class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Nov2019/MonetDB-11.35.3.tar.xz"
  sha256 "54715eb6e33e1c9464c700cb30e143e00e549c344f410e1e424bbc61fea587cc"

  bottle do
    sha256 "d7c68c13677815c9c79c538ae8f949b1a9df4c6117ee988aa90b3f4e6131252b" => :catalina
    sha256 "307ea27d439b837179a8e6dedf8d648fd95627f43c52996cea75586a87271a41" => :mojave
    sha256 "9c4ae1d233e6cd181643ba0b6614cd0c5bebf6331d7a9dfaab9f4f544b0d9d83" => :high_sierra
    sha256 "ecfc1cc0b8e196a35ff77236333ccc7d21a5ec04d6ff419c7aafe0291302b622" => :sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
  end
end
