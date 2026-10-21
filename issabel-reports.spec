%define modname reports
Summary: Issabel Reports Module
Name: issabel-reports
Version: 6.0.0
Release: 38
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
mv setup/issabelReportForm.class.php $RPM_BUILD_ROOT/var/www/html/libs/
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
* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-38
- Validate the asterisk log filter field by field. A date that was not
  in the list was replaced by the most recent one without telling anybody.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-37
- Validate the summary filter field by field. The filter was not validated
  at all and a date that was not a date was silently replaced by the
  current one, so the report showed another day than the one asked for.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-36
- Validate the CDR filter field by field. The errors went to a single
  global message that named the fields by their label, and the page fell
  back to the default filter, losing what the user had written.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-35
- Validate the destination distribution filter field by field. The errors
  went to a single global message that named the fields by their label, and
  the range of dates that was too wide was reported the same way.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-34
- Validate the billing report filter field by field. The filter was not
  validated at all, and a duration that was not a number made PHP 8 fail
  with a TypeError and the page answered 500.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-33
- Validate the missed calls filter field by field. The errors went to a
  single global message that named the fields by their label, and the page
  fell back to the current date instead of keeping what the user wrote.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-32
- Add the date validators to the shared form helper. The report filters
  take the dates as text, in the format the datepicker writes, and the
  server has to check them before using them in the query.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-31
- Add the shared form helper of the report modules. The validation of
  the filters and the forms follows the same pattern in the ten report
  pages: an array of errors per field, the page rendered again without a
  redirect and the failing field marked with is-invalid. The helper does
  the marking and the messages.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-30
- Bring the billing rate screens onto the theme. The view screen mixed
  the values and the controls, the edit screen wrote the colour of the
  history table by hand and the tables used the legacy classes of
  Elastix. The view is now a compact card with the values as text.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-29
- Show the default rate as plain text in the billing setup page. The view
  mode rendered the two values as disabled inputs, which is the pattern
  the style guide marks as wrong: the view has to be a compact card with
  the values as text.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-28
- Drop the server side images of the graphic report. The module drew
  the charts with GD and put the images in a variable that no template
  printed, so the code was unreachable. The charts are drawn in the
  browser with the Chart.js of the theme.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-27
- Use the theme Chart.js in the graphic report. The module shipped its
  own Chart.js 2.7.2, a plugin of data labels for the version 2, a copy of
  Moment and a copy of pdfMake, and the chart drew its series with
  colours written by hand. The chart now uses the copy of the theme, with
  the API of the version 4 and the plugin of labels that trae.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-26
- Use the theme Chart.js in the CDR report. The module shipped its own
  Chart.js 2.7.2 and drew the series with colours written by hand, which
  break in dark mode. The chart now uses the copy of the theme, with the
  API of the version 4.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-25
- Bring the CDR report page onto the theme. The page carried its own
  styles with hardcoded colours, a Bootstrap 3 modal that never opened
  because the theme does not ship the Bootstrap JavaScript inside the
  module frame, Font Awesome 4 and Bootstrap 3 icons, and a link to the
  Google Fonts CDN. The PDF button now prints the page, the way the grid
  exports do.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-24
- Use the theme grid and the theme Chart.js in the channel usage page. The
  module shipped its own Chart.js 2.7.2, a copy of Moment and a copy of
  pdfMake, all loaded on every visit, and the chart drew its series with
  colours written by hand. The PDF button now prints the page, the way
  the grid exports do.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-23
- Use the theme grid in the summary filter. The filter was a legacy table
  with the labels on the side. The Spanish language file also had two
  lines in latin-1, which broke the encoding check of the whole file.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-22
- Use the theme grid in the destination distribution page. The filter was a
  row of table cells with the labels on the side, and the summary table
  used the legacy table classes of Elastix.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-21
- Use the theme grid in the graphic report filter. The filter was a legacy
  table with the labels on the side, and the field of the extension and
  the one of the trunk were shown and hidden with inline styles decided
  by the browser.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-20
- Use the theme grid in the billing report filter. The filter was a legacy
  table, the units of the duration were written in Spanish in the English
  language file, and the script that switched between the text filter and
  the duration one was bound to every select of the page.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-19
- Use the theme grid in the missed calls filter. The filter was a legacy
  table with the labels on the side and no class of the theme, and the
  value field had no label at all.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-18
- Bring the asterisk log page onto the theme grid. The module shipped a
  frozen copy of the pre-restyle grid template with fifteen hardcoded
  colours, a Bootstrap 3 modal and Font Awesome 4 icons, none of which
  the modern theme defines. The page now uses the theme grid and the log
  levels take the severity colours of the theme.

* Wed Oct 21 2026 Issabel Foundation <info@issabel.org> - 6.0.0-17
- Send the CSRF token with the destination distribution filter. The form
  is served outside paloForm, so the helper had no form tag to inject the
  token into and every filter request was logged as a missing token.

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
