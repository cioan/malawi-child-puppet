if $osfamily == 'windows' {
    File { source_permissions => ignore }
}

$pih_home = hiera('pih_home')
$windows_openmrs_user = hiera('windows_openmrs_user')
$pih_home_bin = "${pih_home}\\bin"
$pih_java_home = "${pih_home}\\java"
$pih_tomcat_home = "${pih_home}\\tomcat\\"
$pih_mysql_home = "${pih_home}\\mysql"
$pih_putty_home = "${pih_home}\\putty"
$pih_gzip_home = "${pih_home}\\gzip"
$tail_exe = "${pih_home_bin}\\tail.exe"
$subinacl_exe = "${pih_home_bin}\\subinacl.exe"
	
node default {
	include pih_folders
	include gzip
	include pih_java
	include pih_tomcat
	include pih_mysql
	include putty
	include openmrs
}