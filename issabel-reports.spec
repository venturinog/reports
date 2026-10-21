%define modname reports
Summary: Issabel Reports Module
Name: issabel-reports
Version: 6.0.0
Release: 16
License: GPL
Group:   Applications/System
Source0: issabel-%{modname}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-root
BuildArch: noarch
Requires: issabel-framework >= 5.0.0-1
#Requires: asterisk
# graphic_report genera sus graficos con GD (reemplaza jpgraph).
Requires: php-gd
Requires: liberation-sans-fonts

Obsoletes: elastix-reports

%description
Issabel Reports Module

%prep
%setup -n %{name}-%{version}

%install
rm -rf $RPM_BUILD_ROOT

# Files provided by all Issabel modules
mkdir -p    $RPM_BUILD_ROOT/var/www/html/
mv modules/ $RPM_BUILD_ROOT/var/www/html/

# Additional (module-specific) files that can be handled by RPM
#mkdir -p $RPM_BUILD_ROOT/opt/issabel/
#mv setup/dialer

# The following folder should contain all the data that is required by the installer,
# that cannot be handled by RPM.
mkdir -p                             $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
mkdir -p                             $RPM_BUILD_ROOT/var/www/html/libs/
mv setup/paloSantoCDR.class.php      $RPM_BUILD_ROOT/var/www/html/libs/
mv setup/paloSantoTrunk.class.php    $RPM_BUILD_ROOT/var/www/html/libs/
mv setup/paloSantoRate.class.php     $RPM_BUILD_ROOT/var/www/html/libs/
mv setup/paloSantoQueue.class.php    $RPM_BUILD_ROOT/var/www/html/libs/
mv setup/                            $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
mv menu.xml                          $RPM_BUILD_ROOT/usr/share/issabel/module_installer/%{name}-%{version}-%{release}/

%pre
mkdir -p /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/
touch /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/preversion_%{modname}.info
if [ $1 -eq 2 ]; then
    rpm -q --queryformat='%%{VERSION}-%%{RELEASE}' %{name} > /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/preversion_%{modname}.info
fi

%post
pathModule="/usr/share/issabel/module_installer/%{name}-%{version}-%{release}"
# Run installer script to fix up ACLs and add module to Issabel menus.
issabel-menumerge /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/menu.xml

pathSQLiteDB="/var/www/db"
mkdir -p $pathSQLiteDB
preversion=`cat $pathModule/preversion_%{modname}.info`
rm $pathModule/preversion_%{modname}.info

if [ $1 -eq 1 ]; then #install
  # The installer database
    issabel-dbprocess "install" "$pathModule/setup/db"
elif [ $1 -eq 2 ]; then #update
    issabel-dbprocess "update"  "$pathModule/setup/db" "$preversion"
fi

# The installer script expects to be in /tmp/new_module
mkdir -p /tmp/new_module/%{modname}
cp -r /usr/share/issabel/module_installer/%{name}-%{version}-%{release}/* /tmp/new_module/%{modname}/
chown -R asterisk.asterisk /tmp/new_module/%{modname}

php /tmp/new_module/%{modname}/setup/installer.php
rm -rf /tmp/new_module

%clean
rm -rf $RPM_BUILD_ROOT

%preun
pathModule="/usr/share/issabel/module_installer/%{name}-%{version}-%{release}"
if [ $1 -eq 0 ] ; then # Validation for desinstall this rpm
  echo "Delete Reports menus"
  issabel-menuremove "%{modname}"

  echo "Dump and delete %{name} databases"
  issabel-dbprocess "delete" "$pathModule/setup/db"
fi

%files
%defattr(-, root, root)
%{_localstatedir}/www/html/*
/usr/share/issabel/module_installer/*

%changelog
* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-16
- Handle the cancel button in the billing setup page. The button had no
  branch, so the page fell through and re-rendered the form instead of
  discarding the edit, and the redirect after saving did not stop the
  module. The wrapper around the trunk grid was also removed: the theme
  grid already carries its own form.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-15
- Remove the nested forms from the billing rate screens. Each screen
  built its form in the PHP wrapper and the template had one too, so the
  browser discarded the inner tag and the id and namerate parameters only
  survived by accident. The form now lives only in the template and the
  parameters travel in hidden fields.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-14
- Send the CSRF token with the graphic report filter. The form was
  built in the PHP wrapper, so paloForm found no form tag to inject the
  token into and the page was saved without one. The form now lives in
  the template.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-13
- Render the summary call details with the theme Chart.js.
  The pop-up asked the server for two PNG images drawn with jpgraph,
  which does not exist in Rocky Linux 10, so both images were broken.
  The two pie charts are now drawn in the browser with the Chart.js copy
  of the theme.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-12
- Render the destination distribution chart with the theme Chart.js.
  The page required jpgraph, which does not exist in Rocky Linux 10, and
  answered HTTP 500 on every visit. The pie chart is now drawn in the
  browser with the Chart.js copy of the theme, and the read-only image
  request is gone.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-11
- Drop the dead jpgraph include from the channel usage page. The
  library was never used there: the chart is drawn in the browser. It
  required jpgraph, which does not exist in Rocky Linux 10, and aborted
  the page with HTTP 500 before anything was rendered.

* Fri Oct 16 2026 Issabel Foundation <info@issabel.org> - 6.0.0-10
- Escape the rpm queryformat used to record the pre-version on upgrade.
  The VERSION and RELEASE macros were expanded at build time, so %pre always
  wrote the new version and issabel-dbprocess skipped every version_sql
  migration. They are now escaped so rpm expands them at run time.

* Mon Oct 12 2026 Issabel Foundation <info@issabel.org> - 6.0.0-9
- Convert the CDR filter form to the Modern form kit (labels above fields,
  section card, Filter button on the card footer) and dress the jQuery UI
  datepicker trigger alongside the input.

* Mon Oct 12 2026 Issabel Foundation <info@issabel.org> - 6.0.0-8
- Switch the CDR filter to the Bootstrap 5 collapse attribute
  (data-bs-toggle); the BS3 data-toggle was ignored by the modern theme,
  leaving the Show Filter button dead.

* Mon Oct 12 2026 Issabel Foundation <info@issabel.org> - 6.0.0-7
- Bind the CDR "Show Filter" button as well (it had no click handler, only
  the caret did) and add the missing datatables.en.json language file so
  the CDR report stops requesting it with a 404.

* Sun Oct 11 2026 Issabel Foundation <info@issabel.org> - 6.0.0-5
- Remove hardcoded light/dark colours from the asterisk_log and billing_rates
  templates so they follow the theme in dark mode.

* Sat Oct 10 2026 Issabel Foundation <info@issabel.org> - 6.0.0-4
- Reports: make the CDR, Channel Usage and Graphic Report charts follow the dark
  theme (canvas background and Chart.js text/grid colours) and use the official
  Issabel brand purple (#572364).

* Fri Oct 09 2026 Issabel Foundation <info@issabel.org> - 6.0.0-3
- Require the unversioned PHP packages (php-*, 8.3 on EL10) instead of the
  versioned php8.4-*, which conflict with the PHP 8.3 in the netinstall base.
