{ stdenv, fetchurl, substituteAll, pkgconfig, meson, ninja, gettext, gnome3, wrapGAppsHook, packagekit, ostree
, glib, appstream-glib, libsoup, polkit, isocodes, gspell, libxslt, gobjectIntrospection, flatpak, fwupd
, json-glib, libsecret, valgrind-light, docbook_xsl, docbook_xml_dtd_42, docbook_xml_dtd_43, gtk-doc, desktop-file-utils }:

stdenv.mkDerivation rec {
  name = "gnome-software-${version}";
  version = "3.30.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-software/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1khbjsd7mnfqij46n4xk10fg12gcpr188gw6al9fdadpqqvqsd4d";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      inherit isocodes;
    })
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig gettext wrapGAppsHook libxslt docbook_xml_dtd_42 docbook_xml_dtd_43
    valgrind-light docbook_xsl gtk-doc desktop-file-utils gobjectIntrospection
  ];

  buildInputs = [
    gnome3.gtk glib packagekit appstream-glib libsoup
    gnome3.gsettings-desktop-schemas gnome3.gnome-desktop
    gspell json-glib libsecret ostree
    polkit flatpak fwupd
  ];

  mesonFlags = [
    "-Dubuntu_reviews=false"
    "-Dgudev=false"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-software";
      attrPath = "gnome3.gnome-software";
    };
  };

  meta = with stdenv.lib; {
    description = "Software store that lets you install and update applications and system extensions";
    homepage = https://wiki.gnome.org/Apps/Software;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
