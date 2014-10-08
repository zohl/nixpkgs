{ stdenv, fetchurl, buildPythonPackage
, python, cython, pkgconfig
, xorg, gtk, glib, pango, cairo, gdk_pixbuf, pygtk, atk, pygobject, pycairo
, ffmpeg, x264, libvpx, pil, libwebp }:

buildPythonPackage rec {
  name = "xpra-0.14.8";
  namePrefix = "";

  src = fetchurl {
    url = "http://xpra.org/src/${name}.tar.bz2";
    sha256 = "13cy221i7yxmbw0a1h6r96l5has6dzmi3yqby9hdgfxq39lzm6mc";
  };

  buildInputs = [
    cython pkgconfig

    xorg.libX11 xorg.renderproto xorg.libXrender xorg.libXi xorg.inputproto xorg.kbproto
    xorg.randrproto xorg.damageproto xorg.compositeproto xorg.xextproto xorg.recordproto
    xorg.xproto xorg.fixesproto xorg.libXtst xorg.libXfixes xorg.libXcomposite xorg.libXdamage
    xorg.libXrandr xorg.libxkbfile

    pango cairo gdk_pixbuf atk gtk glib

    ffmpeg libvpx x264 libwebp
  ];

  propagatedBuildInputs = [
    pil pygtk pygobject
  ];

  # Even after i tried monkey patching, their tests just fail, looks like
  # they don't have automated testing out of the box? http://xpra.org/trac/ticket/177
  doCheck = false;

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0) $(pkg-config --cflags pygtk-2.0) $(pkg-config --cflags xtst)"
  '';
  setupPyBuildFlags = ["--with-Xdummy"];

  preInstall = ''
    # see https://bitbucket.org/pypa/setuptools/issue/130/install_data-doesnt-respect-prefix
    ${python}/bin/${python.executable} setup.py install_data --install-dir=$out --root=$out
    sed -i '/ = data_files/d' setup.py
  '';

  meta = {
    homepage = http://xpra.org/;
    description = "Persistent remote applications for X";
    platforms = stdenv.lib.platforms.linux;
  };
}
