
class Picrust < Formula
  desc "PICRUSt: Phylogenetic Investigation of Communities by Reconstruction of Unobserved States"
  homepage "http://picrust.github.io/"
  # Download the devel version of picrust before changes were made to port to biom 2.x
  url "https://github.com/picrust/picrust/archive/ab009a35bd9a5c96140d48d673948cc1fcc872d6.zip"
  version "1.0.0-dev"
  sha256 "63e80d380296396eae7e6f39d67df438e14a8300c4016926edf7c211c77bae73"

  resource "16S_13_5" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/16S_13_5_precalculated.tab.gz"
    sha256 "ae9c25bda0bdc52db054f311e765daa1bcfc33b35261cc57b379938ef9feff3f"
  end

  resource "ko_13_5" do
    url "ftp://ftp.microbio.me/pub/picrust-references/picrust-1.0.0/ko_13_5_precalculated.tab.gz"
    sha256 "26371c9eaf8decdfea0a6b2ae887a13789b762dc15da60629f5efda564750ce6"
  end

  def install
    # set PYTHONPATH to location where package will be installed (relative to homebrew location)
    ENV.prepend 'PYTHONPATH', libexec/"lib/python2.7/site-packages", ':'
    # run python setup.py install using recommended homebrew helper method with destination prefix of libexec
    system "python", *Language::Python.setup_install_args(libexec)
    # copy all of the installed scripts to the homebrew bin
    bin.install Dir[libexec/"bin/*"]
    # write stubs to bin that set PYTHONPATH and call executables, move executables back to original location
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
   
    # create the data folder
    system "mkdir", libexec/"lib/python2.7/site-packages/picrust/data"
 
    # stage downloaded resource in temp directory and install in picrust data folder
    libexec.install resource("16S_13_5")
    system "mv", libexec/"16S_13_5_precalculated.tab", libexec/"lib/python2.7/site-packages/picrust/data/16S_13_5_precalculated.tab"
    libexec.install resource("ko_13_5")
    system "mv", libexec/"ko_13_5_precalculated.tab", libexec/"lib/python2.7/site-packages/picrust/data/ko_13_5_precalculated.tab"
  end

  test do
    system "#{bin}/predict_metagenomes.py", "--help"
  end
end
